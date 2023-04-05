import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:new1/main.dart';
import 'package:new1/mainscreen.dart';
import 'package:new1/progressreport.dart';
import 'package:new1/regScreen.dart';


class LoginScreen extends StatelessWidget {
  //const LoginScreen({Key key}) : super(key: key);
  static const String idScreen = "login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 35.0,),
              Image(
                image: AssetImage ("images/logo.png"),
                width: 300.0,
                height: 150.0,
                alignment: Alignment.center,
              ),

              SizedBox(height: 3.0,),
              Text(
                "Login As Service Provider",
                style: TextStyle(fontSize: 23.0, fontFamily: "Brand Bold",color: Colors.red),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )

                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )

                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      child: Container(
                        height: 40.0,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 18.0,fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: ()
                      {
                        if(!emailTextEditingController.text.contains("@"))
                        {
                          displayToast("please enter a valid email address", context);
                        }
                        else if(passwordTextEditingController.text.isEmpty)
                        {
                          displayToast("please provide your password", context);
                        }
                        else {
                          logInUser(context);
                        }

                      },
                    )

                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, RegScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Do not have account? Register here",
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance ;
  void logInUser(BuildContext context) async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressReport(message:"Verifying,Please Wait...");
        }
    );

    final User firebaseUser =(await _firebaseAuth.signInWithEmailAndPassword(email: emailTextEditingController.text, password: passwordTextEditingController.text).catchError((errMsg){
      Navigator.pop(context);
      displayToast("Error: " + errMsg.toString(), context);
    })).user;

    if (firebaseUser != null){
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
        if(snap.value!=null)
        {
          Navigator.pushNamedAndRemoveUntil(context,MainScreen.idScreen, (route) => false);
          displayToast("You are logged in", context);
        }
        else
        {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToast("No user found ! please create a new account first", context);

        }
      });
      displayToast("logged in successfully", context);
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

    }
    else {
      Navigator.pop(context);
      displayToast("error occured ! cannot login", context);


    }
  }
}
