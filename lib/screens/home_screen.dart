import 'package:firstapp/screens/Dictionary.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();


  @override
  
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome",),
      ),

      body: Container(
        padding:EdgeInsets.all(50),
        child: Row(
          
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(5),
      color: Colors.blueAccent,
      child: MaterialButton(
              height: 200,
              minWidth: 200,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => dictionary()));
               
              },
              child: Text(
                "SEARCH WORD",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
              )),
    ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text("WELCOME"),
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage("assets/download.jpg"),
                     fit: BoxFit.cover) ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  )),
              subtitle: Text("Personal"),
              trailing: Icon(Icons.edit),
              ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text("${loggedInUser.email}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  )),
              
              trailing: Icon(Icons.send),
              ),
            ActionChip(
                  label: Text("Logout"),
                  onPressed: () {
                    logout(context);
                  }),
            ],
         ),
      ),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}  