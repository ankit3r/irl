// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:irl/screens/registration/registration_picture.dart';
// import 'package:irl/screens/registration/selfie_verification/comparison.dart';
// import 'package:irl/widgets/gradient_button.dart';
// import 'dart:io';


// // class ClickPhoto extends StatefulWidget {
// //   const ClickPhoto({super.key});

// //   @override
// //   State<ClickPhoto> createState() => _ClickPhotoState();
// // }

// // class _ClickPhotoState extends State<ClickPhoto> {
// //   File? selfie;
// //   final picker = ImagePicker();

// //   Future<void> _pickImage(ImageSource source) async {
// //     final pickedFile = await picker.pickImage(source: source);

// //     if (pickedFile != null) {
// //       setState(() {
// //         if (source == ImageSource.camera) {
// //           selfie = File(pickedFile.path);
// //         } else {}
// //       });
// //     }
// //   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'Selfie Verification',
//           style: Theme.of(context).textTheme.bodyLarge,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(23.0),
//           child: Column(
//             children: [
//               Text(
//                 '1. Place your head in the enclosed area.'
//                 '\n2. Rotate your head so that your nose is within the smaller circle'
//                 '\n3. Hold steady',
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//               const SizedBox(
//                 height: 80,
//               ),
//               InkWell(
//                 borderRadius: BorderRadius.circular(60),
//                 onTap: () => _pickImage(ImageSource.camera),
//                 child: Container(
//                   height: MediaQuery.of(context).size.width * 0.75,
//                   width: MediaQuery.of(context).size.width * 0.75,
//                   decoration: BoxDecoration(
//                       border: Border.all(
//                           color:
//                               Theme.of(context).colorScheme.onPrimaryContainer,
//                           width: 1,
//                           strokeAlign: BorderSide.strokeAlignOutside,
//                           style: BorderStyle.solid),
//                       borderRadius: BorderRadius.circular(60)),
//                   child: selfie == null
//                       ? CustomPaint(
//                           painter: DashedRectPainter(),
//                           child: Icon(
//                             Icons.camera_alt_rounded,
//                             size: 40,
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .onPrimaryContainer,
//                           ),
//                         )
//                       : ClipRRect(
//                           borderRadius: BorderRadius.circular(60),
//                           child: Image.file(
//                             selfie!,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: GradientButton(
//         enable: selfie== null ? false:true ,
//         onTap: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => SelfieComparison(
//                 selfie: selfie!,
//               ),
//             ),
//           );
//         },
//         label: 'Next',
//       ),
//     );
//   }
// }
