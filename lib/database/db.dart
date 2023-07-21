import 'dart:typed_data';

import 'package:appwrite/appwrite.dart' as ap;
import 'package:appwrite/models.dart' as apm;
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart';
import 'package:flutter_chat/constants/constants.dart';
import 'package:image_picker/image_picker.dart';

class Db{
  static ap.Client client = ap.Client().setProject(constants.projectId).setEndpoint(constants.endPoint);

  static ap.Account account = ap.Account(client);

  static ap.Databases databases = ap.Databases(client);

  static Client dclient = Client().setEndpoint(constants.endPoint).setProject(constants.projectId).setKey(constants.apiKey);

  static Users users = Users(dclient);

  static ap.Storage storage = ap.Storage(client);

  static Future<String> setImage() async{
    final ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if(file != null){
      return file.path;
    }
    else{
      return '';
    }
  }

  static Future<apm.Document> uploadImage(String imagePath, String userId) async{
    try{
      final doc = await databases.createDocument(
          databaseId: constants.userDpDbId,
          collectionId: constants.dpCollectionId,
          documentId: userId,
          data: {
            'img' : imagePath,
            'userId': userId
          }
      );
      return doc;
    } on AppwriteException catch(_){
      rethrow;
    }
  }

  static Future<apm.Document> getImage(String userId) async{
    try{
      final doc = await databases.getDocument(
          databaseId: constants.userDpDbId,
          collectionId: constants.dpCollectionId,
          documentId: userId
      );
      return doc;
    } on AppwriteException catch(_){
      rethrow;
    }
  }

  static Future<UserList> getUsers() async{
    try{
      final list = await users.list();
      return list;
    }on AppwriteException catch(_){
      rethrow;
    }
  }

  static Future<dynamic> logout(String sessionId) async{
    try{
      final user = await account.deleteSession(sessionId: sessionId);
      return user;
    }on AppwriteException catch(_){
      rethrow;
    }
  }

  static Future<apm.User> signUp(String email, String password, String name) async{
    try{
      final user = await account.create(
          userId: ID.unique(), email: email, password: password, name: name);
      return user;
    } on AppwriteException catch(_){
      rethrow;
    }
  }

  static Future<apm.Session> login(String email, String password) async{
    try{
      final user = await account.createEmailSession(email: email, password: password);
      return user;
    }on AppwriteException catch(_){
      rethrow;
    }
  }
}