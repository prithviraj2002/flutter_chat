import 'package:flutter/material.dart';
import 'package:flutter_chat/model/connect_profile.dart';
import 'package:flutter_chat/new_database/new_db.dart';
import 'package:flutter_chat/new_provider/new_provider.dart';
import 'package:flutter_chat/new_screens/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _userNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: () {

                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/profilepic.png',
                        height: 200,
                        width: 200,
                      ),
                      const Positioned(
                        top: 145,
                          left: 145,
                          child: Icon(
                              Icons.camera_alt_outlined,
                            size: 25,
                          )
                      )
                    ]
                  ),
                ),
              ),
              const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
              const SizedBox(height: 20,),
              const Align( alignment: Alignment.centerLeft,
              child: Text('Add your user name',  style: TextStyle(fontSize: 20))),
              const SizedBox(height: 10,),
              TextField(
                enableSuggestions: true,
                autocorrect: true,
                controller: _userNameController,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 30,),
              const Align(alignment: Alignment.centerLeft,
              child: Text('Add something about yourself', style: TextStyle(fontSize: 20),)),
              const SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)
                ),
                height: 150,
                child: TextField(
                  maxLines: 10,
                  autocorrect: true,
                  enableSuggestions: true,
                  controller: _bioController,
                  decoration: const InputDecoration(
                    hintText: 'Bio',
                    border: InputBorder.none
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              TextButton(
                  onPressed: () {
                    if(_userNameController.text.isNotEmpty && _bioController.text.isNotEmpty){
                      ConnectProfile connectProfile = ConnectProfile(
                          userName: _userNameController.text,
                          bio: _bioController.text,
                          userId: ConnectUserProvider.userId
                      );
                    profileDb.createProfile(connectProfile).then(
                        (value){
                          if(value.$id.isNotEmpty){
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => const HomeScreen()), (route) => false);
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occurred!')));
                          }
                        }
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue', style: TextStyle(fontSize: 25),),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward)
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
