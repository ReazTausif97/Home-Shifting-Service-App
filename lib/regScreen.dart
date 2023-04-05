import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new1/loginScreen.dart';
import 'package:new1/main.dart';
import 'package:new1/mainscreen.dart';
import 'package:new1/progressreport.dart';


class RegScreen extends StatelessWidget {
  //const RegScreen({Key key}) : super(key: key);
  static const String idScreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 25.0,),
              Image(
                image: AssetImage ("images/logo.png"),
                width: 300.0,
                height: 150.0,
                alignment: Alignment.center,
              ),

              SizedBox(height: 3.0,),
              Text(
                "Register As Service Provider",
                style: TextStyle(fontSize: 23.0, fontFamily: "Brand Bold",color: Colors.red),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      controller:nameTextEditingController ,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name",
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
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: "Phone no.",
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
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "email",
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
                            "Register",
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
                        else if (phoneTextEditingController.text.isEmpty)
                        {
                          displayToast("Enter your phone number", context);
                        }
                        else if(passwordTextEditingController.text.length <8)
                        {
                          displayToast("password must be atleast 8 characters", context);
                        }
                        else{
                          registerNewuser(context);
                        }

                      },
                    )

                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Already have an account? Login here",
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance ;

  void registerNewuser(BuildContext context) async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressReport(message:"Registering,Please Wait...");
        }
    );
    final User firebaseUser =(await _firebaseAuth.createUserWithEmailAndPassword(email: emailTextEditingController.text, password: passwordTextEditingController.text).catchError((errMsg){
      Navigator.pop(context);
      displayToast("Error: " + errMsg.toString(), context);
    })).user;

    //final User firebaseUser = (await _firebaseAuth.signInWithPhoneNumber(phoneTextEditingController))

    if (firebaseUser != null){
      Map userDataMap = {
        "name" : nameTextEditingController.text.trim(),
        "email" : emailTextEditingController.text.trim(),
        "phone" : phoneTextEditingController.text.trim(),

      };

      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToast("Account has been created succesfully", context);
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

    }
    else {
      Navigator.pop(context);
      displayToast("new account is not created", context);


    }

  }
}

displayToast(String message, BuildContext context)
{
  Fluttertoast.showToast(msg: message);
}
