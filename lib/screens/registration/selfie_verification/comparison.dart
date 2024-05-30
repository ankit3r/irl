import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:irl/main.dart';
import 'package:irl/screens/registration/registration_social_media.dart';
import 'package:irl/widgets/gradient_button.dart';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class SelfieComparison extends StatefulWidget {
  const SelfieComparison({super.key, required this.selfie});
  final File selfie;

  @override
  State<SelfieComparison> createState() => _SelfieComparisonState();
}

class _SelfieComparisonState extends State<SelfieComparison> {
  late File image1;
  // late File image2;
  bool isComparing = false;

  Future<File> _resizeImage(File imageFile) async {
    try {
      final Uint8List? compressedBytes =
          await FlutterImageCompress.compressWithFile(
        imageFile.path,
        minHeight: 300,
        minWidth: 300,
        quality: 100,
      );

      if (compressedBytes != null) {
        final File resizedImage = await _writeCompressedFile(compressedBytes);
        final int fileSizeInBytes = await resizedImage.length();
        final double fileSizeInKB = fileSizeInBytes / 1024;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$fileSizeInKB'),
            duration: const Duration(seconds: 3),
          ),
        );
        setState(() {
          imageFile = resizedImage;
        });
        return imageFile;
      } else {}
    } catch (e) {
      print(e);
    }
    return imageFile;
  }

  Future<File> _writeCompressedFile(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final tempFile = File('$tempPath/temp_image.jpg');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  @override
  void initState() {
    _resizeImages();
    super.initState();
  }

  Future<void> _resizeImages() async {
    File resizedSelfie = await _resizeImage(widget.selfie);
    // File resizedProfileImage =
    //     await _resizeImage(File(store.state!.profileImagePath!));

    setState(() {
      image1 = resizedSelfie;
      // image2 = resizedProfileImage;
      print(image1);
      print('uperwali image 1 & nichewali image 2');
      print(store.state!.profileImagePath!);
    });
  }

  Future<void> compareFaces() async {
    // Your Face++ API URL
    setState(() {
      isComparing = true;
    });
    var uri = Uri.parse('https://api-us.faceplusplus.com/facepp/v3/compare');
    // Your API key and secret
    var apiKey = 'z_0O0TRXT9Vysnx9POCX0MZnCtOKtjDi';
    var apiSecret = 'QJce3zM567gt8w_wZbLDR7OCkZskdULM';
    // Create a multipart request
    var request = http.MultipartRequest('POST', uri)
      ..fields['api_key'] = apiKey
      ..fields['api_secret'] = apiSecret
      ..files.add(await http.MultipartFile.fromPath('image_file1', image1.path))
      ..files.add(await http.MultipartFile.fromPath(
          'image_file2', store.state!.profileImagePath!));
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          isComparing = false;
        });
        var responseData = await response.stream.bytesToString();
        var decodedResponse = json.decode(responseData);
        var confidence = decodedResponse['confidence'];
        if (confidence >= 75) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Faces matched with confidence: $confidence"),
              duration: const Duration(seconds: 4),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegistrationSocialMedia(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Face match failed. Confidence: $confidence"),
              duration: const Duration(seconds: 4),
            ),
          );
        }
        print("Success: $responseData");
      } else {
        setState(() {
          isComparing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Request failed with status: ${response.statusCode}"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: $e"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: !isComparing
          ? Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.longestSide *
                              0.25 *
                              1.75,
                          height: MediaQuery.of(context).size.longestSide *
                              0.25 *
                              1.75,
                        ),
                        Positioned(
                          top: 20,
                          right: MediaQuery.of(context).size.longestSide *
                              0.25 *
                              0.75,
                          child: Transform(
                            transform: Matrix4.rotationZ(-0.1),
                            child: Container(
                              height: MediaQuery.of(context).size.longestSide *
                                  0.40,
                              width: MediaQuery.of(context).size.longestSide *
                                  0.22,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    width: 2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.file(File(widget.selfie.path),
                                    height: MediaQuery.of(context)
                                            .size
                                            .longestSide *
                                        0.4,
                                    width: MediaQuery.of(context)
                                            .size
                                            .longestSide *
                                        0.22,
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.longestSide * 0.20,
                          child: Transform(
                            transform: Matrix4.rotationZ(0.1),
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      width: 2)),
                              height:
                                  MediaQuery.of(context).size.longestSide * 0.4,
                              width: MediaQuery.of(context).size.longestSide *
                                  0.22,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.file(
                                    File(store.state!.profileImagePath!),
                                    height: MediaQuery.of(context)
                                            .size
                                            .longestSide *
                                        0.4,
                                    width: MediaQuery.of(context)
                                            .size
                                            .longestSide *
                                        0.22,
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'For the manual verification we will be comparing your selfie with your profile image',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GradientButton(
                          label: 'Submit Photo',
                          onTap: compareFaces,
                          // onTap: () {
                          //   compareFaces(
                          //       widget.selfie, File(store.state!.profileImagePath!));
                          // },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            constraints: const BoxConstraints(
                                maxWidth: 300.0, maxHeight: 50.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    width: 2)),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Center(child: Text('Retake Photo')),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
