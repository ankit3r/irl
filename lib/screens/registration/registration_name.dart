import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/login.dart';
import 'package:irl/screens/registration/registration_mobile.dart';
import 'package:irl/widgets/custom_text_field.dart';
import 'package:irl/widgets/gradient_button.dart';

class RegistrationName extends StatefulWidget {

  const RegistrationName({super.key});

  @override
  State<RegistrationName> createState() => _RegistrationNameState();
}

class _RegistrationNameState extends State<RegistrationName> {
  final TextEditingController fullNameController = TextEditingController();

  bool enableButton = false;
  void checkAndSignOut() async{
    if(FirebaseAuth.instance.currentUser!=null){
      await FirebaseAuth.instance.signOut();
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  Text(
                    'What do we call you?',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: fullNameController,
                    type : TextInputType.name,
                    maxLength: 25,
                    labelText: 'Full Name',
                    onChanged: (value){
                      String fullName = fullNameController.text.trim();
                      if(fullName.isNotEmpty){
                        setState(() {
                          enableButton = true;
                        });
                      }
                      else{
                        setState(() {
                          enableButton = false;
                        });
                      }
                    },
                    onEditingComplete: (){
                      String firstName = fullNameController.text.trim();
                      if(firstName.isNotEmpty){
                        setState(() {
                          enableButton = true;
                        });
                      }
                      else{
                        setState(() {
                          enableButton = false;
                        });
                      }
                    },
                  ),
                  const SizedBox( height: 30,),
                  Center(
                    child: Text("Only your first name will be shown on your profile.",
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              const SizedBox( height: 20,),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GradientButton(
            enable: enableButton,
            label: 'Next',
            onTap: (){
              createUser(fullName: fullNameController.text);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RegistrationMobile(),
                ),
              );
            },
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Have an account ?",
                softWrap: true,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Log in",
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  )
              )
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}