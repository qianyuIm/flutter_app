import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProviderWidget<T extends ChangeNotifier> extends StatefulWidget {
  final ValueWidgetBuilder<T> builder;
  final T viewModel;
  final Widget? child;
  final Function(T viewModel)? onModelReady;
  final bool autoDispose;

  ProviderWidget({
    Key? key,
    required this.builder,
    required this.viewModel,
    this.child,
    this.onModelReady,
    this.autoDispose: true,
  }) : super(key: key);

  _ProviderWidgetState<T> createState() => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends ChangeNotifier>
    extends State<ProviderWidget<T>> {
  late T viewModel;

  @override
  void initState() {
    viewModel = widget.viewModel;
    widget.onModelReady?.call(viewModel);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: viewModel,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}

class ProviderWidget2<A extends ChangeNotifier, B extends ChangeNotifier>
    extends StatefulWidget {
  final Widget Function(BuildContext context, A model1, B model2, Widget? child)
      builder;
  final A viewModel1;
  final B viewModel2;
  final Widget? child;
  final Function(A model1, B model2)? onModelReady;
  final bool autoDispose;

  ProviderWidget2({
    Key? key,
    required this.builder,
    required this.viewModel1,
    required this.viewModel2,
    this.child,
    this.onModelReady,
    this.autoDispose: true,
  }) : super(key: key);

  _ProviderWidgetState2<A, B> createState() => _ProviderWidgetState2<A, B>();
}

class _ProviderWidgetState2<A extends ChangeNotifier, B extends ChangeNotifier>
    extends State<ProviderWidget2<A, B>> {
  late A viewModel1;
  late B viewModel2;

  @override
  void initState() {
    viewModel1 = widget.viewModel1;
    viewModel2 = widget.viewModel2;
    widget.onModelReady?.call(viewModel1, viewModel2);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) {
      viewModel1.dispose();
      viewModel2.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<A>.value(value: viewModel1),
          ChangeNotifierProvider<B>.value(value: viewModel2),
        ],
        child: Consumer2<A, B>(
          builder: widget.builder,
          child: widget.child,
        ));
  }
}
