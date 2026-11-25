import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../auth/methods/user_storage.dart';
import '../../../models/posts.dart';

class PostStorage {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<String> uploadPost(
    String caption,
    String uid,
    String username,
    String profImage,
    Uint8List image,
  ) async {
    String res = "error";

    try {
      String photoUrl =
          await StorageMethods()
              .uploadImageToStorage(
        true,
        'posts',
        image,
      );

      String postId =
          const Uuid().v1();

      Post post = Post(
        caption: caption,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished:
            DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );

      await _firestore
          .collection('posts')
          .doc(postId)
          .set(post.toJson());

      res = "Ok";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> deletePost(
    String postId,
    String publicId,
  ) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }
}