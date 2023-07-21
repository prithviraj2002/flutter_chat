import 'package:appwrite/appwrite.dart' as appWrite;
import 'package:appwrite/realtime_io.dart';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/constants/new_constants.dart';

class ConnectDb with ChangeNotifier{
  static Client client = Client().setProject(NewConstants.projectId).setEndpoint(NewConstants.endPoint).setKey(NewConstants.serversideApiKey).setSelfSigned(status: false);

  static Databases databases = Databases(client);

  List<appWrite.RealtimeMessage> chats = [];

  void getRealTimeMessages(String collectionId) {
    const DbId = NewConstants.usersDbId;
    final appWrite.Client client = appWrite.Client().setEndpoint(NewConstants.realtimeEndpoint).setProject(NewConstants.projectId);
    final appWrite.Realtime realtime = appWrite.Realtime(client);
    realtime.subscribe(["databases.$DbId.collections.$collectionId.documents"]).stream.listen((event) {
      print('listening');
      if(event.events.contains("databases.$DbId.collections.$collectionId.documents.*.create")){
        print('doc created!');
        if(chats.contains(event) == false){
          getOldMsgs(collectionId);
        }
        // if(!chats.contains(event)){
        //   chats.add(event);
        // }
        notifyListeners();
      }
      if(event.events.contains("databases.$DbId.collections.$collectionId.documents.*.delete")){
        print('doc deleted!');
        // if(chats.contains(event)){
        //   chats.remove(event);
        // }
        if(chats.contains(event)){
          getOldMsgs(collectionId);
        }
        notifyListeners();
      }
      else{
        print('Print Nothing');
      }
    });
  }

  Future<String> getCollection(String currentUserId, String otherUserId) async{
    Collection? collection;
    try{
      collection = await databases.getCollection(
          databaseId: NewConstants.usersDbId,
          collectionId: currentUserId+otherUserId
      );
    } on AppwriteException catch(e){
      if(e.code == 404){
        try{
          collection = await databases.getCollection(
              databaseId: NewConstants.usersDbId,
              collectionId: otherUserId+currentUserId
          );
        } on AppwriteException catch(e){
          if(e.code == 404){
            collection = await databases.createCollection(
                databaseId: NewConstants.usersDbId,
                collectionId: currentUserId+otherUserId,
                name: currentUserId + otherUserId,
            );
          }
          else{
            rethrow;
          }
        }
      } else{
        rethrow;
      }
    }
    if(collection.attributes.isEmpty){
      await databases.createStringAttribute(
          collectionId: collection.$id,
          key: "userId",
          size: 255,
          xrequired: true, databaseId: NewConstants.usersDbId);
      await databases.createStringAttribute(
          collectionId: collection.$id,
          key: "receiverId",
          size: 255,
          xrequired: true, databaseId: NewConstants.usersDbId);
      await databases.createStringAttribute(
          collectionId: collection.$id,
          key: "message",
          size: 255,
          xrequired: true, databaseId: NewConstants.usersDbId);
      }
    return collection.$id;
  }

  Future<Document> sendMessage(String msg, String userId, String receiverId, String collectionId) async{
    const DbId = NewConstants.usersDbId;
    print('sending message');
    try{
      final response = await databases.createDocument(
          databaseId: NewConstants.usersDbId,
          collectionId: collectionId,
          documentId: DateTime.now().millisecond.toString(),
          data: {
            'message': msg,
            'userId': userId,
            'receiverId' : receiverId,
          }
      );
      chats.add(appWrite.RealtimeMessage(
          events: [],
          payload: {
            'message': msg,
            'userId': userId,
            'receiverId' : receiverId,
          },
          channels: ['databases.$DbId.collections.$collectionId.documents'],
          timestamp: DateTime.now().toIso8601String()
      ));
      notifyListeners();
      return response;
    } on AppwriteException catch(_){
      rethrow;
    }
  }

  Future<DocumentList> getOldMsgs(String collectionId) async{
    const DbId = NewConstants.usersDbId;
    print('getting old msgs!');
    try{
      final response = await databases.listDocuments(
          databaseId: NewConstants.usersDbId,
          collectionId: collectionId
      );
      chats = List.generate(response.documents.length, (index) => appWrite.RealtimeMessage(
          events: [],
          payload: {
            'message': response.documents[index].data['message'],
            'userId': response.documents[index].data['userId'],
            'receiverId' : response.documents[index].data['receiverId'],
          },
          channels: ['databases.$DbId.collections.$collectionId.documents'],
          timestamp: DateTime.now().toIso8601String()
      ));
      notifyListeners();
      return response;
    } on AppwriteException catch(_){
      rethrow;
    }
  }

  Future<dynamic> delMsg(String collectionId, String msgId) async{
    try{
      final response = await databases.deleteDocument(
          databaseId: NewConstants.usersDbId,
          collectionId: collectionId,
          documentId: msgId
      );
      chats.remove(response);
      notifyListeners();
      return response;
    } on AppwriteException catch(_){
      rethrow;
    }
  }
}