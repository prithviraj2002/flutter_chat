import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_chat/constants/constants.dart';

class PostDb{
  static Client client = Client().setEndpoint(constants.endPoint).setProject(constants.projectId);

  static Databases databases = Databases(client);

  static Future<Document> postTweet(String tweet, String userId) async{
    try{
      final response = await databases.createDocument(
          databaseId: constants.postsDbId,
          collectionId: constants.feedCollectionId,
          documentId: userId,
          data: {
            'post' : tweet
          });
      return response;
    } on AppwriteException catch(_){
      rethrow;
    }
  }

  static Future<DocumentList> getTweets() async{
    try{
      final response = await databases.listDocuments(
          databaseId: constants.postsDbId,
          collectionId: constants.feedCollectionId,
      );
      return response;
    } on AppwriteException catch(_){
      rethrow;
    }
  }
}