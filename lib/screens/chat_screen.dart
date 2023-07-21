import 'package:appwrite/models.dart' as ap;
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/database/db.dart';
import 'package:flutter_chat/database/messages_db.dart';
import 'package:flutter_chat/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData extends StatefulWidget {
  final User user;
  String senderId;
  UserData({required this.user, required this.senderId, super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {

  TextEditingController msg = TextEditingController();
  bool sent = true;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).updateList(widget.senderId, widget.user.$id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    msg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (buildContext, userProvider, child) => Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Text(widget.user.name),
            ],
          ),
        ),
        body: userProvider.msgList.isEmpty ? const Center(child: Text('Start chatting!')) : ListView.builder(
          itemBuilder: (ctx, index){
            userProvider.msgList[index].data['senderId'] == widget.senderId ? sent = true : sent  = false;
            return ListTile(
              onLongPress: () async{
                //await MessageDb.delMessage(chats[index].$id);
              },
                title: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    color: sent ? Colors.green : Colors.blue,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all()
                  ),
                  child: Text(
                      userProvider.msgList[index].data['message'],
                    style: const TextStyle(color: Colors.white),
                  ),
                )
            );
          },
          itemCount: userProvider.msgList.length,
        ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: msg,
                    decoration: const InputDecoration(
                        hintText: 'Start Writing here...'
                    ),
                  ),
                ),
                IconButton(
                    onPressed: (){
                      if(msg.text.isNotEmpty){
                        Provider.of<UserProvider>(context, listen: false).sendMessage(msg.text, widget.senderId, widget.user.$id);
                        msg.clear();
                      }
                    },
                    icon: const Icon(Icons.send)
                )
              ],
            ),
          ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
