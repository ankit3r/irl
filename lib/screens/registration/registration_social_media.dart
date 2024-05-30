import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:irl/screens/registration/registration_social_url.dart';
import 'package:irl/widgets/gradient_button.dart';

class RegistrationSocialMedia extends StatefulWidget {
  const RegistrationSocialMedia({super.key});

  @override
  State<RegistrationSocialMedia> createState() =>
      _RegistrationSocialMediaState();
}

class _RegistrationSocialMediaState extends State<RegistrationSocialMedia> {
  TextEditingController urlController = TextEditingController();
  bool enableButton = false;
  int choice = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: [
                    Text(
                      'Verify on\nSocial Media',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            choice = 0;
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width * 0.65,
                          decoration: BoxDecoration(
                              color:
                                  choice == 0 ? const Color(0xFF1877F2) : null,
                              borderRadius: BorderRadius.circular(10),
                              border: choice == 0
                                  ? null
                                  : Border.all(
                                      color: Colors.white,
                                    )),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.facebook,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text('Facebook')
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            choice = 1;
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width * 0.65,
                          decoration: BoxDecoration(
                              color:
                                  choice == 1 ? const Color(0xFF0077B5) : null,
                              borderRadius: BorderRadius.circular(10),
                              border: choice == 1
                                  ? null
                                  : Border.all(color: Colors.white)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.linkedin,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text('LinkedIn')
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            choice = 2;
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width * 0.65,
                          decoration: BoxDecoration(
                              color:
                                  choice == 2 ? const Color(0xFFE4405F) : null,
                              borderRadius: BorderRadius.circular(10),
                              border: choice == 2
                                  ? null
                                  : Border.all(color: Colors.white)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.instagram,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text('Instagram')
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            choice = 3;
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width * 0.65,
                          decoration: BoxDecoration(
                              color: choice == 3 ? Colors.grey : null,
                              borderRadius: BorderRadius.circular(10),
                              border: choice == 3
                                  ? null
                                  : Border.all(color: Colors.white)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.xTwitter,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text('Twitter')
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            choice = 4;
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width * 0.65,
                          decoration: BoxDecoration(
                            color: choice == 4 ? Colors.white : null,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.threads,
                                color:
                                    choice == 4 ? Colors.black : Colors.white,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Threads',
                                style: choice == 4
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Colors.black,
                                        )
                                    : null,
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            choice = 5;
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(15),
                          width: MediaQuery.of(context).size.width * 0.65,
                          decoration: BoxDecoration(
                            color: choice == 5
                                ? Theme.of(context).colorScheme.primary
                                : null,
                            borderRadius: BorderRadius.circular(10),
                            border: choice == 5
                                ? null
                                : Border.all(color: Colors.white),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.messenger_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text('Other')
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(
                        TextSpan(
                          text:
                              "P.S. We are committed to preventing catfishing on our platform. Your account information will be used exclusively for verification purposes. ",
                          style: Theme.of(context).textTheme.bodySmall,
                          children: [
                            TextSpan(
                              text: "Gelo Social Media",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Theme.of(context).colorScheme.primary,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary, // Change the color as needed
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GradientButton(
                      enable: choice < 6 && choice >= 0,
                      label: 'Next',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegistrationSocialURL(
                                  choice: choice,
                                )));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
