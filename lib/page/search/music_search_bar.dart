import 'package:flutter/material.dart';
import 'package:flutter_app/generated/l10n.dart';
import 'package:flutter_app/network/music_api/music_api_search_imp.dart';
import 'package:flutter_app/view_model/theme_view_model.dart';

const double kDefaultSearchBarHeight = 44;

typedef MusicSearchBarVoid = void Function();

class MusicSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final MusicSearchBarVoid? onCancel;
  final MusicSearchBarVoid? onClear;
  final MusicSearchBarVoid? onTap;
  final ValueChanged<String>? onSearch;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry padding;
  final bool showCancel;
  final bool loadHint;
  final bool enabled;
  final bool topSafeArea;
  const MusicSearchBar({
    Key? key,
    this.controller,
    this.focusNode,
    this.showCancel = true,
    this.loadHint = true,
    this.enabled = true,
    this.topSafeArea = true,
    this.padding = const EdgeInsets.only(left: 16),
    this.onCancel,
    this.onClear,
    this.onTap,
    this.onChanged,
    this.onSearch,
  }) : super(key: key);
  @override
  _MusicSearchBarState createState() => _MusicSearchBarState();
}

class _MusicSearchBarState extends State<MusicSearchBar> {
  late TextEditingController _controller;
  late String _defaultHintText;
  late Future<String> _future;
  late ValueNotifier<String> _onTextChanged = ValueNotifier('');
  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _defaultHintText = '搜索音乐、视频、博客、歌词';
    _future = _loadSearchDefaultData();
    _onTextChanged.addListener(_textChanged);
    super.initState();
  }

  @override
  void dispose() {
    // 默认没有传入controller,需要内部释放
    if (widget.controller == null) {
      _controller.dispose();
    }
    _onTextChanged.removeListener(_textChanged);
    super.dispose();
  }

  /// 文字改变时 使用ValueNotifier做个限制否则中文会触发两次回调
  void _textChanged() {
    widget.onChanged?.call(_onTextChanged.value);
  }

  Future<String> _loadSearchDefaultData() async {
    if (widget.loadHint) {
      var response = await MusicApiSearchImp.loadSearchDefaultData();
      return response.realkeyword ?? _defaultHintText;
    } else {
      return _defaultHintText;
    }
  }

  Widget _buildSearchBar(BuildContext context) {
    var primaryColor = AppTheme.of(context).primaryColor;
    return FutureBuilder<String>(
      future: _future,
      initialData: _defaultHintText,
      builder: (context, snapshot) {
        var hintText = snapshot.data;
        return Container(
          height: 40,
          child: TextField(
            enabled: widget.enabled,
              focusNode: widget.focusNode,
              controller: _controller,
              autofocus: false,
              textInputAction: TextInputAction.search,
              onTap: widget.onTap,

              // keyboardType: TextInputType.datetime,
              onChanged: (value) {
                _onTextChanged.value = value;
              },
              onSubmitted: (value) {
                var submitValue = value;
                // 判断
                if (value.length == 0 &&
                    hintText != null &&
                    hintText != _defaultHintText) {
                  submitValue = hintText;
                }
                widget.onSearch?.call(submitValue);
              },
              cursorColor: primaryColor,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                filled: true,
                fillColor: AppTheme.cardColor(context),
                
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: primaryColor,
                ),
                suffixIcon: MusicSearchBarSuffixIcon(
                  controller: _controller,
                  onClear: widget.onClear,
                ),
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = TextButton(
      onPressed: () {
        widget.onCancel?.call();
      },
      child: Text(
        S.of(context).cancel,
        style: AppTheme.titleStyle(context).copyWith(fontSize: 15),
      ),
    );
    return SafeArea(
      top: widget.topSafeArea,
      bottom: false,
      child: Container(
        padding: widget.padding,
        height: kDefaultSearchBarHeight,
        child: Row(
          children: [
            Expanded(child: _buildSearchBar(context)),
            if (widget.showCancel) cancelButton
          ],
        ),
      ),
    );
  }
}

class MusicSearchBarSuffixIcon extends StatefulWidget {
  final TextEditingController controller;
  final MusicSearchBarVoid? onClear;

  const MusicSearchBarSuffixIcon(
      {Key? key, required this.controller, this.onClear})
      : super(key: key);

  @override
  _MusicSearchBarSuffixIconState createState() =>
      _MusicSearchBarSuffixIconState();
}

class _MusicSearchBarSuffixIconState extends State<MusicSearchBarSuffixIcon> {
  late ValueNotifier<bool> _notifier;

  @override
  void initState() {
    _notifier = ValueNotifier(widget.controller.text.isEmpty);
    widget.controller.addListener(() {
      if (mounted) _notifier.value = widget.controller.text.isEmpty;
    });
    super.initState();
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _notifier,
      builder: (context, bool value, child) {
        return Offstage(
          offstage: value,
          child: child,
        );
      },
      child: InkWell(
          highlightColor: Colors.transparent,
          radius: 0,
          onTap: () {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              widget.controller.text = '';
              widget.onClear?.call();
            });
          },
          child:
              Icon(Icons.clear, size: 20, color: Theme.of(context).hintColor)),
    );
  }
}
