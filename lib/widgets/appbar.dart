import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

AppBar purohithAppBar(BuildContext context, String title, {bool? backButton}) {
  final fbuser = FirebaseAuth.instance.currentUser;
  final uid = fbuser?.uid;
  final DatabaseReference firebaseRealtimeWalletRef =
      FirebaseDatabase.instance.ref().child('wallet');

  return AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: backButton == null ? true : false,
    title: Text(title),
    actions: [
      title == 'Book Purohith'
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  color: const Color(0xFFF5C662),
                  onPressed: () {
                    Navigator.pushNamed(context, "wallet");
                  },
                  icon: const Icon(
                    Icons.wallet,
                    color: Color(0xFFF5C662),
                  ),
                ),
                if (uid != null)
                  StreamBuilder(
                    stream: firebaseRealtimeWalletRef.child(uid).onValue,
                    builder: (BuildContext context,
                        AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting ||
                          !snapshot.hasData ||
                          snapshot.data!.snapshot.value == null) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('0', style: TextStyle(fontSize: 18)),
                        );
                      }

                      Map<dynamic, dynamic> fbValues = snapshot
                          .data!.snapshot.value as Map<dynamic, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          fbValues['amount'].toStringAsFixed(2),
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    },
                  ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  color: const Color(0xFFF5C662),
                  onPressed: () {
                    Navigator.pushNamed(context, "wallet");
                  },
                  icon: const Icon(Icons.wallet),
                ),
                if (uid != null)
                  StreamBuilder(
                    stream: firebaseRealtimeWalletRef.child(uid).onValue,
                    builder: (BuildContext context,
                        AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting ||
                          !snapshot.hasData ||
                          snapshot.data!.snapshot.value == null) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('0', style: TextStyle(fontSize: 18)),
                        );
                      }

                      Map<dynamic, dynamic> fbValues = snapshot
                          .data!.snapshot.value as Map<dynamic, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          fbValues['amount'].toStringAsFixed(2),
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    },
                  ),
              ],
            ),
    ],
  );
}
