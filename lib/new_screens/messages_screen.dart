import 'package:dart_appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/constants/new_constants.dart';
import 'package:flutter_chat/model/connect_profile.dart';
import 'package:flutter_chat/model/connect_user.dart';
import 'package:flutter_chat/new_database/new_chat_db.dart';
import 'package:flutter_chat/new_provider/new_provider.dart';
import 'package:flutter_chat/provider/user_provider.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/appwrite.dart' as appWrite;
import 'dart:io' as io;
import 'package:appwrite/models.dart' as apm;
import 'package:flutter_chat/storage/appwrite_storage.dart';

import '../model/message_model.dart';

class MessageScreen extends StatefulWidget {
  final ConnectProfile connectProfile; final String collectionId;
  const MessageScreen({required this.connectProfile, required this.collectionId, super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  TextEditingController msgController = TextEditingController();
  var isLoading = false;

  void toggleLoading(){
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    Provider.of<ConnectDb>(context, listen: false).getRealTimeMessages(widget.collectionId);
    Provider.of<ConnectDb>(context, listen: false).getOldMsgs(widget.collectionId);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectDb>(
      builder: (buildContext, connectDb, child) => Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Row(
            children: [
              SizedBox(
                width: 50,
                child: FutureBuilder(
                    future: dpStorage.getImage(widget.connectProfile.userId),
                    builder: (BuildContext context,
                        AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        final apm.File image = snapshot.data;
                        return CircleAvatar(
                          child: Image.file(
                            io.File(image.name),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Icon(Icons.error_outline);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
              const SizedBox(width: 10,),
              Text(widget.connectProfile.userName),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
                children: [
                  Expanded(
                    child: connectDb.msgs.isEmpty ? Center(
                        child: ListView(
                          children: [
                            Image.asset('assets/images/empty.png'),
                            const Align(
                                alignment: Alignment.center,
                                child: Text('Start Texting!', style: TextStyle(fontSize: 20),))
                          ],
                        )
                    )
                    : ListView.separated(
                      shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      return ChatBubble(
                        clipper: connectDb.msgs[index].userId == ConnectUserProvider.userId ? ChatBubbleClipper1(type: BubbleType.sendBubble) : ChatBubbleClipper1(type: BubbleType.receiverBubble),
                        backGroundColor: connectDb.msgs[index].userId == ConnectUserProvider.userId ? Colors.grey : Colors.deepPurple,
                        alignment: connectDb.msgs[index].userId == ConnectUserProvider.userId ? Alignment.topRight : Alignment.topLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                connectDb.msgs[index].message,
                                style: const TextStyle(
                                    color: Colors.white,
                                  fontSize: 18
                                ),
                              ),
                              Text(
                                connectDb.msgs[index].time,
                                style: const TextStyle(
                                    color: Colors.white,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic
                                ),)
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (ctx, index) => const SizedBox(height: 10,),
                    itemCount: connectDb.msgs.length
          ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            maxLines: null,
                            autocorrect: true,
                            enableSuggestions: true,
                            controller: msgController,
                            decoration: const InputDecoration(
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () async{
                              toggleLoading();
                              if(msgController.text.isNotEmpty){
                                await connectDb.sendMessage(
                                    Message(
                                      message: msgController.text,
                                      userId: ConnectUserProvider.userId,
                                      receiverId: widget.connectProfile.userId,
                                      time: DateFormat('HH:mm').format(DateTime.now()),
                                      id: appWrite.ID.unique(),
                                    ),
                                    widget.collectionId
                                ).then((value){
                                  toggleLoading();
                                  if(value.$id.isNotEmpty){
                                    msgController.clear();
                                  }
                                  else{
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occurred')));
                                  }
                                });
                              }
                            },
                            icon: isLoading ? const CircularProgressIndicator() : const Icon(Icons.send)
                        )
                      ],
                    ),
                  ),
                ],
              )
        ),
      ),
    );
  }
}





