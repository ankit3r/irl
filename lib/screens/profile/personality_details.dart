import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:irl/data/user_characteristics.dart';
import 'package:irl/main.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/home.dart';
import 'package:irl/screens/profile/preference_details.dart';
import 'package:irl/widgets/gradient_button.dart';

class PersonalityDetails extends StatefulWidget {
  final bool isPreference;
  const PersonalityDetails({super.key,required this.isPreference});

  @override
  State<PersonalityDetails> createState() => _PersonalityDetailsState();
}

class _PersonalityDetailsState extends State<PersonalityDetails> {

  List<String>? personalityType=[];

  void autoPopulate(CustomUser user){
    if(widget.isPreference){
      if(user.personalityPreference!=null)personalityType=List.from(user.personalityPreference!);
    }
    else{
      if(user.personalityType!=null)personalityType=List.from(user.personalityType!);
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
    if(widget.isPreference){
      return !listEquals(user.personalityPreference as List<String>, personalityType as List<String>);
    }
    return !listEquals(user.personalityType, personalityType);
  }

  void submit() async{
    try {
      if (!widget.isPreference) {
        if (personalityType!.isNotEmpty) {
          store.dispatch(
              UpdatePersonalityDetails(personalityType));
          FirebaseAuth auth = FirebaseAuth.instance;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(auth.currentUser?.uid)
              .update({
            'personalityType': personalityType
          }).then((value) {
            if(store.state!.checkMandatoryFields()){
              Navigator.of(context).pop();
            }
            else{
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PreferenceDetails())
              );
            }
          });
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Select some values',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
              )
          );
        }
      }
      else {
        store.dispatch(
            UpdatePersonalityPreferences(personalityType));
        FirebaseAuth auth = FirebaseAuth.instance;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser?.uid)
            .update({
          'personalityPreference': personalityType
        }).then((value) {
          Navigator.of(context).popAndPushNamed(
              '/preferenceDetails');
        });
      }
    }
    catch(e){
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ))
        );
      }
    }
  }

  bool enabled=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            widget.isPreference?'Personality Preferences':'Personality Details',
            style: Theme.of(context).textTheme.bodyLarge,),
          centerTitle: true,
          leading: widget.isPreference || store.state!.checkMandatoryFields()?IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ):Padding(
            padding: const EdgeInsets.all(6.0),
            child: InkWell(
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context)=>const Home()),
                        (route) => route.settings.name=='/');
              },
              child: CircleAvatar(
                child: ClipOval(
                    child: Image.network(
                      StoreProvider.of<CustomUser?>(context).state!.profileImage!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                ),
              ),
            ),
          ),
          actions: widget.isPreference?null:[
            Stack(
              alignment: Alignment.center,
              children: [
                const Center(child: Text("4/5")),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    value: 0.8,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ],
            )
          ],
        ),
        body: StoreBuilder<CustomUser?>(
          onInit: (user){
            autoPopulate(user.state!);
            personalityTitles.sort((a,b){
              if(personalityType!.contains(a)&&!personalityType!.contains(b)){
                return -1;
              }
              else if((personalityType!.contains(a)&&personalityType!.contains(b) )|| (!personalityType!.contains(a)&&!personalityType!.contains(b) )){
                return 0;
              }
              return 1;
            });
          },
          builder: (context,user) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(23,0,23,23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,20,20,20),
                    child: Text(
                      widget.isPreference?'Choose personalities you prefer':'Choose your personality',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: personalityTitles.map((e){
                        return RawChip(
                          label: Text(
                            e,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          selected: personalityType!.contains(e),
                          onSelected: (value){
                            setState(() {
                              if(personalityType!.contains(e)){
                                personalityType!.remove(e);
                              }
                              else{
                                personalityType!.add(e);
                              }
                              enabled=checkStateChange(store.state!);
                            });
                            if(widget.isPreference){
                            }
                            else{
                              store.dispatch(
                                  UpdatePersonalityDetails(personalityType));
                            }
                          },
                          selectedColor: Theme.of(context).colorScheme.primary,
                        );
                      }).toList()
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: !widget.isPreference?SizedBox(
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
              !store.state!.checkMandatoryFields()?SizedBox(
                width: MediaQuery.of(context).size.width*0.97,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: const Text('Prev'),
                      ),
                      InkWell(
                        onTap: submit,
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                          radius: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 22,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ):Padding(
                padding: const EdgeInsets.all(8.0),
                child: GradientButton(
                  enable: enabled,
                  label: 'Update',
                  onTap: submit,
                ),
              ),
            ],
          ),
        ):SizedBox(
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
