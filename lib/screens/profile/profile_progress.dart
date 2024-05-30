import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/profile/lifestyle_details.dart';
import 'package:irl/screens/profile/personal_details.dart';
import 'package:irl/screens/profile/personality_details.dart';
import 'package:irl/screens/profile/preference_details.dart';
import 'package:irl/widgets/gradient_button.dart';

class ProfileProgress extends StatefulWidget {
  const ProfileProgress({super.key});
  @override
  State<ProfileProgress> createState() => _ProfileProgressState();
}

class _ProfileProgressState extends State<ProfileProgress> {
  bool profileComplete=true;
  bool careerComplete=true;
  bool interestsComplete=true;
  bool personalityComplete=true;
  bool preferenceComplete=true;


  void rebuild(CustomUser user){
    if(user.bio==null || user.heightFeet==null || user.heightInch==null){
      setState(() {
        profileComplete=false;
        careerComplete=false;
      });
    }
    else{
      setState(() {
        profileComplete=true;
        careerComplete=true;
      });
    }
    if(user.interests==null || user.interests!.isEmpty || user.relationshipType==null){
      setState(() {
        interestsComplete=false;
      });
    }
    else{
      setState(() {
        interestsComplete=true;
      });
    }
    if(user.personalityType==null || user.personalityType!.isEmpty){
      setState(() {
        personalityComplete=false;
      });
    }
    else{
      setState(() {
        personalityComplete=true;
      });
    }
    if(user.genderPreference==null || user.minAgePreference==null || user.maxAgePreference==null){
      setState(() {
        preferenceComplete=false;
      });
    }
    else{
      setState(() {
        preferenceComplete=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<CustomUser?>(
      onInit: (store){
        CustomUser user=store.state!;
        if(user.bio==null || user.heightFeet==null || user.heightInch==null){
          profileComplete=false;
          careerComplete=false;
        }
        if(user.interests==null || user.interests!.isEmpty || user.relationshipType==null){
          interestsComplete=false;
        }
        if(user.personalityType==null || user.personalityType!.isEmpty){
          personalityComplete=false;
        }
        if(user.genderPreference==null || user.minAgePreference==null || user.maxAgePreference==null){
          preferenceComplete=false;
        }
      },
        onDidChange: (prevStore,newStore){

        },
        rebuildOnChange: true,
        builder: (context, store) => Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                  Image.asset(
                      'assets/images/logo.png',
                      width: 70,
                      height: 70
                  ),
                  const SizedBox(height: 35,),
                  Text('Your profile is yet to be completed',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 35,),
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
                  const SizedBox(height: 35,),
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width*0.12,),
                            Icon(profileComplete?Icons.check_box_outlined:Icons.check_box_outline_blank,size: 30,),
                            const SizedBox(width: 30,),
                            Text('Personal Details',style: Theme.of(context).textTheme.bodyMedium,)
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width*0.12,),
                            Icon(careerComplete?Icons.check_box_outlined:Icons.check_box_outline_blank,size: 30,),
                            const SizedBox(width: 30,),
                            Text('Career Details',style: Theme.of(context).textTheme.bodyMedium,)
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width*0.12,),
                            Icon(interestsComplete?Icons.check_box_outlined:Icons.check_box_outline_blank,size: 30,),
                            const SizedBox(width: 30,),
                            Text('Interests & Lifestyle Details',style: Theme.of(context).textTheme.bodyMedium,)
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width*0.12,),
                            Icon(personalityComplete?Icons.check_box_outlined:Icons.check_box_outline_blank,size: 30,),
                            const SizedBox(width: 30,),
                            Text('Personality Details',style: Theme.of(context).textTheme.bodyMedium,)
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width*0.12,),
                            Icon(preferenceComplete?Icons.check_box_outlined:Icons.check_box_outline_blank,size: 30,),
                            const SizedBox(width: 30,),
                            Text('Partner Preferences',style: Theme.of(context).textTheme.bodyMedium,)
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: GradientButton(
            label: 'Go To Profile',
            onTap: (){
              CustomUser user = store.state!;
              if(user.bio==null || user.heightFeet==null || user.heightInch==null){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PersonalDetails())
                ).then((value){
                  setState(() {
                    rebuild(store.state!);
                  });
                });
              }
              else if(user.interests==null || user.interests!.isEmpty || user.relationshipType==null){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LifestyleDetails())
                ).then((value){
                  setState(() {
                    rebuild(store.state!);
                  });
                });
              }
              else if(user.personalityType==null || user.personalityType!.isEmpty){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const PersonalityDetails(isPreference: false))
                ).then((value) {
                  setState(() {
                    rebuild(store.state!);
                  });
                });
              }
              else if(user.genderPreference==null || user.minAgePreference==null || user.maxAgePreference==null){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const PreferenceDetails())
                ).then((value){
                  setState(() {
                    rebuild(store.state!);
                  });
                });
              }
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        )
    );
  }
}
