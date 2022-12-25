import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_chatapp/Pages/HomePage.dart';
import 'package:provider/provider.dart';

import '../Provider/Authentication.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  var signup = Scaffold(body: Center(child: CircularProgressIndicator()));


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //stream: c.user,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return RegisterPage();
        }
      },
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController nm = TextEditingController();
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
              margin: EdgeInsets.only(top: 20, bottom: 50, right: 50, left: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/chat.png',
                    scale: 6,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    "Simple Chat",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                   controller: nm,
                   // onSaved: (input)=>auth.name = input,
                    decoration: InputDecoration(
                      labelText: "Name",
                      prefixIcon: Icon(Icons.person),
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: "Mr. John",
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
                  SizedBox(
                    height: 25,
                  ),

                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: em,
                    //onSaved:(input)=>auth.email_ = input ,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.alternate_email),
                      labelStyle: TextStyle(color: Colors.black),
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
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                  controller: pass,
                  //  onSaved: (input)=> auth.password_=input,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock_outline),
                      labelStyle: TextStyle(color: Colors.black),
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
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Re-Password",
                      prefixIcon: Icon(Icons.lock_outline),
                      labelStyle: TextStyle(color: Colors.black),
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
                  SizedBox(
                    height: 25,
                  ),
                  //login button
                  MaterialButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Signing Up...')));
                      try {
                        //showLoaderDialog(context);

                        bool isSuccess =  auth.handleSignUp(nm.text,em.text,pass.text);
                        if(isSuccess){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('User Created')));
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error! Try google signin.')));
                      } on PlatformException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                          children: [
                            Text(
                              "  Sign Up ",
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
                  SizedBox(
                    height: 50,
                  ),
                  Text("Or"),
                ],
              )),
          Container(
            padding: EdgeInsets.only(bottom: 10, left: 25, right: 25),
            alignment: Alignment.bottomCenter,
            child: MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: () async {
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
                      Text(
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
