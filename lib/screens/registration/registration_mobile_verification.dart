import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:irl/main.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/registration/registration_dob.dart';
import 'package:irl/widgets/gradient_button.dart';
import 'package:irl/widgets/custom_pin_input.dart';


class RegistrationMobileVerification extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final int? token;
  const RegistrationMobileVerification({super.key, required this.verificationId, this.token, required this.phoneNumber});

  @override
  State<RegistrationMobileVerification> createState() => _RegistrationMobileVerificationState();
}

class _RegistrationMobileVerificationState extends State<RegistrationMobileVerification> {
  final TextEditingController pinController = TextEditingController();
  bool isLoading = false;
  bool isRegistered = false;
  void _submit(BuildContext context) async{
    try{
      setState(() {
        isLoading = true;
      });
      FirebaseAuth auth = FirebaseAuth.instance;
      String smsCode = pinController.text;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId, smsCode: smsCode);
      await auth.signInWithCredential(credential);
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('users')
          .doc(auth.currentUser!.uid).get();
      if(doc.exists){
        await auth.signOut();
        setState(() {
          isLoading =false;
          isRegistered=true;
        });
      }
      else if(context.mounted){
        setState(() {
          isLoading =false;
        });
        store.dispatch(UpdatePhoneNumber(auth.currentUser!.phoneNumber!));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context)=> const RegistrationDOB())
        );
      }
    }
    catch(error){
      setState(() {
        isLoading = false;
      });
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Some error occurred!'))
        );
      }
    }
  }

  bool enableButton = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isLoading,
      child: Scaffold(
        appBar: AppBar(
          leading: isLoading?const SizedBox():null,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Verification \n Code",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15,),
                Text(
                  "Enter code sent to ${widget.phoneNumber}",
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40,),
                CustomPinInput(
                  enabled: !isLoading,
                    pinController: pinController,
                  onChanged: (value){
                    if(pinController.text.length==6){
                      setState(() {
                        enableButton=true;
                      });
                    }
                    else{
                      setState(() {
                        enableButton = false;
                      });
                    }
                  },
                ),
                SizedBox(height: !isRegistered?10:0,),
                isRegistered?Text('Phone number is already registered',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Theme.of(context).colorScheme.error
                  ),
                ):const SizedBox(),
                const SizedBox(height: 60,),
              ],
            ),
          ),
        ),
        floatingActionButton: isRegistered?null:Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            !isLoading?GradientButton(
              enable: enableButton,
              label: 'Verify',
              onTap: (){
                _submit(context);
              }
            ):const Center(child: CircularProgressIndicator(),),
            const SizedBox(height: 10,),
            Text(
              "Didn't receive the code? Resend SMS in 30 seconds",
              softWrap: true,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}