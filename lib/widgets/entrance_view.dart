import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bootstrap/core.dart';

/// Wraps a column or list of children and seamlessly stagger-animates them
/// sliding and fading up gracefully. Gives a highly premium, reactive feel
/// without invasive code changes to the structure.
class BootstrapEntrance extends StatelessWidget {
  const BootstrapEntrance({
    required this.children,
    this.delay = Duration.zero,
    this.interval = const Duration(milliseconds: 50),
    super.key,
  });

  final List<Widget> children;
  final Duration delay;
  final Duration interval;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: AnimateList(
        delay: delay,
        interval: interval,
        effects: [
          const FadeEffect(
            duration: BootstrapAnimations.normal,
            curve: BootstrapAnimations.emphasizedDecelerate,
          ),
          const SlideEffect(
            begin: Offset(0, 0.2),
            end: Offset.zero,
            duration: BootstrapAnimations.normal,
            curve: BootstrapAnimations.emphasizedDecelerate,
          ),
        ],
        children: children,
      ),
    );
  }
}
