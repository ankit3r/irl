import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:irl/screens/index.dart";

import "../../main.dart";
import "../../models/users.dart";

class WaitList extends StatefulWidget {
  const WaitList({super.key});

  @override
  State<WaitList> createState() => _WaitListState();
}

class _WaitListState extends State<WaitList> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: InkWell(
          onTap: (){
            store.dispatch(ClearUserAction());
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context)=>const Wrapper()),
                    (route) => route.settings.name=='/');
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150
                ),
                Padding(
                  padding: const EdgeInsets.all(23.0),
                  child: Text(
                    "You're now on our waiting list.Thank you for applying! We'll contact you within 48 hours once the verification is done. Be sure to check your email for updates.",
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}