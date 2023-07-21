import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart';
import 'package:flutter_chat/constants/constants.dart';

class TestDb{
  static Client client = Client().setProject(constants.projectId).setEndpoint(constants.endPoint);

  static Databases databases = Databases(client);

  Future<Collection> createCollection(String collectionName) {
    try{
      final response = databases.createCollection(
          databaseId: constants.dbId,
          collectionId: ID.unique(),
          name: collectionName
      );
      return response;
    } on AppwriteException catch(_){
      rethrow;
    }
  }

  Future<AttributeString> createAttributes(String atrName){
    try{
       final response = databases.createStringAttribute(
           databaseId: constants.dbId,
           collectionId: constants.collectionId,
           key: atrName,
           size: 1000,
           xrequired: true
       );
       return response;
    }on AppwriteException catch(_){
      rethrow;
    }
  }
}