import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:irl/data/user_characteristics.dart';
import 'package:irl/main.dart';
import 'package:irl/models/users.dart';
import 'package:irl/widgets/gradient_button.dart';

class InterestDetails extends StatefulWidget {
  final bool isPreferences;
  const InterestDetails({super.key, required this.isPreferences});

  @override
  State<InterestDetails> createState() => _InterestDetailsState();
}

class _InterestDetailsState extends State<InterestDetails> {

  List<String>? interests=[];

  void autoPopulate(CustomUser user){
    if(!widget.isPreferences){
      if(user.interests!=null && user.interests!.isNotEmpty) interests = List.from(user.interests!);
    }
    else{
      if(user.interestPreference!=null && user.interestPreference!.isNotEmpty) interests = List.from(user.interestPreference!);
    }
  }

  bool listEquals(List<String>? list1, List<String>? list2){
    if(list1==null && list2==null) return true;
    if(list1!=null && list2==null) return list1.isEmpty;
    if(list1==null && list2!=null) return list2.isEmpty;
    if(list1!.length!=list2!.length) return false;
    for(int i=0;i<list1.length;i++){
      if(!list2.contains(list1[i])){
        return false;
      }
    }
    return true;
  }

  bool checkStateChange(CustomUser user){
    if(widget.isPreferences){
      return !listEquals(user.interestPreference, interests);
    }
    return !listEquals(user.interests, interests);
  }


  void submit() async{
    try{
      if(!widget.isPreferences){
        if (interests!.isNotEmpty) {
          setState(() {
            store.dispatch(UpdateInterestDetails(interests));
          });
          FirebaseAuth auth = FirebaseAuth.instance;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(auth.currentUser?.uid)
              .update({'interests': interests}).then(
                  (value) {
                Navigator.of(context).pop();
              });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Select some values',
                    style: Theme.of(context).textTheme.bodySmall,
                  )));
        }
      }
      else{
        if (interests!.isNotEmpty) {
          store.dispatch(UpdateInterestPreference(interests));
          FirebaseAuth auth = FirebaseAuth.instance;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(auth.currentUser?.uid)
              .update({'interestsPreference': interests}).then(
                  (value) {
                Navigator.of(context).pop();
              });
        }
        else{
          Navigator.of(context).pop();
        }
      }
    }catch(e){
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString(),
              style: Theme.of(context).textTheme.bodySmall,)));
      }
    }
  }

  bool enabled=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(widget.isPreferences?'Interest Preferences':'What are your interests?',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StoreBuilder<CustomUser?>(
        onInit: (user){
          autoPopulate(user.state!);
          interestTitles.sort((a,b){
            if(interests!.contains(a)&&!interests!.contains(b)){
              return -1;
            }
            else if((interests!.contains(a)&&interests!.contains(b) )|| (!interests!.contains(a)&&!interests!.contains(b) )){
              return 0;
            }
            return 1;
          });
        },
        builder: (context, user) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(23.0),
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: interestTitles.map((e){
                  return InkWell(
                    borderRadius: BorderRadius.circular(60),
                    onTap: (){
                      setState(() {
                        if(interests!.contains(e)){
                          interests!.remove(e);
                        }
                        else {
                          interests!.add(e);
                        }
                        enabled=checkStateChange(store.state!);
                      });
                    },
                    child: CircleAvatar(
                      radius: (MediaQuery.of(context).size.width-66)/6,
                      backgroundColor: interests!.contains(e)?
                          Theme.of(context).colorScheme.primary:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      child: CircleAvatar(
                        radius: ((MediaQuery.of(context).size.width-66)/6) - 1 ,
                        backgroundColor: interests!.contains(e)?
                            Theme.of(context).colorScheme.primary:
                            Theme.of(context).colorScheme.background,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              e,
                              style: Theme.of(context).textTheme.bodyMedium,
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 68,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFDB7E80),
                    Color(0xFF8147A7),
                    Color(0xFF3008D9),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GradientButton(
                enable: enabled,
                label: 'Update',
                onTap: submit,
              ),
            )
          ],
        ),
      )
    );
  }
}
