import 'package:injectable/injectable.dart';
import 'package:guardspot/data/comment/comment_service.dart';
import 'package:guardspot/models/comment.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';

@injectable
class DeleteCommentViewModel extends ViewStateViewModel {
  final CommentService _commentService;

  DeleteCommentViewModel(this._commentService);

  Future<void> delete(Comment comment) async {
    emitLoading();

    try {
      await _commentService.deleteComment(comment.id!);
      emitSuccess();
    } catch (e) {
      emitForUnhandledError(e);
    }
  }
}
