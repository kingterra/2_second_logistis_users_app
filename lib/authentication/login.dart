import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_users_app/global/global.dart';
import 'package:foodpanda_users_app/mainScreens/InitialScreen.dart';
import 'package:foodpanda_users_app/mainScreens/home_screen.dart';
import 'package:foodpanda_users_app/widgets/custom_text_field.dart';
import 'package:foodpanda_users_app/widgets/error_diolog.dart';
import 'package:foodpanda_users_app/widgets/loaading_dialog.dart';

import 'auth_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation()
  {
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty)
    {
      //Login
      LogiNow();

    }
    else
      {
        showDialog(
          context: context,
          builder: (c){
            return ErrorDiolog(message: "Please write email/password.",);
          }
        );
      }
  }

  LogiNow() async
   {
    showDialog(
        context: context,
        builder: (c){
          return LoadingDiolog(
            message: "Checking Credentials",);
        }
    );
    User? currentUser;
    await firebaseAuth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),

    ).then((auth) {
      currentUser= auth.user!;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c){
            return ErrorDiolog(message: error.message.toString(),
            );
          }
      );

    });
    if(currentUser !=null){

      readDataAndSetDataLocally(currentUser!);

    }
  }

  Future readDataAndSetDataLocally(User currentUser) async
  {
    await FirebaseFirestore.instance.collection("users") //from this sellers collection
        .doc(currentUser.uid) //this spacific user
        .get().then((snapshot) async  { //get data locally
          if(snapshot.exists){
            await sharedPreferences!.setString("uid", currentUser.uid);
            await sharedPreferences!.setString("email", snapshot.data()!["email"]);
            await sharedPreferences!.setString("name", snapshot.data()!["name"]);
            await sharedPreferences!.setString("photoUrl", snapshot.data()!["photoUrl"]);
            //when the user login we have toretrieve the cart from the firestore

            List<String> userCartList = snapshot.data()!["userCart"].cast<String>();
            await sharedPreferences!.setStringList("userCart", userCartList);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (c) => InitialScreen()));

          }else{
            firebaseAuth.signOut();
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));
            showDialog(
                context: context,
                builder: (c){
                  return ErrorDiolog(message: "no record found.",
                  );
                }
            );
          }





    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Image.asset(
                "images/login.png",
                height: 270,


              ),
            ),


          ),
          Form(
            key: _formkey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: "email",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: "password",
                  isObsecre: true,
                ),
              ],
            ),
          ),
          ElevatedButton(
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),

            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.purple,
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),

            ),
            onPressed: ()
            {
              formValidation();
            },
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }
}
