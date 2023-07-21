import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_chat/constants/constants.dart';

class MessageDb{
  static Client client = Client()
      .setEndpoint(constants.endPoint)
      .setProject(constants.projectId);

  static Databases databases = Databases(client);

  static Future<Document> sendMessage(String msg, String senderId, String recieverId) async{
    try{
      final message = databases.createDocument(
          databaseId: constants.dbId,
          collectionId: constants.collectionId,
          documentId: ID.unique(),
          data: {
            'message': msg,
            'senderId': senderId,
            'recieverId': recieverId
          }
      );
      return message;
    }on AppwriteException catch(_){
      rethrow;
    }
  }


  static Future<DocumentList> getMessages(String senderId, String recieverID) async{
    try{
      final messages = databases.listDocuments(
          databaseId: constants.dbId,
          collectionId: constants.collectionId,
        queries: [
          Query.equal('senderId', senderId),
          Query.equal('recieverId', recieverID)
        ]
      );
      return messages;
    }on AppwriteException catch(_){
      rethrow;
    }
  }
}