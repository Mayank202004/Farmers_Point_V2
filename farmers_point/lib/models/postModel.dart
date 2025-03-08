import 'package:cropunity/models/userModel.dart';

import 'likesModel.dart';

class PostModel {
  int? id;
  String? content;
  String? image;
  String? createdAt;
  int? likeCount;
  int? commentCount;
  String? userId;
  UserModel? user;
  List<LikesModel>? likes;

  PostModel(
      {this.id,
        this.content,
        this.image,
        this.createdAt,
        this.likeCount,
        this.commentCount,
        this.userId,
        this.user,
        this.likes
      });

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    image = json['image'];
    createdAt = json['created_at'];
    likeCount = json['like_count'];
    commentCount = json['comment_count'];
    userId = json['user_id'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    if(json["likes"] != null){
      likes = <LikesModel>[];
      json["likes"].forEach((v){
        likes!.add(LikesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['like_count'] = likeCount;
    data['comment_count'] = commentCount;
    data['user_id'] = userId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
