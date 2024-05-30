import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:irl/main.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/index.dart';
import 'package:irl/screens/registration/registration_social_media.dart';
// import 'package:irl/screens/registration/selfie_verification/click_photo.dart';
import 'package:irl/widgets/gradient_button.dart';

class RegistrationPicture extends StatefulWidget {
  const RegistrationPicture({super.key});

  @override
  State<RegistrationPicture> createState() => _RegistrationPictureState();
}

class _RegistrationPictureState extends State<RegistrationPicture> {
  XFile? image;
  bool isLoading = false;
  Future<void> _onTap(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? xImage = await picker.pickImage(source: ImageSource.gallery);

    if (xImage != null && context.mounted) {
      // Get the file size
      File file = File(xImage.path);
      int fileSizeInBytes = await file.length();
      double fileSizeInKB = fileSizeInBytes / 1024; 
      double fileSizeInMB = fileSizeInKB / 1024;

      // Check if file size exceeds 2 MB
      if (fileSizeInMB > 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select an image smaller than 2 MB.')),
        );
      } else {
        setState(() {
          image = xImage;
        });
      }
    }
  }

  void submit() async {
    try {
      if (image != null) {
        setState(() {
          isLoading = true;
        });
        FirebaseStorage storage = FirebaseStorage.instance;
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        String? uid = FirebaseAuth.instance.currentUser!.uid;
        String originalExtension = image!.path.split('.').last;
        Reference profileStorageReference = storage
            .ref()
            .child('profile_images')
            .child(uid)
            .child('profile.$originalExtension');
        UploadTask profileUploadTask =
            profileStorageReference.putFile(File(image!.path));
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
          'profileImage': profileImageUrl,
        }).then((value) {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Wrapper()),
              (route) => route.settings.name == '/');
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Select your profile picture!')));
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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Upload the best\nphoto of yourself",
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    image == null
                        ? InkWell(
                            onTap: () {
                              _onTap(context);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.75,
                              width: MediaQuery.of(context).size.width * 0.75,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      width: 1,
                                      strokeAlign:
                                          BorderSide.strokeAlignOutside,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(20)),
                              child: CustomPaint(
                                  painter: DashedRectPainter(),
                                  child: const Icon(Icons.add)),
                            ),
                          )
                        : Stack(
                            children: [
                              Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.75,
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        width: 1,
                                        strokeAlign:
                                            BorderSide.strokeAlignOutside,
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      File(image!.path),
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.75,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                              Positioned(
                                  top: 5,
                                  right: 5,
                                  child: CircleAvatar(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(0.7),
                                    child: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          image = null;
                                        });
                                      },
                                    ),
                                  )),
                            ],
                          ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Note: Ensure you have added a proper photo of yourself.\nThis is a crucial part of the verification process.",
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: GradientButton(
              enable: image != null,
              label: 'Submit',
              onTap: () {
                setState(() {
                  isLoading = true;
                });
                store.dispatch(UpdateProfileImagePath(image!.path));
                setState(() {
                  isLoading = false;
                });
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RegistrationSocialMedia()));
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}

class DashedRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint() // Color of the dashed line
      ..strokeWidth = 2 // Width of the dashed line
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    const double dashWidth = 5; // Width of each dash
    const double dashSpace = 5; // Space between dashes

    double currentX = 0;
    while (currentX < size.width) {
      path.moveTo(currentX, 0);
      path.lineTo(currentX + dashWidth, 0);
      path.moveTo(currentX, size.height);
      path.lineTo(currentX + dashWidth, size.height);
      currentX += dashWidth + dashSpace;
    }

    double currentY = 0;
    while (currentY < size.height) {
      path.moveTo(0, currentY);
      path.lineTo(0, currentY + dashWidth);
      path.moveTo(size.width, currentY);
      path.lineTo(size.width, currentY + dashWidth);
      currentY += dashWidth + dashSpace;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
