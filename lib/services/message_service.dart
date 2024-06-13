import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shamo_app/models/message_model.dart';
import 'package:shamo_app/models/product_model.dart';
import 'package:shamo_app/models/user_model.dart';

class MessageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getMessagesByUserId({required int userId}) {
    try {
      return firestore
          .collection('messages')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot list) {
        var result = list.docs.map<MessageModel>((DocumentSnapshot message) {
          return MessageModel.fromJson(message.data() as Map<String, dynamic>);
        }).toList();

        result.sort(
          (MessageModel a, MessageModel b) =>
              a.createdAt.compareTo(b.createdAt),
        );
        return result;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addMessage(
    UserModel user,
    bool isFromUser,
    String message,
    ProductModel product,
  ) async {
    try {
      firestore.collection('messages').add({
        'userId': user.id,
        'username': user.name,
        'userImage': user.profilePhotoUrl,
        'isFromUser': isFromUser,
        'message': message,
        'product': product is UnintializedProductModel ? {} : product.toJson(),
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
      }).then(
        (value) => print('Pesan Berhasil Terkirim'),
      );
    } catch (e) {
      throw Exception('Pesan Gagal Terikirm');
    }
  }
}
