import 'package:flutter/material.dart';
import 'package:guardspot/ui/common/widgets/content_loading_error.dart';
import 'package:rxdart/rxdart.dart';

class TypedStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget? errorWidget;
  final T? initialData;
  final Widget? initialWidget;
  final Widget Function(T data) builder;

  TypedStreamBuilder({
    required this.stream,
    required this.builder,
    this.errorWidget,
    this.initialData,
    this.initialWidget,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: initialData,
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          return errorWidget ?? _buildErrorWidget(context);
        } else if (!snapshot.hasData) {
          return initialWidget ?? _buildLoadingWidget(context);
        }

        return builder(snapshot.data!);
      },
    );
  }

  Widget _buildErrorWidget(context) => ContentLoadingNetworkError();

  Widget _buildLoadingWidget(context) =>
      Center(child: CircularProgressIndicator());
}

class TypedValueStreamBuilder<T> extends StatelessWidget {
  final ValueStream<T> stream;
  final Widget? initialWidget;
  final Widget? errorWidget;
  final Widget Function(T data) builder;

  TypedValueStreamBuilder({
    required this.stream,
    required this.builder,
    this.initialWidget,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return TypedStreamBuilder(
      stream: stream,
      builder: builder,
      initialData: stream.value,
      initialWidget: initialWidget,
      errorWidget: errorWidget,
    );
  }
}
