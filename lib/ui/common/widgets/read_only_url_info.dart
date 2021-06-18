import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guardspot/util/extensions/scaffold_extensions.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class ReadOnlyUrlInfo extends StatelessWidget {
  final String? url;

  ReadOnlyUrlInfo(this.url);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: TextEditingController(text: url ?? ""),
            readOnly: true,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(10.0),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
          ),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          child: Text("copy").t(context),
          onPressed: () => url != null ? _copyToClipboard(url!, context) : null,
        ),
      ],
    );
  }

  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: url));
    context.showLocalizedSnackBar("copied_link_to_clipboard");
  }
}
