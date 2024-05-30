import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/people/people_profile_details.dart';

class PeopleIndex extends StatefulWidget {
  const PeopleIndex({super.key});

  @override
  State<PeopleIndex> createState() => _PeopleIndexState();
}

class _PeopleIndexState extends State<PeopleIndex> {
  int tab=0;
  List<String> description =[
    "People you have liked will be shown here.These are profiles you've expressed initial interest in",
    "Both you and the other person have expressed interest in each other, indicating a potential match.",
    "Profiles that have indicated interest in you by swiping. These are users who have shown initial interest in connecting with you.",
    "Profiles you have chosen to restrict from interacting with you. You won't receive messages or notifications from these profiles."
  ];

  List<String> error =[
    "Looks like you haven't liked an profile yet!",
    "Looks like there are no matches right now. No worries, someone special might be just around the corner!",
    "Looks like there are no profiles in your 'Liked You' list right now. No worries, someone special might be just around the corner!",
    "Oops! It seems there are no profiles in your Blocked list at the moment. You're free from unwanted interactions for now!"
  ];
  TextEditingController searchController = TextEditingController();

  Stream<QuerySnapshot<Map<String, dynamic>>> getCurrentStream() {
    switch (tab) {
      case 0:
        return FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('likedUsers')
            .snapshots();
      case 1:
        return FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('matchedUsers')
            .snapshots();
      case 2:
        return FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('likedBy')
            .snapshots();
      case 3:
        return FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('blockedUser')
            .snapshots();
      default:
        throw Exception("Invalid tab index");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peoples', style: Theme.of(context).textTheme.bodyLarge,),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8,0,8,8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(5,5,5,5),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.surface
                      )
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          onTap: (){
                            setState(() {
                              tab=0;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                color: tab==0?Theme.of(context).colorScheme.primary:null
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Center(
                                child: Text('Liked',
                                  style: tab==0?Theme.of(context).textTheme.bodySmall:
                                  Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.grey
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          onTap: (){
                            setState(() {
                              tab=1;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                color: tab==1?Theme.of(context).colorScheme.primary:null
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Center(
                                child: Text('Matched',
                                  style: tab==1?Theme.of(context).textTheme.bodySmall:
                                  Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.grey
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          onTap: (){
                            setState(() {
                              tab=2;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                color: tab==2?Theme.of(context).colorScheme.primary:null
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Center(
                                child: Text('Like you',
                                  style: tab==2?Theme.of(context).textTheme.bodySmall:
                                  Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.grey
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          onTap: (){
                            setState(() {
                              tab=3;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                color: tab==3?Theme.of(context).colorScheme.primary:null
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Center(
                                child: Text('Blocked',
                                  style: tab==3?Theme.of(context).textTheme.bodySmall:
                                  Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.grey
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8,8,8,0),
                      child: Text(
                        description[tab],
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                Container(
                  margin: const EdgeInsets.fromLTRB(5,0,5,0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.surface
                      ),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(30)
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5,0,5,0),
                    child: TextField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          icon: const Padding(
                            padding: EdgeInsets.fromLTRB(7,0,7,0),
                            child: Icon(Icons.search,color: Colors.grey,),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Search',
                          labelStyle: Theme.of(context).textTheme.labelMedium,
                          border: const OutlineInputBorder(borderSide: BorderSide.none)
                      ),
                      controller: searchController,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: StreamBuilder(
          stream: getCurrentStream(),
          builder: (context, snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }
            else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
              return Center(
                  child: Text(error[tab],
                    style: Theme.of(context).textTheme.labelSmall,
                    textAlign: TextAlign.center,
                  )
              );
            }
            else if(snapshot.hasData && snapshot.data!.docs.isNotEmpty){
              List<String> data = snapshot.data!.docs.map((e){
                return e.id;
              }).toList();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 10,
                          children: data.map((e) {
                            return FutureBuilder(
                                future: FirebaseFirestore.instance.collection('users').doc(e).get(),
                                builder: (context, snapshot){
                                  if(snapshot.connectionState==ConnectionState.waiting){
                                    return const SizedBox();
                                  }
                                  CustomUser profile = CustomUser.fromJSON(snapshot.data!.data()!);
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: (){
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context)=>
                                            PeopleProfileDetails(
                                              profile: profile,
                                              type:tab==0?Profile.liked:tab==1?Profile.matched:Profile.likeYou
                                          )
                                        )
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        height: MediaQuery.of(context).size.longestSide*0.23,
                                        width: MediaQuery.of(context).size.shortestSide*0.44,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Image.network(
                                              profile.profileImage!,
                                              height: MediaQuery.of(context).size.longestSide*0.23,
                                              width: MediaQuery.of(context).size.shortestSide*0.44,
                                              fit: BoxFit.cover,
                                            ),
                                            Container(
                                              height: MediaQuery.of(context).size.longestSide*0.23*0.4,
                                              width: MediaQuery.of(context).size.shortestSide*0.44,
                                              color: Colors.black.withOpacity(0.8),
                                              child: Padding(
                                                padding: const EdgeInsets.all(6.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(profile.fullName!.split(" ").first),
                                                    Text(
                                                      "${profile.currentAddressCity}, ${profile.currentAddressState} |\n${profile.heightFeet}'${profile.heightInch}\" | ${profile.gender}",
                                                      style: Theme.of(context).textTheme.bodySmall,
                                                    )
                                                  ],
                                                ),
                                              ),// Adjust opacity as needed
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(
                child: Text("Some error occurred",
                  style: Theme.of(context).textTheme.labelSmall,
                  textAlign: TextAlign.center,
                )
            );
          },
        ),
      ),
    );
  }
}