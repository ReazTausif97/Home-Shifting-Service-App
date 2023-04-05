import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:new1/appData.dart';
import 'package:new1/mainscreen.dart';
import 'package:new1/loginScreen.dart';
import 'package:new1/regScreen.dart';
import 'package:provider/provider.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> AppData(),
      child: MaterialApp(
        title: 'Household Shifting Service',
        theme: ThemeData(
          // fontFamily: "Brand Bold",
          primarySwatch: Colors.blue,
        ),
        initialRoute: MainScreen.idScreen,
        routes:
        {
          RegScreen.idScreen: (context)=>RegScreen(),
          LoginScreen.idScreen : (context)=>LoginScreen(),
          MainScreen.idScreen : (context)=>MainScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );

  }
}


