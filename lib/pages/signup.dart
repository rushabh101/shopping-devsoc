import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    TextEditingController username = new TextEditingController();
    TextEditingController password = new TextEditingController();
    TextEditingController passwordConfirm = new TextEditingController();

    bool createAcc = true;

    createAccount(String username, String password) async{
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: username,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Account exists"),
          ));
        }
        createAcc = false;
      } catch (e) {
        print(e);
        // createAcc = false;
      }
      if(createAcc) {
        FirebaseFirestore.instance.collection('users').add({
          'email' : FirebaseAuth.instance.currentUser!.email,
        })
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Created account"),
        ));
      }
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: username,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 10.0,),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 10.0,),
              TextField(
                controller: passwordConfirm,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if(passwordConfirm.text == password.text) {
                    createAccount(username.text, password.text);
                  }
                  else {
                    print("passwords do not match");
                  }
                },
                child: Text("Sign Up"),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
