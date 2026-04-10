import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  static Future<void> launchUrlString(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static Future<void> launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static Future<void> launchWhatsApp(String phone, {String? message}) async {
    // Basic implementation, can be more complex
    final url = "https://wa.me/$phone${message != null ? '?text=${Uri.encodeComponent(message)}' : ''}";
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
