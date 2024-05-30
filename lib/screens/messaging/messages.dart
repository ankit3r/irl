import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/messaging/chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int tab=0;
  TextEditingController searchController = TextEditingController();

  void openChatScreen(String otherUserId, BuildContext context) async {

    await createOrGetConversationId(otherUserId).then((value){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(conversationId: value, user2Id: otherUserId,),
        ),
      );
    });
  }

  Future<String> createOrGetConversationId(String otherUserId) async {
    String currentUserId = StoreProvider.of<CustomUser?>(context).state!.uid!;
    // Check if a conversation already exists between these users
    QuerySnapshot query1 = await FirebaseFirestore.instance
        .collection('conversations')
        .where('participants', arrayContains: currentUserId)
        .get();

    QuerySnapshot query2 = await FirebaseFirestore.instance
        .collection('conversations')
        .where('participants', arrayContains: otherUserId)
        .get();

    List<String> conversationIds1 = query1.docs.map((doc) => doc.id).toList();
    List<String> conversationIds2 = query2.docs.map((doc) => doc.id).toList();

    List<String> commonConversationIds = conversationIds1
        .where((id) => conversationIds2.contains(id))
        .toList();

    if (commonConversationIds.isNotEmpty) {
      return commonConversationIds.first;
    }
    else {
      DocumentReference conversationRef = FirebaseFirestore.instance.collection('conversations').doc();
      await conversationRef.set({
        'participants': [currentUserId,otherUserId]
      });
      return conversationRef.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(116),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8,0,8,8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                              padding: const EdgeInsets.all(9.0),
                              child: Center(
                                child: Text('Inbox',
                                  style: tab==0?Theme.of(context).textTheme.bodyMedium:
                                  Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                              padding: const EdgeInsets.all(9.0),
                              child: Center(
                                child: Text('Requests',
                                  style: tab==1?Theme.of(context).textTheme.bodyMedium:
                                  Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                const SizedBox(height: 15,),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.surface
                      ),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10)
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5,0,5,0),
                    child: TextField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          icon: const Padding(
                            padding: EdgeInsets.fromLTRB(8,0,8,0),
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
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(
              StoreProvider.of<CustomUser?>(context).state!.uid
            ).collection('matchedUsers').snapshots(),
            builder: (ctx,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if(snapshot.hasError){
                return const Center(child: Text("OOPS"));
              }
              final List<QueryDocumentSnapshot> matches = snapshot.data!.docs;
              if(matches.isEmpty){
                return Center(
                  child: Text(
                      'Your inbox is empty!',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return ListView.builder(
                itemCount: matches.length,
                itemBuilder: (context, index){
                  final QueryDocumentSnapshot match = matches[index];
                  String matchedUserId = match.id;
                  return FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
                      future: FirebaseFirestore.instance.collection('users')
                          .doc(matchedUserId).get(),
                      builder: (context, futureSnapshot){
                        if(futureSnapshot.connectionState==ConnectionState.waiting){
                          return const SizedBox();
                        }
                        CustomUser user = CustomUser.fromJSON(futureSnapshot.data!.data()!);
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 4),
                          onTap: (){
                            openChatScreen(matchedUserId, context);
                          },
                          leading: CircleAvatar(
                            radius: 40,
                                backgroundImage: NetworkImage(
                                  user.profileImage!,
                                )
                              ),
                          title: Text(
                              user.fullName!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      }
                  );
                },
              );
            }
        ),
      ),
    );
  }
}
