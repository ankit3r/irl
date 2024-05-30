import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:irl/main.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/getting_started.dart';
import 'package:irl/screens/home.dart';
import 'package:irl/screens/registration/registration_name.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});



  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, streamSnapshot) {
        if(streamSnapshot.connectionState==ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        else if(streamSnapshot.hasData){
          return FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
            future: FirebaseFirestore.instance.collection('users').doc(streamSnapshot.data!.uid).get(),
            builder:(ctx,futureSnapshot){
              if(futureSnapshot.connectionState==ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }
              else if(futureSnapshot.hasData && futureSnapshot.data!.data()!=null){
                CustomUser user = CustomUser.fromJSON(futureSnapshot.data!.data()!);
                store.dispatch(CreateUserAction(user));
                if(user.hasRegistered() && user.checkMandatoryFields()){
                  return const Home();
                }
                else if(user.hasRegistered() && !user.checkMandatoryFields()){
                  return const Home();
                }
                else{
                  return const RegistrationName();
                }
              }
              else{
                return const GettingStarted();
              }
            },
          );
        }
        else{
          return const GettingStarted();
        }
      },
    );
  }
}
