import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';

/// Main scaffold widget
class CoolScaffold extends StatelessWidget {
  final Widget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  
  const CoolScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.floatingActionButton,
    this.backgroundColor,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
  });
  
  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final bgColor = backgroundColor ?? 
        coolColors?.resolve(CoolColorToken.background) ?? 
        Colors.transparent;
    
    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBar != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: appBar!,
            )
          : null,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }
}

