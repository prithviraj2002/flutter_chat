import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart';

import 'package:appwrite/appwrite.dart' as ap;
import 'package:appwrite/models.dart' as apm;
import 'package:flutter_chat/constants/new_constants.dart';
import 'package:flutter_chat/model/connect_profile.dart';
import 'package:flutter_chat/model/connect_user.dart';

class profileDb{
  static Client client = Client().setEndpoint(NewConstants.endPoint).setProject(NewConstants.projectId);

  static Account account = Account(client);

  static Databases databases = Databases(client);

  static Future<dynamic> signout(String sessionId){
    try{
      final response = ap.Account(ap.Client().setEndpoint(NewConstants.endPoint).setProject(NewConstants.projectId)).deleteSession(sessionId: sessionId);
      return response;
    } on AppwriteException catch(_){
      rethrow;
    }
  }

  static Future<apm.User> signUp(ConnectUser connectUser){
    try{
      final response = ap.Account(ap.Client().setEndpoint(NewConstants.endPoint).setProject(NewConstants.projectId))
          .create(userId: connectUser.userId, email: connectUser.email, password: connectUser.password, name: connectUser.email);
      return response;
    } on AppwriteException catch(_){
      rethrow;
    }
  }

  static Future<apm.Session> signIn(String email, String password){
    try{
      final response = ap.Account(ap.Client().setEndpoint(NewConstants.endPoint).setProject(NewConstants.projectId)).createEmailSession(
          email: email, password: password);
      return response;
    } on AppwriteException catch(_){
      rethrow;
    }
  }

  static Future<Document> createProfile(ConnectProfile connectProfile){
    try{
      final response = databases.createDocument(
          databaseId: NewConstants.usersDbId,
          collectionId: NewConstants.profileCollectionID,
          documentId: connectProfile.userId,
          data: connectProfile.toMap()
      );
      return response;
    } on AppwriteException catch(_){
      rethrow;
    }
  }

  static Future<Document> getProfile(String userId){
    try{
      final response = databases.getDocument(
          databaseId: NewConstants.usersDbId,
          collectionId: NewConstants.profileCollectionID,
          documentId: userId
      );
      return response;
    } on AppwriteException catch(_){
      rethrow;
    }
  }

  static Future<DocumentList> getProfileList(){
    try{
      final response = databases.listDocuments(
          databaseId: NewConstants.usersDbId,
          collectionId: NewConstants.profileCollectionID
      );
      return response;
    } on AppwriteException catch(_){
      rethrow;
    }
  }
}