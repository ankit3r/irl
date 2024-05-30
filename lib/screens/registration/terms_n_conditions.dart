import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:irl/main.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/registration/waitlist.dart';
import 'package:irl/widgets/gradient_button.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  bool isSelected = false;
  bool isLoading = false;

  void submit() async {
    try {
      if (isSelected != false) {
        setState(() {
          isLoading = true;
        });
        FirebaseStorage storage = FirebaseStorage.instance;
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        String? uid = FirebaseAuth.instance.currentUser!.uid;

        // Calculate age from dateOfBirth
        DateTime? dateOfBirth = store.state!.dateOfBirth;
        DateTime now = DateTime.now();
        int age = now.year - dateOfBirth!.year;
        if (now.month < dateOfBirth.month ||
            (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
          age--;
        }

        String originalExtension =
            store.state!.profileImagePath!.split('.').last;
        Reference profileStorageReference = storage
            .ref()
            .child('profile_images')
            .child(uid)
            .child('profile.$originalExtension');
        UploadTask profileUploadTask = profileStorageReference
            .putFile(File(store.state!.profileImagePath!));
        String profileImageUrl =
            await (await profileUploadTask).ref.getDownloadURL();
        store.dispatch(UpdateProfileImage(profileImageUrl));
        store.dispatch(UpdateUID(uid: uid));
        await firestore.collection('users').doc(uid).set({
          'uid': uid,
          'fullName': store.state!.fullName,
          'phoneNumber': store.state!.phoneNumber,
          'gender': store.state!.gender,
          'currentAddressCity': store.state!.currentAddressCity,
          'currentAddressState': store.state!.currentAddressState,
          'currentAddressCountry': store.state!.currentAddressCountry,
          'dateOfBirth': store.state!.dateOfBirth.toString(),
          'age': age, // Storing age in Firestore
          'profileImage': profileImageUrl,
        }).then((value) {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const WaitList()));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Some error occurred!')));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isLoading,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      Color(0xFFDB7E80),
                      Color(0xFF8147A7),
                      Color(0xFF3008D9),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )),
                ),
                title: Text(
                  'Terms and Conditions',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.surface,
                              width: 1.5,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: SingleChildScrollView(
                            child: Text(
                              text,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ),
                    )),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                            checkColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            tristate: false,
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                isSelected = value == null || value == false
                                    ? false
                                    : true;
                              });
                            }),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              child: Text(
                                'Hello, kindly review and accept our terms and conditions before proceeding with your account creation',
                                softWrap: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GradientButton(
                      enable: isSelected,
                      onTap: submit,
                      label: 'Accept',
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

String text = """
Welcome to GelO. By using the App, you agree to be bound by the following terms and conditions. Please read them carefully.

User Eligibility: You must be at least 18 years old to use this App. You are responsible for maintaining the confidentiality of your account information.

Prohibited Activities: Users must not engage in any illegal, harmful, or abusive activities.Harassment or hate speech is strictly prohibited.

Privacy Policy: Your use of the App is also governed by our Privacy Policy. Please review it to understand how we collect, use, and protect your information.

Content Posting: Users are solely responsible for the content they post on the App. Nudity, explicit content, or offensive material is not allowed.

Interaction with Other Users: Be respectful and courteous when interacting with other users. Report any inappropriate behavior to our moderation team.

Intellectual Property: You retain ownership of the content you post, but you grant the App a license to use it. Respect the intellectual property rights of others.

Termination: We reserve the right to terminate or suspend accounts for violations of these terms and conditions. You can terminate your account at any time.

Changes to Terms: We may update these terms and conditions. Your continued use of the App constitutes acceptance of the updated terms.

Disclaimer of Warranty: The App is provided "as is," and we make no warranties regarding its functionality or availability.

Limitation of Liability: We are not liable for any damages resulting from the use or inability to use the App.

Governing Law: These terms are governed by the laws of [Your Jurisdiction]. Please contact us at [Your Contact Information] if you have any questions or concerns about these terms and conditions.
By using the App, you agree to abide by these terms and conditions. If you do not agree with any of these terms, please do not use the App.
""";
