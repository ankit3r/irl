import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/happenings/happenings_index.dart';
import 'package:irl/screens/match/match_index.dart';
import 'package:irl/screens/people/people_index.dart';
import 'package:irl/screens/profile/profile_index.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid){
      checkForInAppUpdate();
    }
  }

  int _selectedTab=0;
  Widget getHome(int index, BuildContext context){
    List<Widget> bodyWidgets= [
      const MatchIndex(),
      const IRLMixer(),
      const PeopleIndex(),
      const ProfileIndex(),
    ];
    return bodyWidgets.elementAt(index);
  }


  void showMandatoryBottomSheet(){
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      builder: (context){
        return PopScope(
          canPop: false,
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('COMPLETE PROFILE',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Complete your profile to get matches'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(23.0),
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          _selectedTab=3;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: Colors.white
                          ),
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('Go To Profile',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.black
                                )
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return StoreBuilder<CustomUser?>(
      onInit: (store){
        if(store.state!.checkMandatoryFields()==false){
            _selectedTab=3;
        }
        else{
          _selectedTab=0;
        }
      },
      onDidChange: (previousStore, newStore){
        if(newStore.state!.checkMandatoryFields()==false){
            _selectedTab=3;
        }
        else{
          _selectedTab=0;
        }
      },
      builder: (context, store) => Scaffold(
        body: Center(child: getHome(_selectedTab, context)),
        bottomNavigationBar: SizedBox(
          height:58,
          child: Column(
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
              BottomNavigationBar(
                selectedIconTheme: IconThemeData(
                  size: 20,
                  color: Theme.of(context).colorScheme.onPrimaryContainer
                ),
                unselectedIconTheme: IconThemeData(
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface
                ),
                currentIndex: _selectedTab,
                onTap: (index){
                  setState(() {
                    _selectedTab=index;
                  });
                  if(store.state!.checkMandatoryFields()==false && _selectedTab!=3){
                    showMandatoryBottomSheet();
                  }
                },

                showSelectedLabels: false,
                items: const [
                  BottomNavigationBarItem(
                    label: 'Matches',
                    icon: Icon(Icons.extension_outlined,),
                  ),
                  BottomNavigationBarItem(
                    label: 'Happenings',
                    icon: Icon(Icons.calendar_month_rounded),
                  ),
                  BottomNavigationBarItem(
                    label: 'People',
                    icon: Icon(Icons.people_alt_outlined),
                  ),
                  BottomNavigationBarItem(
                    label: 'Profile',
                    icon: Icon(Icons.account_circle_rounded),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //In App Update
  Future<void> checkForInAppUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      if (info.immediateUpdateAllowed) {
        InAppUpdate.performImmediateUpdate();
      } else if (info.flexibleUpdateAllowed) {
        InAppUpdate.startFlexibleUpdate();
      }else{
        debugPrint("update>>> ${info.toString()}");
      }
    });
  }
}