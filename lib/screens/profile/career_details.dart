import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:irl/data/user_characteristics.dart';
import 'package:irl/main.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/home.dart';
import 'package:irl/screens/profile/lifestyle_details.dart';
import 'package:irl/widgets/gradient_button.dart';

class CareerDetails extends StatefulWidget {
  const CareerDetails({super.key});

  @override
  State<CareerDetails> createState() => _CareerDetailsState();
}

class _CareerDetailsState extends State<CareerDetails> {

  String? highestEducation;
  String? fieldOfStudy;
  String? occupation;

  void autoPopulate(CustomUser user){
    if(user.occupation!=null) occupation=user.occupation;
    if(user.fieldOfStudy!=null) fieldOfStudy=user.fieldOfStudy;
    if(user.highestEducation!=null) highestEducation=user.highestEducation;
  }

  bool checkStateChange(CustomUser user){
    if(
        (user.highestEducation!=highestEducation) ||
        (user.fieldOfStudy!=fieldOfStudy) ||
        (user.occupation!=occupation)
    ){
      return true;
    }
    return false;
  }

  void submit() async {
    store.dispatch(
        UpdateCareerDetails(
            highestEducation=='Select'?null:highestEducation,
            fieldOfStudy=='Select'?null:fieldOfStudy,
            occupation=='Select'?null:occupation
        )
    );
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .update({
      'highestEducation': highestEducation=='Select'?null:highestEducation,
      'fieldOfStudy': fieldOfStudy=='Select'?null:fieldOfStudy,
      'occupation': occupation=='Select'?null:occupation
    }).then((value) {
      if(!store.state!.checkMandatoryFields()){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const LifestyleDetails())).then((value){
              setState(() {
                autoPopulate(store.state!);
              });
        });
      }
      else{
        Navigator.of(context).pop();
      }
    });
  }

  bool enabled=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('Career Details', style: Theme.of(context).textTheme.bodyLarge,),
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
              const Center(child: Text("2/5")),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  value: 0.4,
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
        },
        builder: (context, user) =>SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(23.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'What is your highest level of education',
                    style: Theme.of(context).textTheme.bodyMedium,
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
                      value: highestEducation??'Select',
                      items: educationLevels.map((String value){
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.toString())
                        );
                      }).toList(),
                      onChanged: (value){
                        setState(() {
                          highestEducation=value=='Select'?null:value;
                          enabled = checkStateChange(store.state!);
                        });
                      }
                  ),
                ),
                const SizedBox(height: 35,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Field of study',
                    style: Theme.of(context).textTheme.bodyMedium,
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
                      value: fieldOfStudy??'Select',
                      items: fields.map((String value){
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.toString())
                        );
                      }).toList(),
                      onChanged: (value){
                        setState(() {
                          fieldOfStudy=value=='Select'?null:value;
                          enabled = checkStateChange(store.state!);
                        });
                      }
                  ),
                ),
                const SizedBox(height: 35,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Occupation',
                    style: Theme.of(context).textTheme.bodyMedium,
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
                      value: occupation??'Select',
                      items: occupations.map((String value){
                        return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.toString())
                        );
                      }).toList(),
                      onChanged: (value){
                        setState(() {
                          occupation=value=='Select'?null:value;
                          enabled = checkStateChange(store.state!);
                        });
                      }
                  ),
                ),
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
