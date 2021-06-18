import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/model.dart';
import 'package:guardspot/ui/common/widgets/read_only_url_info.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/project/view/common/share/share_model_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class ShareModelDialog extends StatefulWidget {
  final Model model;

  ShareModelDialog(this.model);

  @override
  _ShareModelDialogState createState() => _ShareModelDialogState();
}

class _ShareModelDialogState extends State<ShareModelDialog> {
  late ShareModelViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.fetchUrl(widget.model);
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypedStreamBuilder(
      initialWidget: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [CircularProgressIndicator()],
        ),
      ),
      stream: _viewModel.data,
      builder: (String url) => AlertDialog(
        title: Text("get_a_public_link").t(context),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReadOnlyUrlInfo(url),
              SizedBox(height: 10),
              Text("get_a_public_link_hint").t(context),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(context.getString("close").toUpperCase()),
            onPressed: () => Navigator.of(context).pop(),
          ),
          OutlinedButton(
            child: Text(context.getString("disable").toUpperCase()),
            onPressed: () => _viewModel.unpublish(widget.model),
            style: OutlinedButton.styleFrom(
              primary: Colors.redAccent,
              side: BorderSide(color: Colors.redAccent, width: 1),
            ),
          ),
        ],
      ),
    );
  }
}
