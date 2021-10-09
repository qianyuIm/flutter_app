import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/widget/music/music_transparent_flexible_space_bar.dart';

class MusicTransparentHeader extends StatefulWidget {
  final Widget? title;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final IconThemeData? iconTheme;
  final TextStyle? titleTextStyle;
  final double? expandedHeight;
  final Widget? background;
  final Widget? content;
  /// EdgeInsets.only(bottom: 16.0,);
  final EdgeInsetsGeometry? contentPadding;
  ///  Alignment.bottomCenter;
  final AlignmentGeometry? contentAlignment;

  final PreferredSizeWidget? bottom;
  final bool pinned;
  final bool stretch;
  final List<Widget>? actions;
  final CollapseMode collapseMode;
  final List<MusicTransparentStretchMode> stretchModes;
  const MusicTransparentHeader(
      {Key? key,
      this.title,
      this.systemOverlayStyle,
      this.iconTheme,
      this.titleTextStyle,
      this.expandedHeight,
      this.background,
      this.content,
      this.contentPadding,
      this.pinned = true,
      required this.stretch,
      this.bottom,
      this.actions,
      this.collapseMode = CollapseMode.parallax,
      this.stretchModes = const <MusicTransparentStretchMode>[
        MusicTransparentStretchMode.zoomBackground
      ], this.contentAlignment})
      : super(key: key);

  @override
  _MusicTransparentHeaderState createState() => _MusicTransparentHeaderState();
}

class _MusicTransparentHeaderState extends State<MusicTransparentHeader> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: widget.title,
      systemOverlayStyle: widget.systemOverlayStyle,
      iconTheme: widget.iconTheme,
      titleTextStyle: widget.titleTextStyle,
      expandedHeight: widget.expandedHeight,
      actions: widget.actions,
      bottom: widget.bottom,
      stretch: widget.stretch,
      pinned: widget.pinned,
      flexibleSpace: MusicTransparentFlexibleSpaceBar(
        background: widget.background,
        content: widget.content,
        contentPadding: widget.contentPadding,
        contentAlignment: widget.contentAlignment,
        collapseMode: widget.collapseMode,
        stretchModes: widget.stretchModes,
      ),
    );
  }
}
