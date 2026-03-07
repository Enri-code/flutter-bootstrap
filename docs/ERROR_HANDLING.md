# Error Handling Guide

This package provides a comprehensive, production-ready error handling system that separates errors by **how they should be presented to users** rather than architectural concerns.

## Table of Contents

1. [Core Concepts](#core-concepts)
2. [Error Types](#error-types)
3. [Setup](#setup)
4. [Usage Examples](#usage-examples)
5. [Best Practices](#best-practices)

---

## Core Concepts

### Error Presentation Strategy

Errors are categorized by how they should be shown to users:

```dart
enum ErrorPresentation {
  silent,  // Log only, don't show to user
  toast,   // Brief message (3-5 seconds)
  dialog,  // Requires user dismissal
  inline,  // Show next to form fields
}
```

### Three Error Classes

1. **`AppError`** - Internal/silent errors (logging only)
2. **`UserError`** - User-facing errors with presentation hints
3. **`ValidationError`** - Form validation with field-level details

---

## Error Types

### 1. AppError (Silent/Internal)

Use for errors that users shouldn't see (internal failures, debugging).

```dart
// Simple internal error
throw AppError(
  message: 'Cache invalidation failed',
  code: 'CACHE_ERROR',
);

// From caught exception
try {
  await database.query();
} catch (e, stack) {
  throw AppError.fromObject(e, stack);
}
```

### 2. UserError (User-Facing)

The main error type for user-facing errors. Has convenient factory constructors:

#### Network Errors (Toast)
```dart
try {
  await api.fetchData();
} catch (e, stack) {
  throw UserError.network(); // Default message
  // OR custom message
  throw UserError.network(
    message: 'Unable to load your data. Please try again.',
    error: e,
    stackTrace: stack,
  );
}
```

#### Server Errors (Toast)
```dart
if (response.statusCode >= 500) {
  throw UserError.server(
    statusCode: response.statusCode,
    message: 'Our servers are having issues. Please try again later.',
  );
}
```

#### Authentication Errors (Dialog)
```dart
if (!isAuthenticated) {
  throw UserError.authentication(
    message: 'Your session has expired. Please log in again.',
  );
}
```

#### Authorization Errors (Toast)
```dart
if (!hasPermission) {
  throw UserError.forbidden(
    message: 'You need admin privileges to perform this action.',
  );
}
```

#### Business Rule Violations (Dialog - customizable)
```dart
if (user.balance < withdrawAmount) {
  throw UserError.business(
    message: 'Insufficient balance. You have \$${user.balance} available.',
    presentation: ErrorPresentation.dialog, // Can be changed
  );
}

// Or as a toast
throw UserError.business(
  message: 'Maximum 5 items per order',
  presentation: ErrorPresentation.toast,
);
```

#### Device Permission Errors (Dialog)
```dart
if (!cameraGranted) {
  throw UserError.permission(
    permission: 'Camera',
    message: 'Camera access is required to scan QR codes.',
  );
}
```

#### Custom User Errors
```dart
throw UserError(
  code: 'CUSTOM_ERROR',
  message: 'Something specific went wrong',
  presentation: ErrorPresentation.toast,
  isRetryable: true,
);
```

### 3. ValidationError (Form/Inline)

For form validation with field-level errors:

#### Multiple Field Errors
```dart
final errors = <String, String>{};

if (email.isEmpty) {
  errors['email'] = 'Email is required';
} else if (!isValidEmail(email)) {
  errors['email'] = 'Please enter a valid email';
}

if (password.length < 8) {
  errors['password'] = 'Password must be at least 8 characters';
}

if (errors.isNotEmpty) {
  throw ValidationError(fields: errors);
}
```

#### Single Field Error
```dart
if (username.contains(' ')) {
  throw ValidationError.field('username', 'Username cannot contain spaces');
}
```

---

## Setup

### 1. Initialize Global Error Handler

In your `main.dart`:

```dart
import 'package:bootstrap/services/error_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DI and services first
  await initializeDependencies();

  // Create error handler
  final errorHandler = ErrorHandler(
    toastService: DI().get<IToastService>(),
    logger: DI().get<Logger>(),
    onUnhandledError: (error, stack) {
      // Optional: Send to crash reporting (Firebase Crashlytics, Sentry, etc.)
      // crashlytics.recordError(error, stack);
    },
  );

  // Set global Flutter error handler
  FlutterError.onError = (details) {
    errorHandler.handleFlutterError(details);
  };

  // Set global async error handler
  PlatformDispatcher.instance.onError = (error, stack) {
    errorHandler.handleError(error, stack);
    return true; // Mark as handled
  };

  runApp(MyApp());
}
```

### 2. Wrap Your App with ToastServiceProvider

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ToastServiceProvider(
      service: DI().get<IToastService>(),
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
```

---

## Usage Examples

### In Repositories/Data Layer

```dart
class UserRepository {
  Future<User> getUser(String id) async {
    try {
      final response = await _api.get('/users/$id');

      if (response.statusCode == 404) {
        throw UserError.notFound(message: 'User not found');
      }

      if (response.statusCode >= 500) {
        throw UserError.server(statusCode: response.statusCode);
      }

      return User.fromJson(response.data);
    } on SocketException catch (e, stack) {
      throw UserError.network(error: e, stackTrace: stack);
    } catch (e, stack) {
      // Wrap unknown errors
      throw AppError.fromObject(e, stack);
    }
  }
}
```

### In Use Cases/Business Logic

```dart
class TransferMoneyUseCase {
  Future<void> call({
    required String fromAccount,
    required String toAccount,
    required double amount,
  }) async {
    // Business rule validation
    final balance = await _accountRepo.getBalance(fromAccount);

    if (balance < amount) {
      throw UserError.business(
        message: 'Insufficient funds. Available: \$$balance',
        code: 'INSUFFICIENT_FUNDS',
      );
    }

    if (amount > 10000) {
      throw UserError.business(
        message: 'Maximum transfer amount is \$10,000',
        code: 'AMOUNT_EXCEEDS_LIMIT',
      );
    }

    try {
      await _accountRepo.transfer(fromAccount, toAccount, amount);
    } catch (e, stack) {
      throw UserError.server(
        message: 'Transfer failed. Please try again.',
        error: e,
        stackTrace: stack,
      );
    }
  }
}
```

### In UI Layer (with Context)

```dart
class LoginPage extends StatelessWidget {
  Future<void> _handleLogin(BuildContext context) async {
    try {
      await loginUseCase(email, password);
      Navigator.pushReplacement(context, HomePage());
    } catch (error, stack) {
      // Use context extension for proper dialog/toast handling
      context.handleError(error, stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleLogin(context),
      child: Text('Login'),
    );
  }
}
```

### Form Validation with FormErrorState

```dart
class SignupForm extends StatefulWidget {
  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formErrors = FormErrorState();

  String email = '';
  String password = '';
  String confirmPassword = '';

  void _validateAndSubmit() {
    _formErrors.clearAll();

    // Validate email
    if (email.isEmpty) {
      _formErrors.setError('email', 'Email is required');
    } else if (!_isValidEmail(email)) {
      _formErrors.setError('email', 'Please enter a valid email');
    }

    // Validate password
    if (password.isEmpty) {
      _formErrors.setError('password', 'Password is required');
    } else if (password.length < 8) {
      _formErrors.setError('password', 'Must be at least 8 characters');
    }

    // Validate password match
    if (password != confirmPassword) {
      _formErrors.setError('confirmPassword', 'Passwords do not match');
    }

    if (_formErrors.hasErrors) {
      setState(() {}); // Trigger rebuild to show errors
      return;
    }

    // Proceed with signup
    _signup();
  }

  Future<void> _signup() async {
    try {
      await signupUseCase(email, password);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => HomePage(),
      ));
    } on ValidationError catch (e) {
      // Server-side validation errors
      _formErrors.applyValidationError(e);
      setState(() {});
    } catch (error, stack) {
      context.handleError(error, stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: _formErrors.getError('email'),
          ),
          onChanged: (value) {
            email = value;
            _formErrors.clearError('email');
            setState(() {});
          },
        ),
        SizedBox(height: 16),

        TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: _formErrors.getError('password'),
          ),
          obscureText: true,
          onChanged: (value) {
            password = value;
            _formErrors.clearError('password');
            setState(() {});
          },
        ),
        SizedBox(height: 16),

        TextField(
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            errorText: _formErrors.getError('confirmPassword'),
          ),
          obscureText: true,
          onChanged: (value) {
            confirmPassword = value;
            _formErrors.clearError('confirmPassword');
            setState(() {});
          },
        ),
        SizedBox(height: 24),

        ElevatedButton(
          onPressed: _validateAndSubmit,
          child: Text('Sign Up'),
        ),
      ],
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
```

### Using FieldErrorText Widget

```dart
TextField(
  decoration: InputDecoration(labelText: 'Email'),
  onChanged: (value) => email = value,
),
FieldErrorText(error: _formErrors.getError('email')),
```

---

## Best Practices

### 1. **Choose the Right Error Type**

- ✅ **UserError.network()** for connectivity issues
- ✅ **UserError.server()** for 5xx responses
- ✅ **UserError.authentication()** for login failures
- ✅ **UserError.business()** for business rule violations
- ✅ **ValidationError** for form validation
- ✅ **AppError** for internal errors users shouldn't see

### 2. **Provide Helpful Messages**

```dart
// ❌ Bad: Generic
throw UserError.business(message: 'Error occurred');

// ✅ Good: Specific and actionable
throw UserError.business(
  message: 'You can only have 3 active subscriptions. '
           'Please cancel one before adding another.',
);
```

### 3. **Use Error Codes for Tracking**

```dart
throw UserError.business(
  code: 'MAX_SUBSCRIPTIONS_REACHED',
  message: 'Maximum subscription limit reached',
);

// Later in analytics
analytics.logError(error.code, error.message);
```

### 4. **Handle Errors at the Right Level**

- **Repository**: Catch low-level errors (network, parsing), convert to domain errors
- **Use Case**: Enforce business rules, throw business errors
- **UI**: Catch and display errors using `context.handleError()`

### 5. **Always Include Stack Traces**

```dart
try {
  await riskyOperation();
} catch (e, stack) {  // ✅ Capture stack
  throw UserError.network(error: e, stackTrace: stack);
}
```

### 6. **Mark Retryable Errors**

```dart
// Network errors are retryable
throw UserError.network(); // isRetryable = true by default

// Business rules are not retryable
throw UserError.business(
  message: 'Account is suspended',
); // isRetryable = false
```

### 7. **Use Presentation Strategically**

```dart
// Minor issues → Toast
throw UserError(
  message: 'Failed to load comments',
  presentation: ErrorPresentation.toast,
);

// Important issues → Dialog
throw UserError(
  message: 'Payment failed. No charges were made.',
  presentation: ErrorPresentation.dialog,
);

// Don't show to user → Silent
throw AppError(message: 'Cache miss on user preferences');
```

---

## Error Flow Example

```
┌─────────────────┐
│   User Action   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   UI Layer      │ ◄── Catches errors, calls context.handleError()
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Use Case      │ ◄── Validates business rules, throws UserError/ValidationError
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Repository    │ ◄── Handles data access, throws UserError for network/server issues
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Data Source   │ ◄── API, Database, etc.
└─────────────────┘
```

When an error occurs:
1. **Repository** catches low-level errors → converts to `UserError.network()` or `UserError.server()`
2. **Use Case** validates business rules → throws `UserError.business()` or `ValidationError`
3. **UI** catches errors → calls `context.handleError()` → shows dialog/toast based on `ErrorPresentation`
4. **ErrorHandler** logs everything → sends to crash reporting if configured

---

## Complete Example

```dart
// repository.dart
class ProductRepository {
  Future<Product> getProduct(String id) async {
    try {
      final response = await api.get('/products/$id');
      return Product.fromJson(response.data);
    } on SocketException {
      throw UserError.network();
    } catch (e, stack) {
      throw UserError.server(error: e, stackTrace: stack);
    }
  }
}

// use_case.dart
class PurchaseProductUseCase {
  Future<void> call(String productId, int quantity) async {
    final product = await productRepo.getProduct(productId);
    final user = await userRepo.getCurrentUser();

    // Business validation
    if (!product.isAvailable) {
      throw UserError.business(
        message: '${product.name} is currently out of stock',
        code: 'PRODUCT_UNAVAILABLE',
      );
    }

    if (user.balance < product.price * quantity) {
      throw UserError.business(
        message: 'Insufficient balance. You need \$${product.price * quantity}',
        presentation: ErrorPresentation.dialog,
      );
    }

    await orderRepo.createOrder(productId, quantity);
  }
}

// ui.dart
class ProductPage extends StatelessWidget {
  Future<void> _purchase(BuildContext context) async {
    try {
      await purchaseUseCase('product-123', 2);

      // Show success
      context.toast.showToast('Purchase successful!', type: ToastType.success);
      Navigator.pop(context);

    } catch (error, stack) {
      // Automatically shows dialog/toast based on error type
      context.handleError(error, stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _purchase(context),
      child: Text('Buy Now'),
    );
  }
}
```

This will automatically:
- Show network errors as toasts
- Show business rule violations as dialogs
- Log everything for debugging
- Send to crash reporting (if configured)
