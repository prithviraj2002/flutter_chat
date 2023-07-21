import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat/database/db.dart';
import 'package:flutter_chat/provider/user_provider.dart';
import 'package:flutter_chat/screens/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _name = TextEditingController();

  bool isNewUser = true;
  String image = '';

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30,),
              isNewUser ? Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: GestureDetector(
                  onTap: () async{
                    await Db.setImage().then((value){
                      setState(() {
                        image = value;
                      });
                    });
                  },
                  child: image.isEmpty ? const Center(child: Icon(Icons.add),) : Image.file(
                      File(image),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ) : const SizedBox(height: 30,),
              const SizedBox(height: 20,),
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
              isNewUser?
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                    hintText: 'Enter name....',
                    labelText: 'Name',
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
              OutlinedButton(
                  onPressed: (){
                    if(_email.text.isNotEmpty && _password.text.isNotEmpty){
                      if(!isNewUser){
                        Db.login(_email.text, _password.text).then(
                                (value) async{
                              if(value.userId.isNotEmpty){
                                Provider.of<UserProvider>(context, listen: false).setUserId(value.userId);
                                Provider.of<UserProvider>(context, listen: false).setSessionId(value.$id);
                                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => HomeScreen(userID: value.userId)));
                              }
                              else if(value.userId.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occurred!')));
                              }
                              else{
                                const Center(child: CircularProgressIndicator());
                              }
                            }
                        );
                      }
                      else{
                        Db.signUp(_email.text, _password.text, _name.text).then(
                                (value) async{
                              if(value.$id.isNotEmpty && image.isNotEmpty){
                                Provider.of<UserProvider>(context, listen: false).setSessionId(value.$id);
                                await Db.uploadImage(image, value.$id).then((value){
                                  if(value.$id.isNotEmpty){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => HomeScreen(userID: value.$id)));
                                  }
                                });
                              }
                              else if(value.$id.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occurred!')));
                              }
                              else{
                                const Center(child: CircularProgressIndicator());
                              }
                            }
                        );
                      }
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cannot register with empty values!')));
                    }
                  },
                  child: isNewUser? const Text('Sign up') : const Text('Login'),
              ),
              const SizedBox(height: 20,),
              TextButton(
                  onPressed: () {
                    setState(() {
                      isNewUser = !isNewUser;
                    });
                  },
                  child: isNewUser? const Text('Already a user? Login here!') : const Text('New User? Sign up here!')
              )
            ],
          ),
        ),
      ),
    );
  }
}


