import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/comment.dart';
import 'package:guardspot/models/model.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/ui/project/view/common/comment/comment_item.dart';
import 'package:guardspot/ui/project/view/common/comment/comment_section_view_model.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/common/user/user_avatar.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class CommentSection extends StatefulWidget {
  final Model parent;

  CommentSection(this.parent);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  late CommentSectionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.setParent(widget.parent);
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypedStreamBuilder(
      stream: _viewModel.comments,
      builder: (List<Comment>? comments) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "comments",
            style: Theme.of(context).textTheme.headline6,
          ).t(context, arguments: {"count": comments!.length}),
          SizedBox(height: 30),
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            itemCount: comments.length,
            itemBuilder: (context, index) => CommentItem(comments[index]),
            separatorBuilder: (context, index) => SizedBox(height: 15),
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(
                User(id: 1, name: "Jonas Beyer"),
                style: UserAvatarStyle.small(),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      onChanged: _viewModel.setContent,
                      maxLines: 5,
                      maxLength: 5000,
                      decoration: InputDecoration(
                        hintText: context.getString("comment_placeholder"),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _viewModel.addOrUpdateComment,
                      child: Text(
                        context.getString("submit_comment").toUpperCase(),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
