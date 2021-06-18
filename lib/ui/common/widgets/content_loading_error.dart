import 'package:flutter/material.dart';
import 'package:guardspot/app/theme/colors.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class ContentLoadingError extends StatelessWidget {
  final Icon? icon;
  final Text? title;
  final Text message;
  final ButtonStyleButton? button;
  final VoidCallback? onRetry;

  ContentLoadingError({
    required this.message,
    this.title,
    this.icon,
    this.button,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return OrientationBuilder(
      builder: (BuildContext content, Orientation orientation) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: orientation == Orientation.portrait
              ? _buildVerticalLayout(context, themeData)
              : _buildHorizontalLayout(context, themeData),
        );
      },
    );
  }

  Widget _buildVerticalLayout(BuildContext context, ThemeData themeData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) _buildErrorIcon(icon!, themeData),
        SizedBox(height: 16),
        _buildErrorColumn(context, themeData),
      ],
    );
  }

  Widget _buildHorizontalLayout(BuildContext context, ThemeData themeData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) _buildErrorIcon(icon!, themeData),
        SizedBox(width: 16),
        Expanded(child: _buildErrorColumn(context, themeData)),
      ],
    );
  }

  Widget _buildErrorColumn(BuildContext context, ThemeData themeData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (title != null)
          DefaultTextStyle(
            child: title!,
            textAlign: TextAlign.center,
            style: TextStyles.contentLoadingErrorTitle(themeData),
          ),
        if (title != null) SizedBox(height: 10),
        DefaultTextStyle(
          child: message,
          textAlign: TextAlign.center,
          style: TextStyles.contentLoadingErrorDescription(themeData),
        ),
        if (onRetry != null || button != null)
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: button != null
                ? button
                : ElevatedButton.icon(
                    icon: Icon(Icons.repeat),
                    label: Text("retry").t(context),
                    onPressed: onRetry,
                  ),
          )
      ],
    );
  }

  Widget _buildErrorIcon(Icon icon, ThemeData themeData) {
    return IconTheme.merge(
      child: icon,
      data: IconThemeData(
        size: 100,
        color: AppColors.textColorSecondary(themeData),
      ),
    );
  }
}

class ContentLoadingNetworkError extends StatelessWidget {
  final VoidCallback? onRetry;

  ContentLoadingNetworkError({this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ContentLoadingError(
      title: Text("something_went_wrong").t(context),
      message: Text("network_error").t(context),
      onRetry: onRetry,
    );
  }
}
