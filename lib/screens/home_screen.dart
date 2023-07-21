import 'dart:io' as io;

import 'package:dart_appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/database/db.dart';
import 'package:flutter_chat/provider/user_provider.dart';
import 'package:flutter_chat/screens/auth_screen.dart';
import 'package:flutter_chat/screens/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  String userID;
  static const routeName = '/home-screen';
  HomeScreen({required this.userID, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String img = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                //Navigator.of(context).pushNamedAndRemoveUntil(newRouteName, (route) => false)
              },
              icon: const Icon(Icons.add)
          ),
          IconButton(
              onPressed: (){
                showDialog(context: context, builder: (buildContext){
                  return AlertDialog(
                    title: const Text('Want to logout?'),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            await Db.logout(Provider.of<UserProvider>(context, listen: false).sessionId).then((value) => Navigator.of(context).pushNamedAndRemoveUntil(AuthScreen.routeName, (route) => false));
                          },
                          child: const Text('Yes')
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No')
                      ),
                    ],
                  );
                });
              },
              icon: const Icon(Icons.logout)
          )
        ],
      ),
        body: FutureBuilder(
            future: Db.getUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final List<User> users = snapshot.data.users;
                if(users.isEmpty){
                  return const Center(child: Text('No users added yet!'),);
                }
                return ListView.separated(
                    itemBuilder: (ctx, index) {
                      Db.getImage(users[index].$id).then((value){
                        setState(() {
                          img = value.data['img'];
                        });
                      });
                      return ListTile(
                        leading: img.isEmpty ? const Icon(Icons.people) : Image.file(
                          io.File(img),
                          fit: BoxFit.fitWidth,
                        ),
                        title: Text(users[index].name),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => UserData(senderId: widget.userID, user: users[index])));
                        },
                      );
                    },
                    separatorBuilder: (ctx, index){
                      return const Divider();
                    },
                    itemCount: users.length);
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })
    );
  }
}
