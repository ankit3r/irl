import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:irl/main.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/index.dart';
import 'package:irl/screens/profile/personal_details.dart';
import 'package:irl/screens/profile/profile_categories.dart';
import 'package:irl/screens/profile/profile_progress.dart';
import 'package:irl/screens/settings/settings_index.dart';
import 'package:irl/screens/subscription/subscription_index.dart';

class ProfileIndex extends StatefulWidget {
  const ProfileIndex({super.key});

  @override
  State<ProfileIndex> createState() => _ProfileIndexState();
}

class _ProfileIndexState extends State<ProfileIndex> {
  bool mandatoryFields = false;
  File? _image;
  final picker = ImagePicker();
  bool _isUploading = false;
  String? _downloadURL;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isUploading = true;
    });

    FirebaseStorage storage = FirebaseStorage.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String? uid = FirebaseAuth.instance.currentUser!.uid;
    String originalExtension = _image!.path.split('.').last;
    Reference profileStorageReference = storage
        .ref()
        .child('profile_images')
        .child(uid)
        .child('profile.$originalExtension');
    UploadTask profileUploadTask =
        profileStorageReference.putFile(File(_image!.path));
    String profileImageUrl =
        await (await profileUploadTask).ref.getDownloadURL();
    await store.dispatch(UpdateProfileImage(profileImageUrl));
    setState(() {
      _isUploading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mandatoryFields = store.state!.checkMandatoryFields();
  }

  String fullName = store.state!.fullName!;
  void onViewProfile() {
    Navigator.of(context)
        .push(
            MaterialPageRoute(builder: (context) => const ProfileCategories()))
        .then((value) {
      setState(() {
        fullName = store.state!.fullName!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(23, 23, 23, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    StoreProvider.of<CustomUser?>(context).state!.fullName!,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Stack(
                  children: [
                    _isUploading
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.4,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  StoreProvider.of<CustomUser?>(context)
                                      .state!
                                      .profileImage!,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.width * 0.4,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.4,
                                    );
                                  },
                                )),
                          ),
                    Positioned(
                        bottom: 5,
                        right: 5,
                        child: InkWell(
                          onTap: () {
                            _pickImage();
                          },
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer
                                .withOpacity(0.8),
                            child: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFDB7E80),
                      Color(0xFF8147A7),
                      Color(0xFF3008D9),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  onTap: () {
                    if (mandatoryFields) {
                      onViewProfile();
                    } else if (store.state!.bio == null ||
                        store.state!.heightFeet == null ||
                        store.state!.heightInch == null) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PersonalDetails()));
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ProfileProgress()));
                    }
                  },
                  title: Text(
                    mandatoryFields
                        ? 'View Profile'
                        : 'Complete your profile for better matches',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: const Icon(Icons.keyboard_double_arrow_right),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              // const SizedBox(height: 20,),
              // Text(
              //   'Media',
              //   style: Theme.of(context).textTheme.bodyMedium,
              // ),
              // const SizedBox(height: 20,),
              // InkWell(
              //   onTap: (){},
              //   borderRadius: BorderRadius.circular(20),
              //   child: Container(
              //     height: 100,
              //     width: 100,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(20),
              //       border: Border.all(
              //         color: Theme.of(context).colorScheme.surface,
              //         width: 2
              //       )
              //     ),
              //     child: const Center(
              //       child: Icon(Icons.add),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              Divider(
                color: Theme.of(context).colorScheme.surface,
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingsIndex()));
                },
                title: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.surface,
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SubscriptionIndex()));
                },
                title: Text(
                  'Plans',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.surface,
              ),
              ListTile(
                onTap: () {},
                title: Text(
                  'Complaint Forum',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.surface,
              ),
              ListTile(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          title: Center(
                              child: Text(
                            "Confirm",
                            style: Theme.of(context).textTheme.bodyLarge,
                          )),
                          content: SizedBox(
                            height: 130,
                            width: 500,
                            child: Column(
                              children: [
                                const Text("Are you sure you want to logout?"),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          width: 100,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Cancel',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        store.dispatch(ClearUserAction());
                                        FirebaseAuth.instance.signOut();
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Wrapper()),
                                                (route) => false);
                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          width: 100,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border:
                                                Border.all(color: Colors.white),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Logout',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                title: Text(
                  'Logout',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
