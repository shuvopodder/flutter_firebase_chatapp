import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_chatapp/Provider/Authentication.dart';
import 'package:provider/provider.dart';

import 'HomePage.dart';
import 'Register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController em = TextEditingController();
  TextEditingController pass = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Authentication auth = Provider.of<Authentication>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                  margin: const EdgeInsets.only(
                      top: 20, bottom: 50, right: 50, left: 50),
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/chat.png',
                          scale: 6,
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        const Text(
                          "Simple Chat",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: em,
                        //  onSaved: (String? inputEmail)=>email_=inputEmail,
                          validator: (String? input) => input!.contains('@')
                              ? "Should be a valid email!"
                              : null,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.alternate_email),
                            labelStyle: const TextStyle(color: Colors.black),
                            hintText: "xyz@gmail.com",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: pass,
                          //onSaved: (String? inputPassword) => password_ = inputPassword ,
                          validator: (String? input) => input!.length < 3
                              ? 'Should be more than 3 characters'
                              : null,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock_outline),
                            labelStyle: const TextStyle(color: Colors.black),
                            hintText: "*********",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        //login button

                        MaterialButton(
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: () async {

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Signing...')));

                            try {
                              bool isSuccess = await auth.handleSignIn(em.text,pass.text);
                              if (isSuccess) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('Error! Try google signin.')));
                              }
                            } on PlatformException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content:
                                  Text('No PlayStore Detected on the device!')));
                            }

                          },
                          child: Container(
                              alignment: Alignment.center,
                              height: 60,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "  Login ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              )),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),

                        const SizedBox(
                          height: 25,
                        ),
                        MaterialButton(
                          elevation: 0,
                          focusElevation: 0,
                          highlightElevation: 0,
                          onPressed: () {

                            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                          },
                          textColor: Theme.of(context).hintColor,
                          child: const Text("Signup"),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        const Text("- Or -"),
                      ],
                    ),
                  )),
              Container(
                padding: const EdgeInsets.only(bottom: 10, left: 25, right: 25),
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () async {
                    if (FirebaseAuth.instance != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    }else{
                      try {
                        //showLoaderDialog(context);
                        bool isSuccess = await auth.handleGoogleSignIn();
                        if (isSuccess) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        }
                      } on PlatformException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content:
                            Text('No PlayStore Detected on the device!')));
                      }
                    }

                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Google.png',
                            scale: 30,
                          ),
                          const Text(
                            "  Login with Google",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      )),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              )
            ],
          ),
        ));
  }
}
