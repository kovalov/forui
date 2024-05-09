import 'package:flutter/material.dart';

import 'package:forui/forui.dart';

/// Represents a ForUI theme.
class FTheme extends StatefulWidget {
  /// Retrieves the theme data.
  static FThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<_InheritedTheme>();
    return theme?.data ?? FZincTheme.light;
  }

  /// The theme data.
  final FThemeData data;

  /// The child widget.
  final Widget child;

  /// Creates a [FTheme].
  const FTheme({
    required this.data,
    required this.child,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<FTheme> {
  late FThemeData data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) => _InheritedTheme(data: data, child: widget.child);
}

class _InheritedTheme extends InheritedWidget {
  final FThemeData data;

  const _InheritedTheme({required this.data, required super.child});

  @override
  bool updateShouldNotify(covariant _InheritedTheme old) => data != old.data;
}
