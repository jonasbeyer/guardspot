import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:guardspot/models/comment.dart';

@lazySingleton
class CommentService {
  final Dio dio;

  CommentService(this.dio);

  Future<Comment> addComment({
    required Comment comment,
    int? uploadId,
    int? reportId,
  }) async {
    Map<String, dynamic> params = {
      "upload_id": uploadId,
      "report_id": reportId,
    }..removeWhere((k, v) => v == null);

    Response response = await dio.post(
      "comments",
      queryParameters: params,
      data: comment.toJson(),
    );
    return Comment.fromJson(response.data);
  }

  Future<Comment> updateComment(Comment comment) async {
    Response response =
        await dio.put("comments/${comment.id}", data: comment.toJson());
    return Comment.fromJson(response.data);
  }

  Future<List<Comment>> getComments({
    int? uploadId,
    int? reportId,
  }) async {
    Map<String, dynamic> params = {
      "upload_id": uploadId,
      "report_id": reportId,
    }..removeWhere((k, v) => v == null);

    final response = await dio.get("comments", queryParameters: params);
    return (response.data as List<dynamic>)
        .map((data) => Comment.fromJson(data))
        .toList();
  }

  Future<void> deleteComment(int commentId) =>
      dio.delete("comments/$commentId");
}
