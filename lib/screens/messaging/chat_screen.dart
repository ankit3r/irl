import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:irl/models/users.dart';
import 'package:irl/widgets/message_bubble.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String user2Id;
  final String conversationId;
  const ChatScreen({super.key, required this.conversationId, required this.user2Id});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  TextEditingController controller = TextEditingController();
  CustomUser? user2;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0,3,3,3),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.background,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').doc(widget.user2Id).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      user2=CustomUser.fromJSON(snapshot.data!.data()!);
                      return ClipOval(
                          child: Image.network(
                            user2!.profileImage!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                      );
                    }
                    else{
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 10,),
            StreamBuilder<dynamic>(
              stream: FirebaseFirestore.instance.collection('users').doc(widget.user2Id).snapshots(),
              builder: (ctx,snapShot){
                if(snapShot.hasData) {
                  user2=CustomUser.fromJSON(snapShot.data.data());
                  return SizedBox(
                    width: 170,
                    child: Text(user2!.fullName!,
                      overflow: TextOverflow.fade,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge,
                    ),
                  );
                }
                else if(snapShot.connectionState==ConnectionState.waiting){
                  return const Text('Loading...');
                }
                else{
                  return const Text('Some error occurred!');
                }
              },
            ),
          ],
        ),

        actions:  [
          IconButton(onPressed: () {
          },
            icon:const Icon(Icons.phone),),
          IconButton(onPressed: () {
          },
            icon:const Icon(Icons.more_vert),)
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: StreamBuilder<dynamic>(
                stream: FirebaseFirestore.instance.collection('conversations').doc(widget.conversationId).collection('messages')
                    .orderBy('timestamp',descending: true).snapshots(),
                builder: (ctx,streamSnapshot) {
                  if(streamSnapshot.connectionState==ConnectionState.waiting){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else if(streamSnapshot.hasData){
                    var docs=streamSnapshot.data.docs;
                    return ListView.builder(
                        reverse: true,
                        itemCount: docs.length,
                        itemBuilder: (ctx,index){
                          if(docs.length==0){
                            return const Center(child: Text("Break the ice!"));
                          }
                          if(index==docs.length-1 ||
                              (index!=0 && DateTime.parse(docs[index-1]['timestamp']).day!=DateTime.parse(docs[index]['timestamp']).day)
                          ){
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(docs[index]['timestamp'])),
                                      style: Theme.of(context).textTheme.bodySmall,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                Bubble(
                                message:docs[index]['text'],
                                  dateTime: DateTime.parse(docs[index]['timestamp']),
                                  uid: docs[index]['senderId'],
                                ),
                              ],
                            );
                          }
                          return  Bubble(
                            message:docs[index]['text'],
                            dateTime: DateTime.parse(docs[index]['timestamp']),
                            uid: docs[index]['senderId'],
                          );
                        }
                    );
                  }
                  else{
                    return const Center(child: Text("Break the ice!"));
                  }
                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () async {
                        String message=controller.text;
                        if(message.isNotEmpty){
                          controller.clear();
                          await FirebaseFirestore.instance.collection('conversations')
                              .doc(widget.conversationId).collection('messages').add(
                              {
                                'text':message,
                                'senderId': StoreProvider.of<CustomUser?>(context).state!.uid,
                                'timestamp': DateTime.now().toString()
                              }
                          );

                          await FirebaseFirestore.instance.collection('conversations')
                              .doc(widget.conversationId).update(
                              {
                                'lastSent': DateTime.now().toString()
                              }
                          );
                        }
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: 'Message',
                  labelStyle: Theme.of(context).textTheme.labelMedium,
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)))
              ),
              controller: controller,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        ],
      ),
    );
  }
}