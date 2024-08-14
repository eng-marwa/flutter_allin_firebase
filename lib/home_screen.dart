import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group3_firebase/app_user.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseAuth _mAuth;
  late DatabaseReference _reference;
  late FirebaseFirestore _firestore;
  late Reference _storageRef;
  String? url;

  @override
  void initState() {
    super.initState();
    _mAuth = FirebaseAuth.instance;
    _reference = FirebaseDatabase.instance.ref();
    _firestore = FirebaseFirestore.instance;
    _storageRef = FirebaseStorage.instance.ref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            url != null
                ? Image.network(
                    url!,
                    width: 200,
                  )
                : SizedBox(),
            ElevatedButton(
                onPressed: () => _saveUserData(),
                child: Text('Save user data')),
            ElevatedButton(
                onPressed: () => _viewUserData(),
                child: Text('View user data')),
            ElevatedButton(
                onPressed: () => _saveUserDataInFirestore(),
                child: Text('Save user data in firestore')),
            ElevatedButton(
                onPressed: () => _viewUserDataFromFirestore(),
                child: Text('View user data from firestore')),
            ElevatedButton(
                onPressed: () => _uploadProfilePic(),
                child: Text('upload Profile Picture')),
          ],
        ),
      ),
    );
  }

  _saveUserData() {
    AppUser user = AppUser('marwa', '6598956666', _mAuth.currentUser!.email!,
        _mAuth.currentUser!.uid, 'Mansoura');
    _reference
        .child('users')
        .child(_mAuth.currentUser!.uid)
        .set(user.toMap())
        .then(
      (value) {
        print('Data Saved');
      },
    );
  }

  _viewUserData() {
    _reference.child('users').child(_mAuth.currentUser!.uid).onValue.listen(
      (event) {
        // print(event.snapshot.value);
        // print(event.snapshot.value.runtimeType);
        Map<String, dynamic> data =
            Map.from(event.snapshot.value as Map<Object?, Object?>);
        AppUser user = AppUser.fromMap(data);
        print(user);
      },
    );
  }

  _saveUserDataInFirestore() {
    AppUser user = AppUser('marwa', '6598956666', _mAuth.currentUser!.email!,
        _mAuth.currentUser!.uid, 'Mansoura');
    _firestore
        .collection('users')
        .doc(_mAuth.currentUser!.uid)
        .set(user.toMap())
        .then(
      (value) {
        print('data saved');
      },
    ).catchError((error) => print(error));
  }

  _viewUserDataFromFirestore() {
    _firestore.collection('users').doc(_mAuth.currentUser!.uid).get().then(
      (value) {
        // print(value.data());
        // print(value.data().runtimeType);
        AppUser user = AppUser.fromMap(value.data() as Map<String, dynamic>);
        print(user);
      },
    ).catchError((error) => print(error.toString()));
  }

  _uploadProfilePic() async {
    String? path = await _getImagePath();
    var _time = DateTime.now().microsecond;
    if (path != null) {
      File file = File(path);
      _storageRef
          .child('images')
          .child(_mAuth.currentUser!.uid)
          .child('pic_$_time.jpg')
          .putFile(file)
          .then(
        (task) async {
          // print(task.state.name);
          // print(task.ref.getDownloadURL());
          if (task.state == TaskState.success) {
            print(task.state == TaskState.success);
            String url = await task.ref.getDownloadURL();
            setState(() {
              this.url = url;
            });
            print(url);
          }
        },
      ).catchError((error) => print(error.toString()));
    }
  }

  Future<String?> _getImagePath() async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: ImageSource.camera);
    return xFile?.path;
  }
}
