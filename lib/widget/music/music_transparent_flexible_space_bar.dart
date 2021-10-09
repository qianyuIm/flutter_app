import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

enum MusicTransparentStretchMode {
  zoomBackground,

  blurBackground,

  fadeContent,
}

class MusicTransparentFlexibleSpaceBar extends StatefulWidget {
  const MusicTransparentFlexibleSpaceBar({
    Key? key,
    this.content,
    this.background,
    this.contentPadding,
    this.collapseMode = CollapseMode.parallax,
    this.stretchModes = const <MusicTransparentStretchMode>[
      MusicTransparentStretchMode.zoomBackground
    ],
    this.contentAlignment,
  }) : super(key: key);

  final Widget? content;

  final Widget? background;

  final CollapseMode collapseMode;

  final List<MusicTransparentStretchMode> stretchModes;

  /// EdgeInsets.only(bottom: 16.0,);
  final EdgeInsetsGeometry? contentPadding;

  ///  Alignment.bottomCenter;
  final AlignmentGeometry? contentAlignment;

  @override
  _MusicTransparentFlexibleSpaceBarState createState() => _MusicTransparentFlexibleSpaceBarState();
}

class _MusicTransparentFlexibleSpaceBarState extends State<MusicTransparentFlexibleSpaceBar> {
  double _getCollapsePadding(double t, FlexibleSpaceBarSettings settings) {
    switch (widget.collapseMode) {
      case CollapseMode.pin:
        return -(settings.maxExtent - settings.currentExtent);
      case CollapseMode.none:
        return 0.0;
      case CollapseMode.parallax:
        final double deltaExtent = settings.maxExtent - settings.minExtent;
        return -Tween<double>(begin: 0.0, end: deltaExtent / 4.0).transform(t);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final FlexibleSpaceBarSettings? settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        assert(
          settings != null,
          'A FlexibleSpaceBar must be wrapped in the widget returned by FlexibleSpaceBar.createSettings().',
        );

        final List<Widget> children = <Widget>[];

        final double deltaExtent = settings!.maxExtent - settings.minExtent;

        // 0.0 -> Expanded
        // 1.0 -> Collapsed to toolbar
        final double t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0);

        // background
        if (widget.background != null) {
          double height = settings.maxExtent;

          // StretchMode.zoomBackground
          if (widget.stretchModes.contains(MusicTransparentStretchMode.zoomBackground) &&
              constraints.maxHeight > height) {
            height = constraints.maxHeight;
          }
          children.add(Positioned(
            top: _getCollapsePadding(t, settings),
            left: 0.0,
            right: 0.0,
            height: height,
            child: Opacity(
              // IOS is relying on this semantics node to correctly traverse
              // through the app bar when it is collapsed.
              alwaysIncludeSemantics: true,
              opacity: 1,
              child: widget.background,
            ),
          ));

          // StretchMode.blurBackground
          if (widget.stretchModes.contains(MusicTransparentStretchMode.blurBackground) &&
              constraints.maxHeight > settings.maxExtent) {
            final double blurAmount =
                (constraints.maxHeight - settings.maxExtent) / 10;
            children.add(Positioned.fill(
              child: BackdropFilter(
                child: Container(
                  color: Colors.transparent,
                ),
                filter: ui.ImageFilter.blur(
                  sigmaX: blurAmount,
                  sigmaY: blurAmount,
                ),
              ),
            ));
          }
        }

        // title
        if (widget.content != null) {
          final ThemeData theme = Theme.of(context);

          Widget? content;
          switch (theme.platform) {
            case TargetPlatform.iOS:
            case TargetPlatform.macOS:
              content = widget.content;
              break;
            case TargetPlatform.android:
            case TargetPlatform.fuchsia:
            case TargetPlatform.linux:
            case TargetPlatform.windows:
              content = Semantics(
                namesRoute: true,
                child: widget.content,
              );
              break;
          }

          // StretchMode.fadeContent
          if (widget.stretchModes.contains(MusicTransparentStretchMode.fadeContent)) {
            final double fadeStart =
                math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
            const double fadeEnd = 1.0;
            assert(fadeStart <= fadeEnd);
            final double opacity =
                1.0 - Interval(fadeStart, fadeEnd).transform(t);
            content = Opacity(
              opacity: opacity,
              child: content,
            );
          }

          final double opacity = settings.toolbarOpacity;
          if (opacity > 0.0) {
            final EdgeInsetsGeometry padding = widget.contentPadding ??
                EdgeInsets.only(
                  bottom: 16.0,
                );
            final AlignmentGeometry alignment =
                widget.contentAlignment ?? Alignment.bottomCenter;
            children.add(Container(
              padding: padding,
              child: Align(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      width: constraints.maxWidth,
                      alignment: alignment,
                      child: content,
                    );
                  },
                ),
              ),
            ));
          }
        }

        return ClipRect(child: Stack(children: children));
      },
    );
  }
}
