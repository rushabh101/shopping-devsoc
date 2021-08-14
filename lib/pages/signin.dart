import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Signin extends StatelessWidget {
  const Signin({Key? key}) : super(key: key);

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  @override
  Widget build(BuildContext context) {

    TextEditingController usrnm = new TextEditingController();
    TextEditingController pswrd = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: usrnm,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 10.0,),
              TextField(
                controller: pswrd,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  bool signin = true;
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: usrnm.text,
                        password: pswrd.text,
                    );
                  } on FirebaseAuthException catch (e) {
                    signin = false;
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("No user found for that email"),
                      ));
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Incorrect Password"),
                      ));
                    }
                  }
                  if(signin) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                child: Text("Sign In"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await signInWithGoogle();
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text("Sign in with Google"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text("Create Account")
              ),
            ],
          ),
        ),
      ),
    );
  }
}
