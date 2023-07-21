import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat/constants/constants.dart';

class UserProvider with ChangeNotifier {
  static Client client =
      Client().setEndpoint(constants.endPoint).setProject(constants.projectId);

  static Databases databases = Databases(client);

  String userId = '';
  String sessionId = '';

  String getSessionId() {
    return sessionId;
  }

  void setSessionId(String ssId) {
    sessionId = ssId;
  }

  String getUserId() {
    return userId;
  }

  void setUserId(String userId) {
    userId = userId;
  }

  List<Document> msgList = [];

  Future<void> updateList(String senderId, String recieverId) async {
    msgList = [];
    notifyListeners();

    msgList = await getMessages(senderId, recieverId);
    notifyListeners();
  }

  void sendMessage(
      String msg, String senderId, String recieverId
      ) async {
    try {
      final message = await databases.createDocument(
          databaseId: constants.dbId,
          collectionId: constants.collectionId,
          documentId: ID.unique(),
          data: {
            'message': msg,
            'senderId': senderId,
            'recieverId': recieverId
          });
      msgList.add(message);
      notifyListeners();
    } on AppwriteException catch (_) {
      rethrow;
    }
  }

  Future<void> delMessage(String docId) async{
    try{
      final result = await databases.deleteDocument(
          databaseId: constants.dbId,
          collectionId: constants.collectionId,
          documentId: docId);
      return result;
    } on AppwriteException catch(_){
      rethrow;
    }
  }

  Future<List<Document>> getMessages(String senderId, String recieverId) async {
    try {
      final msgs = await databases.listDocuments(
        databaseId: constants.dbId,
        collectionId: constants.collectionId,
      );
      List<Document> msgData = [];
      for (var doc in msgs.documents) {
        if (doc.data['senderId'] == senderId && doc.data['recieverId'] == recieverId) {
          msgData.add(doc);
        }
      }
      return msgData;
    } on AppwriteException catch (_) {
      rethrow;
    }
  }
}
