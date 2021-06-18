import 'package:injectable/injectable.dart';
import 'package:guardspot/data/comment/comment_service.dart';
import 'package:guardspot/models/comment.dart';
import 'package:guardspot/models/model.dart';
import 'package:guardspot/models/report.dart';
import 'package:guardspot/models/upload.dart';
import 'package:guardspot/ui/common/view_models/base_view_model.dart';
import 'package:guardspot/util/extensions/language_extensions.dart';

@injectable
class CommentSectionViewModel extends BaseViewModel<CommentSectionState> {
  final CommentService _commentService;

  CommentSectionViewModel(this._commentService);

  void setParent(Model parent) {
    if (parent is Upload) {
      final state = CommentSectionState(parent, comments: parent.comments);
      emit(state);
    } else if (parent is Report) {
      final state = CommentSectionState(parent, comments: parent.comments);
      emit(state);
    }
  }

  void setContent(String content) => emit(state!.copyWith(text: content));

  void addOrUpdateComment() async {
    Comment comment = Comment(content: state!.text!);
    Model parent = state!.parent;
   
    Future<Comment> result;
    if (comment.id == null) {
      result = _commentService.addComment(
        comment: comment,
        uploadId: parent is Upload ? parent.id : null,
        reportId: parent is Report ? parent.id : null,
      );
    } else {
      result = _commentService.updateComment(comment);
    }

    comment = await result;
    emit(state!.copyWith(comments: state!.comments!.plus(comment)));
  }

  Stream<List<Comment>?> get comments => data.map((state) => state.comments);
}

class CommentSectionState {
  final Model parent;
  final String? text;
  final List<Comment>? comments;

  CommentSectionState(this.parent, {this.text, this.comments});

  CommentSectionState copyWith({String? text, List<Comment>? comments}) {
    return CommentSectionState(
      parent,
      text: text ?? this.text,
      comments: comments ?? this.comments,
    );
  }
}
