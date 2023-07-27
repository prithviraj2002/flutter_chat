import 'package:dart_appwrite/dart_appwrite.dart';

import 'package:appwrite/models.dart' as apm;
import 'package:flutter/material.dart';
import 'package:flutter_chat/database/db.dart';
import 'package:flutter_chat/model/connect_user.dart';
import 'package:flutter_chat/new_database/new_db.dart';
import 'package:flutter_chat/new_provider/new_provider.dart';
import 'package:flutter_chat/new_screens/home_screen.dart';
import 'package:flutter_chat/new_screens/profile_screen.dart';

class AuthroizationScreen extends StatefulWidget {
  static const routeName = '/auth-screen';
  const AuthroizationScreen({super.key});

  @override
  State<AuthroizationScreen> createState() => _AuthroizationScreenState();
}

class _AuthroizationScreenState extends State<AuthroizationScreen> {

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool isNewUser = true;
  String image = '';
  var isLoading = false;

  void toggleLoading(){
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30,),
              Center(
                child: Image.asset('assets/images/auth.png', height: 220),
              ),
              const SizedBox(height: 10,),
              isNewUser ? const Text('Sign Up', style: TextStyle(fontSize: 30),) : const Text('Login', style: TextStyle(fontSize: 30),),
              const SizedBox(height: 20,),
              const Align(alignment: Alignment.centerLeft,
                  child: Text('Add your Email', style: TextStyle(fontSize: 20),)),
              const SizedBox(height: 10,),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'Enter Email....',
                    labelText: 'Email',
                    border: OutlineInputBorder()
                ),
                validator: (value){
                  if(value == null){
                    return 'Cannot have an empty value!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              const Align(alignment: Alignment.centerLeft,
                  child: Text('Add your password', style: TextStyle(fontSize: 20),)),
              const SizedBox(height: 10,),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'Enter Password....',
                    labelText: 'Password',
                    border: OutlineInputBorder()
                ),
                validator: (value){
                  if(value == null){
                    return 'Cannot have an empty value!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              isNewUser?  const Align(alignment: Alignment.centerLeft,
                  child: Text('Confirm your Password', style: TextStyle(fontSize: 20),)) : Container(),
              isNewUser?
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'Confirm password',
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder()
                ),
                validator: (value){
                  if(value == null){
                    return 'Cannot have an empty value!';
                  }
                  return null;
                },
              )
                  : Container(),
              const SizedBox(height: 20,),
              TextButton(
                onPressed: () async{
                  toggleLoading();
                  final userId = DateTime.now().millisecond.toString();
                  if(isNewUser && _email.text.isNotEmpty && _password.text.isNotEmpty && _confirmPasswordController.text == _password.text){
                    ConnectUser connectUser = ConnectUser(email: _email.text, password: _password.text, userId: userId);
                    await profileDb.signUp(connectUser).then((value){
                      ConnectUserProvider.setUserId(userId);
                      ConnectUserProvider.setSessionId(value.$id);
                      print(ConnectUserProvider.sessionId);
                      print(ConnectUserProvider.userId);
                      toggleLoading();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => ProfileScreen(userId: userId,)), (route) => false);
                    });
                  }
                  if(!isNewUser && _email.text.isNotEmpty && _password.text.isNotEmpty){
                    await profileDb.signIn(_email.text, _password.text).then((value){
                      ConnectUserProvider.setSessionId(value.$id);
                      ConnectUserProvider.setUserId(value.userId);
                      print(ConnectUserProvider.sessionId);
                      print(ConnectUserProvider.userId);
                      toggleLoading();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => const HomeScreen()), (route) => false);
                    });
                  }
                },
                child: isLoading? const CircularProgressIndicator() : isNewUser? const Text('Sign up', style: TextStyle(fontSize: 20),) : const Text('Login', style: TextStyle(fontSize: 20),),
              ),
              const SizedBox(height: 10,),
              TextButton(
                  onPressed: () {
                    setState(() {
                      isNewUser = !isNewUser;
                    });
                  },
                  child: isNewUser? const Text('Already a user? Login here!', style: TextStyle(fontSize: 18),) : const Text('New User? Sign up here!', style: TextStyle(fontSize: 18),)
              )
            ],
          ),
        ),
      ),
    );
  }
}


