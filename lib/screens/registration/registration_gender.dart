import 'package:flutter/material.dart';
import 'package:irl/data/user_characteristics.dart';
import 'package:irl/main.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/registration/registration_picture.dart';
import 'package:irl/widgets/gradient_button.dart';

class RegistrationGender extends StatefulWidget {
  const RegistrationGender({super.key});

  @override
  State<RegistrationGender> createState() => _RegistrationGenderState();
}

class _RegistrationGenderState extends State<RegistrationGender> {

  bool isLoading = false;
  String gender='Select';

  @override
  Widget build(BuildContext context) {
    return isLoading?const Center(child: CircularProgressIndicator(),):Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).scaffoldBackgroundColor,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "What do you identify as?",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                constraints: const BoxConstraints(maxWidth: 300,maxHeight: 50),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,0,0),
                  child: DropdownButton<String>(
                    dropdownColor: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    menuMaxHeight: MediaQuery.of(context).size.height*0.5,
                    isExpanded: true,
                    style: Theme.of(context).textTheme.bodyMedium,
                    underline: const SizedBox(),
                    value: gender,
                    items: genderTitles.map((String value){
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: Theme.of(context).textTheme.bodyMedium,)
                      );
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        gender=value?? 'Select';
                      });
                    }
                  ),
                ),
              ),
              const SizedBox(height: 60,),
            ],
          ),
        ),
      ),
      floatingActionButton: GradientButton(
        enable: gender!='Select',
        label: 'Next',
        onTap: () async {
          try{
              setState(() {
                isLoading=true;
              });
              store.dispatch(UpdateGender(gender));
              setState(() {
                isLoading=false;
              });
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>const RegistrationPicture())
              );
          }catch(e){
            setState(() {
              isLoading=false;
            });
            if(context.mounted){
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(e.toString())));
            }
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
