import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class RealtimeDatabaseService {
  late final String? uuid;
  late final String userRef;
  late DatabaseReference taskRef;
  RealtimeDatabaseService({required this.uuid}) {
    userRef = 'users/$uuid';
    taskRef = FirebaseDatabase.instance.ref(userRef);
  }


  Future<void> createData(String child, Map<String, dynamic> payload) async {
    await taskRef
        .child(child)
        .push()
        .set(payload)
        .then((value) {
          print("success on $child");
    })
        .catchError((onError) {
          print(onError);
    });
  }

  Future<void> updateData(String child, Map<String, dynamic> payload) async {
    await taskRef
        .child(child)
        .update(payload)
        .then((value) {
          print('sucess on $child');
    })
        .catchError((onError) {
          print(onError);
    });
  }

  Future<void> deleteData(String child) async {
    await taskRef
        .child(child)
        .remove()
        .then((value) {
          print("success on $child");
    })
        .catchError((onError) {
          print(onError);
    });
  }

  Future<Object?> fetchData(String path) async {
    final snapshot = await taskRef.child(path).get();
    if (snapshot.exists) {
      return snapshot.value;
    } else {
      print('no data found');
    }
    return {};
  }

}