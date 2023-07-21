import 'package:dart_appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/constants/new_constants.dart';
import 'package:flutter_chat/model/connect_profile.dart';
import 'package:flutter_chat/model/connect_user.dart';
import 'package:flutter_chat/new_database/new_chat_db.dart';
import 'package:flutter_chat/new_provider/new_provider.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/appwrite.dart' as appWrite;

class MessageScreen extends StatefulWidget {
  final ConnectProfile connectProfile; final String collectionId;
  const MessageScreen({required this.connectProfile, required this.collectionId, super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  TextEditingController msgController = TextEditingController();

  @override
  void initState() {
    Provider.of<ConnectDb>(context, listen: false).getRealTimeMessages(widget.collectionId);
    Provider.of<ConnectDb>(context, listen: false).getOldMsgs(widget.collectionId);
    super.initState();
    // TODO: implement initState
    // Provider.of<ConnectDb>(context, listen: false).chats.clear();
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
          title: Text(widget.connectProfile.userName),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: connectDb.chats.isEmpty ? Expanded(child: Center(
            child: ListView(
              children: [
                Image.asset('assets/images/empty.png'),
                const Align(
                  alignment: Alignment.center,
                    child: Text('Start Texting!', style: TextStyle(fontSize: 20),))
              ],
            )
          ))
              : ListView.separated(
              itemBuilder: (ctx, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  alignment: connectDb.chats[index].payload['userId'] == ConnectUserProvider.userId? Alignment.topRight : Alignment.topLeft,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: connectDb.chats[index].payload['userId'] == ConnectUserProvider.userId? Colors.black12 : Colors.deepPurple
                  ),
                  child: Text(
                    connectDb.chats[index].payload['message'],
                    style: TextStyle(
                        color: connectDb.chats[index].payload['userId'] == ConnectUserProvider.userId? Colors.black : Colors.white
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) => const SizedBox(height: 10,),
              itemCount: connectDb.chats.length
          )
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
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
                    if(msgController.text.isNotEmpty){
                      await connectDb.sendMessage(
                          msgController.text,
                          ConnectUserProvider.userId,
                          widget.connectProfile.userId,
                          widget.collectionId
                      ).then((value){
                        if(value.$id.isNotEmpty){
                          msgController.clear();
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occurred')));
                        }
                      });
                    }
                  },
                  icon: const Icon(Icons.send)
              )
            ],
          ),
        ),
      ),
    );
  }
}



