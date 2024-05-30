import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:irl/main.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/profile/career_details.dart';
import 'package:irl/screens/profile/lifestyle_details.dart';
import 'package:irl/screens/profile/personal_details.dart';
import 'package:irl/screens/profile/personality_details.dart';
import 'package:irl/screens/profile/preference_details.dart';

class ProfileCategories extends StatefulWidget {
  const ProfileCategories({super.key});

  @override
  State<ProfileCategories> createState() => _ProfileCategoriesState();
}

class _ProfileCategoriesState extends State<ProfileCategories> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(23.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(StoreProvider.of<CustomUser?>(context).state!.fullName!,
                    style: Theme.of(context).textTheme.bodyMedium,),
                ),
                const SizedBox(height: 10,),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: Theme.of(context).colorScheme.onPrimaryContainer
                        ),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                              store.state!.profileImage!,
                              width: MediaQuery.of(context).size.width*0.3,
                              height: MediaQuery.of(context).size.width*0.3,
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    Positioned(
                        bottom: 5,
                        right: 5,
                        child: InkWell(
                          onTap: (){},
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                            child: Icon(Icons.edit,color: Theme.of(context).colorScheme.background,
                              size: 20,
                            ),
                          ),
                        )
                    )
                  ],
                ),
                const SizedBox(height: 60,),
                ListTile(
                  onTap: () async{
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const PersonalDetails())
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  leading: const SizedBox(height: 40,),
                  title: Text('Personal Details',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: const Icon(
                    Icons.navigate_next,
                    size: 40,
                  ),
                ),
                ListTile(
                  onTap: () async {
                    await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const CareerDetails())
                    ).then((value){
                      setState(() {});
                    });
                  },
                  leading: const SizedBox(height: 40,),
                  title: Text('Career Details',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: const Icon(
                    Icons.navigate_next,
                    size: 40,
                  ),
                ),
                ListTile(
                  onTap: () async {
                    await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const LifestyleDetails())
                    ).then((value){
                      setState(() {});
                    });
                  },
                  leading: const SizedBox(height: 40,),
                  title: Text('Interest & Lifestyle Details',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: const Icon(
                    Icons.navigate_next,
                    size: 40,
                  ),
                ),
                ListTile(
                  onTap: () async {
                    await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const PersonalityDetails(isPreference: false))
                    ).then((value){
                      setState(() {});
                    });
                  },
                  leading: const SizedBox(height: 40,),
                  title: Text('Personality Details',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: const Icon(
                    Icons.navigate_next,
                    size: 40,
                  ),
                ),
                ListTile(
                  onTap: ()async{
                    await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const PreferenceDetails())
                    ).then((value) {
                      setState(() {

                      });
                    });
                  },
                  leading: const SizedBox(height: 40,),
                  title: Text('Partner Preferences',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: const Icon(
                    Icons.navigate_next,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
