import 'package:flutter/material.dart';
import 'package:irl/screens/index.dart';
import 'package:irl/widgets/gradient_button.dart';

class ProfileCompletion extends StatelessWidget {
  const ProfileCompletion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.15,),
              Image.asset(
                  'assets/images/logo.png',
                  width: 70,
                  height: 70
              ),
              const SizedBox(height: 35,),
              Text('All Set! Your profile has been successfully completed',
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
                        const Icon(Icons.check_box_outlined,size: 30,),
                        const SizedBox(width: 30,),
                        Text('Personal Details',style: Theme.of(context).textTheme.bodyMedium,)
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width*0.12,),
                        const Icon(Icons.check_box_outlined,size: 30,),
                        const SizedBox(width: 30,),
                        Text('Career Details',style: Theme.of(context).textTheme.bodyMedium,)
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width*0.12,),
                        const Icon(Icons.check_box_outlined,size: 30,),
                        const SizedBox(width: 30,),
                        Text('Interests & Lifestyle Details',style: Theme.of(context).textTheme.bodyMedium,)
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width*0.12,),
                        const Icon(Icons.check_box_outlined,size: 30,),
                        const SizedBox(width: 30,),
                        Text('Personality Details',style: Theme.of(context).textTheme.bodyMedium,)
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width*0.12,),
                        const Icon(Icons.check_box_outlined,size: 30,),
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
        label: 'Done',
        onTap: (){
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context)=>const Wrapper()),
                  (route) => route.settings.name=='/');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
