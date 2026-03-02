import 'package:flutter/material.dart';

/// A custom IndexedStack that animates transitions between children using
/// the Material Design "Fade Through" pattern (fade out, scale up, fade in).
/// It preserves the state of inactive children using [Offstage].
class FadeThroughIndexedStack extends StatefulWidget {
  const FadeThroughIndexedStack({
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
    super.key,
  });

  final int index;
  final List<Widget> children;
  final Duration duration;

  @override
  State<FadeThroughIndexedStack> createState() =>
      _FadeThroughIndexedStackState();
}

class _FadeThroughIndexedStackState extends State<FadeThroughIndexedStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeOut;
  late Animation<double> _fadeIn;

  int _prevIndex = 0;

  @override
  void initState() {
    super.initState();
    _prevIndex = widget.index;
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _fadeOut = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        // Using a smooth ease out for the outgoing view
        curve: Curves.fastOutSlowIn,
      ),
    );

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        // Using a smooth ease in for the incoming view
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  void didUpdateWidget(FadeThroughIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0).then((_) {
        // We only update the previous index when the animation finishes
        if (mounted) {
          setState(() {
            _prevIndex = widget.index;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List<Widget>.generate(widget.children.length, (int i) {
        final child = widget.children[i];
        final isCurrent = i == widget.index;
        final isPrevious = i == _prevIndex;

        // Inactive tabs stay offstage to preserve state
        if (!isCurrent && !isPrevious) {
          return Offstage(
            child: TickerMode(enabled: false, child: child),
          );
        }

        // If no animation is running
        if (isCurrent && isPrevious) {
          return child;
        }

        // Fading out the old tab (no TickerMode disabling here so it doesn't freeze jarringly)
        if (isPrevious) {
          return FadeTransition(
            opacity: _fadeOut,
            child: child,
          );
        }

        // Fading in the new tab smoothly
        return FadeTransition(
          opacity: _fadeIn,
          child: child,
        );
      }),
    );
  }
}
