import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:irl/main.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/registration/registration_mobile_verification.dart';
import 'package:irl/widgets/gradient_button.dart';

class RegistrationMobile extends StatefulWidget {

  const RegistrationMobile({super.key});

  @override
  State<RegistrationMobile> createState() => _RegistrationMobileState();
}

class _RegistrationMobileState extends State<RegistrationMobile> {
  final TextEditingController mobileNumberController = TextEditingController();
  String _countryCodeValue='IN';
  String dialCode='91';
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading=false;

  Future<bool> isRegistered(String phoneNumber) async{
    await FirebaseFirestore.instance.collection('users').where('phoneNumber',isEqualTo: phoneNumber).get().then((value){
      CustomUser user = CustomUser.fromJSON(value.docs[0].data());
      return user.hasRegistered();
    });
    return false;
  }

  void sendVerificationCode(String phoneNumber) async{
    setState(() {
      isLoading = true;
    });
    auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential){
          setState(() {
            isLoading = false;
          });
        },
        verificationFailed: (FirebaseAuthException exception){
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(exception.message.toString()),
          ));
          // print('Verification Failed: ${exception.message}');
        },
        codeSent: (String verificationId,int? token) async {
          store.dispatch(UpdatePhoneNumber(phoneNumber));
          setState(() {
            isLoading = false;
          });
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => RegistrationMobileVerification(
                verificationId: verificationId,
                phoneNumber: phoneNumber)
            )
          ).then((value){
            setState(() {
              _countryCodeValue='IN';
              mobileNumberController.clear();
            });
          });
        },
        codeAutoRetrievalTimeout:(String verificationId){
        }
    );
  }


  @override
  void didUpdateWidget(covariant RegistrationMobile oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {
      _countryCodeValue='IN';
      mobileNumberController.clear();
    });
  }

  bool enableButton = false;
  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: !isLoading,
      child: !isLoading?StoreConnector<CustomUser?,CustomUser?>(
        converter: (store) => store.state,
        builder: (context, user) {
          return Scaffold(
            appBar: AppBar(backgroundColor: Theme
                .of(context)
                .scaffoldBackgroundColor,),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "What's your\nmobile number?",
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 60,),
                    IntlPhoneField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      initialCountryCode: _countryCodeValue,
                      onCountryChanged: (value) {
                        setState(() {
                          _countryCodeValue = value.code;
                          dialCode = value.dialCode;
                        });
                      },
                      onChanged: (phoneNumber){
                        try{
                            if (phoneNumber.isValidNumber()) {
                              setState(() {
                                enableButton = true;
                              });
                            } else {
                              setState(() {
                                enableButton = false;
                              });
                            }
                        }catch (e) {
                          setState(() {
                            enableButton = false;
                          });
                        }
                      },
                      controller: mobileNumberController,
                      dropdownIconPosition: IconPosition.trailing,
                      flagsButtonMargin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Mobile Number',
                          labelStyle: Theme
                              .of(context)
                              .textTheme
                              .labelLarge,
                          filled: true,
                          fillColor: Theme
                              .of(context)
                              .colorScheme
                              .tertiary,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30)
                            )
                          ),
                          constraints: const BoxConstraints(maxWidth: 300,maxHeight: 75)
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 40,),
                    Text(
                      "6 digit verification code will be sent to your Mobile Number",
                      softWrap: true,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
            floatingActionButton: GradientButton(
              enable: enableButton,
              label: 'Send Code',
              onTap: () {
                if (_countryCodeValue == 'IN') {
                  dialCode = '91';
                }
                String phoneNumber = '+$dialCode${mobileNumberController
                    .text}';
                sendVerificationCode(phoneNumber);
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation
                .centerFloat,
          );
        }
      ):const Center(child: CircularProgressIndicator(),),
    );
  }
}