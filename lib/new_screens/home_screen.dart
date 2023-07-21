import 'package:dart_appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/model/connect_profile.dart';
import 'package:flutter_chat/new_database/new_chat_db.dart';
import 'package:flutter_chat/new_database/new_db.dart';
import 'package:flutter_chat/new_provider/new_provider.dart';
import 'package:flutter_chat/new_screens/auth_screen.dart';
import 'package:flutter_chat/new_screens/messages_screen.dart';
import 'package:flutter_chat/screens/auth_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats', style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
              onPressed: (){
                showDialog(
                  barrierDismissible: false,
                    context: context,
                    builder: (buildContext) => AlertDialog(
                      title: const Text('Want to logout?'),
                      backgroundColor: Colors.white,
                      actions: [
                        TextButton(
                            onPressed: () {
                              profileDb.signout(ConnectUserProvider.sessionId).then((value){
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => const AuthroizationScreen()), (route) => false);
                              });
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
                    )
                );
              },
              icon: const Icon(Icons.exit_to_app)
          )
        ],
      ),
      body: FutureBuilder(
          future: profileDb.getProfileList(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final List<Document> profiles = snapshot.data.documents;
              if(profiles.isEmpty){
                return Center(child: Image.asset('assets/images/empty.png'),);
              }
              else{
                return ListView.separated(
                    itemBuilder: (ctx, index){
                      ConnectProfile connectProfile = ConnectProfile.fromMap(profiles[index].data);
                      return ListTile(
                        onTap: () async {
                          await Provider.of<ConnectDb>(context, listen: false).getCollection(ConnectUserProvider.userId, connectProfile.userId).then(
                                  (value){
                                    if(value.isNotEmpty){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => MessageScreen(connectProfile: connectProfile, collectionId: value,)));
                                    }
                                  },
                          );
                        },
                        title: Row(
                          children: [
                            Text(connectProfile.userName),
                            ConnectUserProvider.userId == connectProfile.userId ? const Text(' (Message yourself)', style: TextStyle(fontStyle: FontStyle.italic),) : Container()
                          ],
                        ),
                        subtitle: Text(
                            connectProfile.bio,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      );
                    },
                    separatorBuilder: (ctx, index){
                      return const Divider();
                    },
                    itemCount: profiles.length
                );
              }
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
