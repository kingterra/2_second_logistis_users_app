import 'package:flutter/material.dart';
import 'package:foodpanda_users_app/mainScreens/my_orders_screen.dart';

import '../authentication/auth_screen.dart';
import '../global/global.dart';

class SettingsScreen extends StatefulWidget {

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [
                //header drawer
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Container(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            sharedPreferences!.getString("photoUrl")!

                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  sharedPreferences!.getString("name")!,
                  style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: ""),
                ),
              ],
            ),

          ),

          SizedBox(height: 25,),
          //body drawer

          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(
              children: [

                ListTile(
                  leading: const Icon(Icons.reorder, color: Colors.black,),
                  title: const Text(
                    "My Order",
                    style: TextStyle(color: Colors.black,),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> MyOrdersScreen()));
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.access_time, color: Colors.black,),
                  title: const Text(
                    "History",
                    style: TextStyle(color: Colors.black,),
                  ),
                  onTap: () {},
                ),

                ListTile(
                  leading: const Icon(Icons.search, color: Colors.black,),
                  title: const Text(
                    "Search",
                    style: TextStyle(color: Colors.black,),
                  ),
                  onTap: () { },
                ),

                ListTile(
                  leading: const Icon(Icons.add_location, color: Colors.black,),
                  title: const Text(
                    "Add New Adress",
                    style: TextStyle(color: Colors.black,),
                  ),
                  onTap: () {},
                ),

                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.black,),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.black,),

                  ),
                  onTap: ()
                  {
                    firebaseAuth.signOut().then((value){

                      Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));

                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}