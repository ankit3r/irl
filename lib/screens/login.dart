import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:irl/screens/login_verification.dart';
import 'package:irl/screens/registration/registration_name.dart';
import 'package:irl/widgets/custom_wave_appbar.dart';
import 'package:irl/widgets/gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mobileNumberController = TextEditingController();
  String countryCodeValue = 'IN';
  String dialCode = '91';
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool _focused = false;
  FocusNode focusNode = FocusNode();

  void sendVerificationCode(String phoneNumber) async {
    setState(() {
      isLoading = true;
    });
    auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
          setState(() {
            isLoading = false;
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          setState(() {
            isLoading = false;
          });
          SnackBar(
            content: Text(exception.message.toString()),
          );
          // print('Verification Failed: ${exception.message}');
        },
        codeSent: (String verificationId, int? token) async {
          setState(() {
            isLoading = false;
          });
          await Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (ctx) => LoginVerification(
                      verificationId: verificationId,
                      phoneNumber: phoneNumber)))
              .then((value) {
            setState(() {
              countryCodeValue = 'IN';
            });
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  void _handleFocusChange() {
    if (focusNode.hasFocus != _focused) {
      setState(() {
        _focused = focusNode.hasFocus;
      });
    }
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    setState(() {
      countryCodeValue = 'IN';
      mobileNumberController.clear();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(_handleFocusChange);
  }

  bool enableButton = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isLoading,
      child: !isLoading
          ? Scaffold(
              appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(MediaQuery.of(context).size.height * 0.33),
                child: const CustomWaveAppBar(
                  title: 'Login with your registered\nmobile no.',
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.longestSide * 0.02,
                    ),
                    IntlPhoneField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      controller: mobileNumberController,
                      onSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      onTap: () {
                        // FocusScope.of(context).unfocus();
                      },
                      onChanged: (phoneNumber) {
                        try {
                          if (phoneNumber.isValidNumber()) {
                            setState(() {
                              enableButton = true;
                            });
                            FocusScope.of(context).unfocus();
                          } else {
                            setState(() {
                              enableButton = false;
                            });
                          }
                        } catch (e) {
                          setState(() {
                            enableButton = false;
                          });
                        }
                      },
                      initialCountryCode: countryCodeValue,
                      onCountryChanged: (value) {
                        setState(() {
                          countryCodeValue = value.code;
                          dialCode = value.dialCode;
                        });
                      },
                      dropdownIconPosition: IconPosition.trailing,
                      flagsButtonMargin:
                          const EdgeInsets.fromLTRB(30, 6, 10, 0),
                      flagsButtonPadding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        alignLabelWithHint: true,
                        labelText: 'Mobile Number',
                        labelStyle: Theme.of(context).textTheme.labelLarge,
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        constraints:
                            const BoxConstraints(maxWidth: 300, maxHeight: 75),
                      ),
                    ),
                    Column(
                      children: [
                        GradientButton(
                          enable: enableButton,
                          height: 50,
                          label: 'Login',
                          onTap: () async {
                            if (countryCodeValue == 'IN') {
                              dialCode = '91';
                            }
                            String phoneNumber =
                                '+$dialCode${mobileNumberController.text}';
                            sendVerificationCode(phoneNumber);
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Do you have an account ?",
                              softWrap: true,
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistrationName(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign Up',
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ))
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
