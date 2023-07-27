import 'package:appwrite/appwrite.dart' as appWrite;
import 'package:appwrite/realtime_io.dart';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/constants/new_constants.dart';
import 'package:flutter_chat/model/message_model.dart';

class ConnectDb with ChangeNotifier{
  static Client client = Client().setProject(NewConstants.projectId).setEndpoint(NewConstants.endPoint).setKey(NewConstants.serversideApiKey).setSelfSigned(status: false);

  static Databases databases = Databases(client);

  List<appWrite.RealtimeMessage> chats = [];
  List<Message> msgs = [];

  void closeSubscription(String collectionId){
    const DbId = NewConstants.usersDbId;
    final appWrite.Client client = appWrite.Client().setEndpoint(NewConstants.realtimeEndpoint).setProject(NewConstants.projectId);
    final appWrite.Realtime realtime = appWrite.Realtime(client);
    realtime.subscribe(["databases.$DbId.collections.$collectionId.documents"]).close();
  }

  void getRealTimeMessages(String collectionId) {
    const DbId = NewConstants.usersDbId;
    final appWrite.Client client = appWrite.Client().setEndpoint(NewConstants.realtimeEndpoint).setProject(NewConstants.projectId);
    final appWrite.Realtime realtime = appWrite.Realtime(client);
    realtime.subscribe(["databases.$DbId.collections.$collectionId.documents"]).stream.listen((event) {

      if(event.events.contains("databases.$DbId.collections.$collectionId.documents.*.create")){

        if(!msgs.contains(Message.fromMap(event.payload))){
          getOldMsgs(collectionId);
        }
        notifyListeners();
      }
      if(event.events.contains("databases.$DbId.collections.$collectionId.documents.*.delete")){

        if(msgs.contains(Message.fromMap(event.payload))){
          getOldMsgs(collectionId);
        }
        notifyListeners();
      }
      else{
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
              permissions: [
                Permission.read(Role.any()),
                Permission.write(Role.any()),
                Permission.update(Role.any()),
                Permission.delete(Role.any()),
              ]
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
      await databases.createStringAttribute(
          collectionId: collection.$id,
          key: "time",
          size: 255,
          xrequired: true, databaseId: NewConstants.usersDbId);
      await databases.createStringAttribute(
          collectionId: collection.$id,
          key: "id",
          size: 255,
          xrequired: true, databaseId: NewConstants.usersDbId);
      }
    return collection.$id;
  }

  Future<Document> sendMessage(Message msg, String collectionId) async{
    const DbId = NewConstants.usersDbId;
    print('sending message');
    try{
      final response = await databases.createDocument(
          databaseId: NewConstants.usersDbId,
          collectionId: collectionId,
          documentId: DateTime.now().millisecond.toString(),
          data: msg.toMap()
      );
      msgs.add(msg);
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
      msgs = List.generate(
          response.documents.length,
              (index) => Message.fromMap(response.documents[index].data)
      );
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
      msgs.remove(response);
      notifyListeners();
      return response;
    } on AppwriteException catch(_){
      rethrow;
    }
  }
}