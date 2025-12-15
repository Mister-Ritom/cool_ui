import 'package:flutter/material.dart';
import '../foundation/color_system.dart';
import '../foundation/theme.dart';
import '../foundation/state_resolver.dart';
import '../foundation/interaction_state.dart';
import '../foundation/animated_surface.dart';

typedef OnSelectCallback =
    void Function(int index, HorizontalSelectionItem item);

class HorizontalSelectionItem {
  final IconData? icon;
  final String? title;

  const HorizontalSelectionItem({this.icon, this.title});
}

class CoolHorizontalSliderSelector extends StatefulWidget {
  final List<HorizontalSelectionItem> items;
  final int visibleItemCount;
  final int initialIndex;
  final OnSelectCallback? onSelect;
  final Duration animationDuration;
  final Curve opacityFalloffCurve;
  final double? itemSpacing;
  final double? itemWidth;
  final bool emphasizeSelected;

  const CoolHorizontalSliderSelector({
    super.key,
    required this.items,
    this.visibleItemCount = 3,
    this.initialIndex = 0,
    this.onSelect,
    this.animationDuration = const Duration(milliseconds: 350),
    this.opacityFalloffCurve = Curves.easeOut,
    this.itemSpacing,
    this.itemWidth,
    this.emphasizeSelected = true,
  });

  @override
  State<CoolHorizontalSliderSelector> createState() =>
      _CoolHorizontalSliderSelectorState();
}

class _CoolHorizontalSliderSelectorState
    extends State<CoolHorizontalSliderSelector> {
  late PageController _pageController;
  late int _currentPage;
  late final CoolInteractionStateManager _stateManager;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex.clamp(0, widget.items.length - 1);
    _pageController = PageController(
      viewportFraction: 1 / widget.visibleItemCount,
      initialPage: _currentPage,
    );
    _stateManager = CoolInteractionStateManager();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _stateManager.dispose();
    super.dispose();
  }

  void _animateTo(int index) {
    _pageController.animateToPage(
      index,
      duration: widget.animationDuration,
      curve: Curves.easeOutCubic,
    );
  }

  double _lookupOpacity(double dist) {
    const lookup = [1.0, 0.7, 0.5, 0.3, 0.0];
    if (dist <= 0) return 1.0;
    if (dist >= lookup.length - 1) return lookup.last;
    final low = dist.floor();
    final high = low + 1;
    final frac = dist - low;
    return lookup[low] + (lookup[high] - lookup[low]) * frac;
  }

  @override
  Widget build(BuildContext context) {
    final coolColors = context.coolColors;
    final coolTheme = context.coolTheme;

    if (coolColors == null || coolTheme == null) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final viewportFraction = widget.itemWidth != null
            ? widget.itemWidth!.clamp(10, width) / width
            : 1 / widget.visibleItemCount;

        if ((_pageController.viewportFraction - viewportFraction).abs() >
            0.001) {
          final page = _pageController.hasClients
              ? (_pageController.page ?? _currentPage.toDouble())
              : _currentPage.toDouble();
          _pageController.dispose();
          _pageController = PageController(
            viewportFraction: viewportFraction,
            initialPage: page.round(),
          );
        }

        return ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                Colors.black,
                Colors.black,
                Colors.transparent,
              ],
              stops: [0.0, 0.12, 0.88, 1.0],
            ).createShader(rect);
          },
          child: SizedBox(
            height: 120,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length,
              onPageChanged: (index) {
                _currentPage = index;
                widget.onSelect?.call(index, widget.items[index]);
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, _) {
                    final page = _pageController.hasClients
                        ? (_pageController.page ?? _currentPage.toDouble())
                        : _currentPage.toDouble();

                    final dist = (index - page).abs();
                    final t = widget.opacityFalloffCurve.transform(
                      dist.clamp(0.0, 4.0) / 4.0,
                    );

                    final rawOpacity = _lookupOpacity(t * 4);

                    final scale = widget.emphasizeSelected
                        ? 1.0 + ((1.0 - dist.clamp(0.0, 1.0)) * 0.06)
                        : 1.0;

                    final isSelected = dist < 0.01;

                    final stateResolver = CoolStateResolver(
                      colorSystem: coolColors,
                      state: isSelected
                          ? CoolInteractionState.pressed
                          : CoolInteractionState.idle,
                      isEnabled: true,
                    );

                    final baseColor = stateResolver.resolveColor(
                      CoolColorToken.text,
                    );

                    final fgColor = baseColor.withValues(
                      alpha: (baseColor.a * rawOpacity),
                    );

                    final item = widget.items[index];

                    return Center(
                      child: Transform.scale(
                        scale: scale,
                        child: GestureDetector(
                          onTap: () => _animateTo(index),
                          child: CoolAnimatedSurface(
                            stateManager: _stateManager,
                            backgroundColor: Colors.transparent,
                            tintColor: isSelected
                                ? stateResolver.resolveColor(
                                    CoolColorToken.pressed,
                                  )
                                : null,
                            radius: context.coolRadius,
                            isFilled: false,
                            child: SizedBox(
                              width:
                                  widget.itemWidth ?? width * viewportFraction,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (item.icon != null)
                                    Icon(item.icon, color: fgColor),
                                  if (item.icon != null && item.title != null)
                                    const SizedBox(width: 8),
                                  if (item.title != null)
                                    Text(
                                      item.title!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: fgColor,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
