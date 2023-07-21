import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/database/feed_db.dart';

class PostScreen extends StatelessWidget {
  static const routeName = '/post-screen';
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweets'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: RefreshIndicator(
          onRefresh: () async{
            await PostDb.getTweets();
            return;
          },
          child: FutureBuilder(
              future: PostDb.getTweets(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<Document> tweets = snapshot.data['documents'];
                  return ListView.builder(
                      itemBuilder: (ctx, index){
                        return Card(
                          child: ListTile(
                            title: Text(tweets[index].data['post']),
                          ),
                        );
                      },
                    itemCount: tweets.length,
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){

          },
        child: const Icon(Icons.add),
      ),
    );
  }
}
