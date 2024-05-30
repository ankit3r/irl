import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:irl/screens/registration/terms_n_conditions.dart';
import 'package:irl/widgets/gradient_button.dart';

class RegistrationSocialURL extends StatefulWidget {
  final int choice;
  const RegistrationSocialURL({super.key, required this.choice});

  @override
  State<RegistrationSocialURL> createState() => _RegistrationSocialURLState();
}

class _RegistrationSocialURLState extends State<RegistrationSocialURL> {
  String socialMedia = "";
  Widget? icon;
  Color? color;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switch (widget.choice) {
      case 0:
        socialMedia = "Facebook";
        icon = const FaIcon(FontAwesomeIcons.facebook, color: Colors.white);
        color = const Color(0xFF1877F2);
        break;
      case 1:
        socialMedia = "LinkedIn";
        icon = const FaIcon(FontAwesomeIcons.linkedin, color: Colors.white);
        color = const Color(0xFF0077B5);
        break;
      case 2:
        socialMedia = "Instagram";
        icon = const FaIcon(FontAwesomeIcons.instagram, color: Colors.white);
        color = const Color(0xFFE4405F);
        break;
      case 3:
        socialMedia = "Twitter";
        icon = const FaIcon(FontAwesomeIcons.xTwitter, color: Colors.white);
        color = Colors.grey;
        break;
      case 4:
        socialMedia = "Threads";
        icon = const FaIcon(FontAwesomeIcons.threads, color: Colors.black);
        color = Colors.white;
        break;
      default:
        socialMedia = "Other";
        icon = const Icon(Icons.messenger_rounded, color: Colors.white);
        color = const Color(0xFF4F5DF0);
        break;
    }
  }

  TextEditingController urlController = TextEditingController();
  bool enabled = true;
  bool isValidUrl(String url) {
    final urlRegExp = RegExp(
      r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$',
      caseSensitive: false,
    );

    return urlRegExp.hasMatch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Add your\n profile URL',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  constraints:
                      const BoxConstraints(maxWidth: 300, minHeight: 60),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon!,
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        socialMedia,
                        style: widget.choice == 4
                            ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Colors.black,
                                )
                            : null,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: urlController,
                  keyboardType: TextInputType.url,
                  onChanged: (value) {
                    setState(() {
                      enabled = isValidUrl(urlController.text.trim());
                    });
                  },
                  onEditingComplete: () {
                    setState(() {
                      enabled = isValidUrl(urlController.text.trim());
                    });
                    FocusScope.of(context).unfocus();
                  },
                  onTapOutside: (pointer) {
                    setState(() {
                      enabled = isValidUrl(urlController.text.trim());
                    });
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                      suffixIcon: const Padding(
                        padding: EdgeInsets.fromLTRB(2, 0, 20, 0),
                        child: Icon(Icons.link),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'URL',
                      labelStyle: Theme.of(context).textTheme.labelMedium,
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.tertiary,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      constraints: const BoxConstraints(maxWidth: 300),
                      contentPadding: const EdgeInsets.all(13),
                      counterText: ""),
                ),
                SizedBox(
                  height: urlController.text.isNotEmpty && !enabled ? 10 : 0,
                ),
                urlController.text.isNotEmpty && !enabled
                    ? Text(
                        'Enter a valid URL',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Theme.of(context).colorScheme.error),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GradientButton(
        enable: true,
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TermsConditions()));
        },
        label: 'Next',
      ),
    );
  }
}
