import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:irl/data/user_characteristics.dart';
import 'package:irl/main.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/home.dart';
import 'package:irl/screens/profile/interest_details.dart';
import 'package:irl/screens/profile/personality_details.dart';
import 'package:irl/widgets/gradient_button.dart';

class LifestyleDetails extends StatefulWidget {
  const LifestyleDetails({super.key});

  @override
  State<LifestyleDetails> createState() => _LifestyleDetailsState();
}

class _LifestyleDetailsState extends State<LifestyleDetails> {

  String? smoke;
  String? drink;
  List<String>? relationshipChoice = [];
  String? foodLifestyle;
  List<String> interests =[];

  void autoPopulate(CustomUser user){
    if(user.smoke!=null) smoke=user.smoke!.toString();
    if(user.drink!=null) drink=user.drink!.toString();
    if(user.relationshipType!=null) relationshipChoice=List.from(user.relationshipType!);
    if(user.foodLifestyle!=null) foodLifestyle=user.foodLifestyle!;
    if(user.interests!=null) interests=List.from(user.interests!);
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
    if(
        user.smoke != smoke ||
        user.drink != drink ||
        !listEquals(user.relationshipType, relationshipChoice) ||
        user.foodLifestyle!=foodLifestyle ||
        !listEquals(user.interests, interests)
    ){
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      autoPopulate(store.state!);
    });
  }
  void submit() async {
    try{
      if (interests.isNotEmpty && relationshipChoice!.isNotEmpty) {
        store.dispatch(UpdateLifestyleDetails(
            smoke != 'Select' ? smoke : null,
            drink != 'Select' ? drink : null,
            relationshipChoice,
            foodLifestyle,
            interests));
        FirebaseAuth auth = FirebaseAuth.instance;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser!.uid)
            .update({
          'smoke': smoke != 'Select' ? smoke : null,
          'drink': drink != 'Select' ? drink : null,
          'relationshipType': relationshipChoice,
          'foodLifestyle': foodLifestyle!='Select'?foodLifestyle:null,
          'interests': interests
        }).then((value){
          if(store.state!.checkMandatoryFields()){
            Navigator.of(context).pop();
          }
          else{
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PersonalityDetails(isPreference: false))
            ).then((value) {
              setState(() {
                autoPopulate(store.state!);
              });
            });
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Fill mandatory fields')));
      }
    }catch(e){
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())));
      }
    }
  }

  bool enabled=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('Interests & Lifestyle', style: Theme.of(context).textTheme.bodyLarge,),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: !store.state!.checkMandatoryFields()?InkWell(
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
          ):IconButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded)
          ),
        ),
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Center(child: Text("3/5")),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    value: 0.6,
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
          interestTitles.sort((a,b){
            if(interests.contains(a)&&!interests.contains(b)){
              return -1;
            }
            else if((interests.contains(a)&&interests.contains(b) )|| (!interests.contains(a)&&!interests.contains(b) )){
              return 0;
            }
            return 1;
          });
        },
          builder: (context, user) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(23.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'What are your interests?*',
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Wrap(
                    spacing: 5,
                    children: interestTitles.take(10).map((e){
                      return RawChip(
                        avatar: !interests.contains(e)?const Icon(
                          Icons.add,
                          color: Color(0xFFCFD1D1),
                        ):null,
                        deleteIcon: const Icon(Icons.close_rounded),
                        label: Text(
                          e,
                          style: interests.contains(e)?Theme.of(context).textTheme.bodySmall:
                          Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: const Color(0xFFCFD1D1)
                          )
                          ,
                        ),
                        selectedColor: Theme.of(context).colorScheme.primary,
                        selected: interests.contains(e),
                        onSelected: (value){
                          setState(() {
                            if(interests.contains(e)){
                              interests.remove(e);
                            }
                            else {
                              interests.add(e);
                            }
                            enabled=checkStateChange(store.state!);
                          });
                        },
                      );
                    }).toList()
                  )
                ),
                RawChip(
                  label: Text(
                      'See More',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onPressed: () async {
                    store.dispatch(UpdateInterestDetails(interests));
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const InterestDetails(isPreferences: false))
                    ).then((value){
                      setState(() {
                        autoPopulate(user.state!);
                      });
                    });
                  },
                ),
                const SizedBox(height: 20,),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                      'Do you smoke?',
                      style: Theme.of(context).textTheme.bodyMedium
                  ),
                ),
                Wrap(
                  spacing: 20,
                  children: [
                    RawChip(
                      showCheckmark: false,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      ),
                      label: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Yes ',
                            style: smoke=='Yes'?Theme.of(context).textTheme.labelMedium!.copyWith(
                                color: Colors.white
                            )
                                :Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      selected: smoke=='Yes',
                      onSelected: (value){
                        if(value){
                          setState(() {
                            smoke='Yes';
                          });
                        }
                        else{
                          setState(() {
                            smoke=null;
                          });
                        }
                        enabled=checkStateChange(store.state!);
                      },
                    ),
                    RawChip(
                      showCheckmark: false,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                      ),
                      label: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          ' No ',
                          style: smoke=='No'?Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: Colors.white
                          )
                              :Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      selected: smoke=='No',
                      onSelected: (value){
                        if(value){
                          setState(() {
                            smoke='No';
                          });
                        }
                        else{
                          setState(() {
                            smoke=null;
                          });
                        }
                        enabled=checkStateChange(store.state!);
                      },
                    ),
                    RawChip(
                      showCheckmark: false,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                      ),
                      label: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Occasionally',
                          style: smoke=='Occasionally'?Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: Colors.white
                          )
                              :Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      selected: smoke=='Occasionally',
                      onSelected: (value){
                        if(value){
                          setState(() {
                            smoke='Occasionally';
                          });
                        }
                        else{
                          setState(() {
                            smoke=null;
                          });
                        }
                        enabled=checkStateChange(store.state!);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                      'Do you drink?',
                      style: Theme.of(context).textTheme.bodyMedium
                  ),
                ),
                Wrap(
                  spacing: 20,
                  children: [
                    RawChip(
                      showCheckmark: false,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                      ),
                      label: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Yes ',
                          style: drink=='Yes'?Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: Colors.white
                          )
                              :Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      selected: drink=='Yes',
                      onSelected: (value){
                        if(value){
                          setState(() {
                            drink='Yes';
                          });
                        }
                        else{
                          setState(() {
                            drink=null;
                          });
                        }
                        enabled=checkStateChange(store.state!);
                      },
                    ),
                    RawChip(
                      showCheckmark: false,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                      ),
                      label: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          ' No ',
                          style: drink=='No'?Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: Colors.white
                          )
                              :Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      selected: drink=='No',
                      onSelected: (value){
                        if(value){
                          setState(() {
                            drink='No';
                          });
                        }
                        else{
                          setState(() {
                            drink=null;
                          });
                        }
                        enabled=checkStateChange(store.state!);
                      },
                    ),
                    RawChip(
                      showCheckmark: false,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                      ),
                      label: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Occasionally',
                          style: drink=='Occasionally'?Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Colors.white
                          )
                              :Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      selected: drink=='Occasionally',
                      onSelected: (value){
                        if(value){
                          setState(() {
                            drink='Occasionally';
                          });
                        }
                        else{
                          setState(() {
                            drink=null;
                          });
                        }
                        enabled=checkStateChange(store.state!);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                      'What are you looking for?*',
                      style: Theme.of(context).textTheme.bodyMedium
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  constraints: const BoxConstraints(maxHeight: 45),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButton<String>(
                      dropdownColor: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      menuMaxHeight: MediaQuery.of(context).size.height*0.5,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      isExpanded: true,
                      underline: const SizedBox(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      value: 'Select',
                      items: relationshipChoiceTitles.map((String value){
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            )
                        );
                      }).toList(),
                      onChanged: (value){
                        setState(() {
                          if(value!=null && value!='Select' && !relationshipChoice!.contains(value)){
                            relationshipChoice!.add(value);
                          }
                          enabled=checkStateChange(store.state!);
                        });
                      }
                  ),
                ),
                relationshipChoice!.isNotEmpty?Padding(
                  padding: const EdgeInsets.fromLTRB(5,0,5,5),
                  child: Wrap(
                      spacing: 10,
                      children: relationshipChoice!.map((e){
                        return RawChip(
                          showCheckmark: false,
                          avatar: relationshipChoice!.contains(e)?const Icon(Icons.clear,
                            color: Colors.white,
                          ):null,
                          deleteIcon: relationshipChoice!.contains(e)?const Icon(Icons.clear):null,
                          onPressed: (){
                            setState(() {
                              relationshipChoice!.remove(e);
                              enabled=checkStateChange(store.state!);
                            });
                          },
                          tapEnabled: true,
                          selected: true,
                          label: Text(
                            e,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          selectedColor: Theme.of(context).colorScheme.primary,
                        );
                      }).toList()
                  ),
                ):const SizedBox(),
                const SizedBox(height: 20,),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                      'Food Lifestyle',
                      style: Theme.of(context).textTheme.bodyMedium
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  constraints: const BoxConstraints(maxHeight: 45),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButton<String>(
                      dropdownColor: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      menuMaxHeight: MediaQuery.of(context).size.height*0.5,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      isExpanded: true,
                      underline: const SizedBox(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      value: foodLifestyle??'Select',
                      items: foodLifestyleTitles.map((String value){
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            )
                        );
                      }).toList(),
                      onChanged: (value){
                        setState(() {
                          foodLifestyle=value=='Select'?null:value;
                          enabled=checkStateChange(store.state!);
                        });
                      }
                  ),
                ),
                const SizedBox(height: 70,)
              ],
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
        )
    );
  }
}