import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group3_firebase/home_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseAuth _mAuth;

  @override
  void initState() {
    super.initState();
    _mAuth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    String? data = ModalRoute.of(context)?.settings.arguments as String?;
    print('recieved message $data');
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              data ?? '',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            ElevatedButton(
                onPressed: () => _login('eng_marwa@gmial.com', '123456789'),
                child: Text('login')),
            ElevatedButton(
                onPressed: () => _register('marwa@gmail.com', '123456789'),
                child: Text('register')),
          ],
        ),
      ),
    );
  }

  _login(String email, String password) async {
    try {
      UserCredential credential = await _mAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        print('Welcome ${credential.user!.email!}');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      print('${e.code}  ${e.message}');
    }
  }

  _register(String email, String password) async {
    try {
      UserCredential credential = await _mAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        print('Welcome ${credential.user!.email!}');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      print('${e.code} ${e.message}');
    }
  }
}
