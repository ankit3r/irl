import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:irl/data/user_characteristics.dart';
import 'package:irl/main.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/home.dart';
import 'package:irl/screens/profile/career_details.dart';
import 'package:email_validator/email_validator.dart';
import 'package:irl/widgets/gradient_button.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  String gender = 'Select';
  String? maritalStatus;
  String phoneNumber = '+91 XXXXX XXXXX';
  String dateOfBirth = 'DD/MM/YYYY';
  String? currentAddressCountry;
  String? currentAddressState;
  String? currentAddressCity;
  String? homeCity;
  String? homeState;
  String? homeCountry;
  int? heightFeet;
  int? heightInch;
  FieldType _type = FieldType.DATE;

  // String? heightFeet = 'Feet';
  // String? heightInch = 'Inch';
  String? religion;
  List<String>? languagesYouKnow = [];
  final List<String> feet = List.generate(8, (index) => (index).toString());

  final List<String> inches = List.generate(12, (index) => (index).toString());

  void autoPopulate(CustomUser user) {
    if (user.fullName != null) fullNameController.text = user.fullName!;
    if (user.phoneNumber != null) phoneNumber = user.phoneNumber!;
    if (user.bio != null) aboutController.text = user.bio!;
    if (user.email != null) emailController.text = user.email!;
    if (user.dateOfBirth != null) {
      dateOfBirth =
          '${user.dateOfBirth!.day}/${user.dateOfBirth!.month}/${user.dateOfBirth!.year}';
    }
    if (user.homeCountry != null) homeCountry = user.homeCountry;
    if (user.homeState != null) homeState = user.homeState;
    if (user.homeCity != null) homeCity = user.homeCity;
    if (user.currentAddressCountry != null) {
      currentAddressCountry = user.currentAddressCountry;
    }
    if (user.currentAddressState != null) {
      currentAddressState = user.currentAddressState;
    }
    if (user.currentAddressCity != null) {
      currentAddressCity = user.currentAddressCity;
    }
    if (user.gender != null) gender = user.gender!;
    if (user.maritalStatus != null) maritalStatus = user.maritalStatus;
    // changes
    if (user.heightFeet != null) heightFeet = user.heightFeet;
    if (user.heightInch != null) heightInch = user.heightInch;
    // if (user.heightFeet != null) heightFeet = user.heightFeet.toString();
    // if (user.heightInch != null) heightInch = user.heightInch.toString();
    if (user.religion != null) religion = user.religion;
    if (user.language != null && user.language!.isNotEmpty) {
      languagesYouKnow = List.from(user.language!);
    }
  }

  bool listEquals(List<String>? list1, List<String>? list2) {
    if (list1 == null && list2 == null) return true;
    if (list1 != null && list2 == null) return list1.isEmpty;
    if (list1 == null && list2 != null) return list2.isEmpty;
    if (list1!.length != list2!.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (!list2.contains(list1[i])) {
        return false;
      }
    }
    return true;
  }

  bool checkStateChange(CustomUser user) {
    if (user.fullName!.trim() != fullNameController.text.trim() ||
        (user.bio != null && user.bio!.trim() != aboutController.text.trim()) ||
        ((user.email == null && emailController.text.isNotEmpty) ||
            (user.email != null &&
                user.email!.trim() != emailController.text.trim())) ||
        user.homeCountry != homeCountry ||
        user.homeState != homeState ||
        user.homeCity != homeCity ||
        user.currentAddressCountry != currentAddressCountry ||
        user.currentAddressState != currentAddressState ||
        user.currentAddressCity != currentAddressCity ||
        user.gender != gender ||
        user.maritalStatus != maritalStatus ||
        user.heightFeet.toString() != heightFeet ||
        user.heightInch.toString() != heightInch ||
        user.religion != religion ||
        !listEquals(user.language, languagesYouKnow)) {
      return true;
    }
    return false;
  }

  bool enabled = false;

  FocusNode focusNode = FocusNode();

  Widget fullNameTextField(BuildContext context) {
    return TextField(
      onTapOutside: (pointer) {
        if (fullNameController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Full name cannot be empty!",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ));
        } else {
          setState(() {
            enabled = checkStateChange(store.state!);
          });
        }
        FocusScope.of(context).unfocus();
      },
      onEditingComplete: () {
        if (fullNameController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Full name cannot be empty!",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ));
        } else {
          setState(() {
            enabled = checkStateChange(store.state!);
          });
        }
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: 'Your Name',
        labelStyle: Theme.of(context).textTheme.labelMedium,
        enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onPrimaryContainer)),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      controller: fullNameController,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget aboutTextField(BuildContext context) {
    return TextField(
      onChanged: (value) {
        if (aboutController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "About cannot be empty!",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ));
        }
        setState(() {
          enabled = checkStateChange(store.state!);
        });
      },
      onTapOutside: (pointer) {
        if (aboutController.text.trim().isEmpty) {
          FocusScope.of(context).unfocus();
        } else {
          setState(() {
            enabled = checkStateChange(store.state!);
          });
        }
        FocusScope.of(context).unfocus();
      },
      onEditingComplete: () {
        if (aboutController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "About cannot be empty!",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ));
        } else {
          setState(() {
            enabled = checkStateChange(store.state!);
          });
        }
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: 'Enter a bio',
          labelStyle: Theme.of(context).textTheme.labelMedium,
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.onPrimaryContainer)),
          constraints: const BoxConstraints(maxHeight: 100),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      style: Theme.of(context).textTheme.bodyMedium,
      controller: aboutController,
      keyboardType: TextInputType.multiline,
      expands: true,
      maxLines: null,
      minLines: null,
    );
  }

  Widget emailTextField(BuildContext context) {
    return TextField(
      onEditingComplete: () {
        if (EmailValidator.validate(emailController.text.trim())) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Enter valid email-Id",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ));
        } else {
          setState(() {
            enabled = checkStateChange(store.state!);
          });
        }
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: 'Enter your email',
        labelStyle: Theme.of(context).textTheme.labelMedium,
        enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onPrimaryContainer)),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      controller: emailController,
    );
  }

  void submit() async {
    try {
      if (aboutController.text.isEmpty ||
          fullNameController.text.isEmpty ||
          currentAddressCountry == 'Country' ||
          currentAddressState == 'State' ||
          currentAddressCity == 'City') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          content: Text(
            'Fill the mandatory fields',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          duration: const Duration(seconds: 2),
        ));
      } else {
        store.dispatch(UpdatePersonalDetails(
            fullName: fullNameController.text,
            bio: aboutController.text,
            gender: gender,
            currentAddressCountry: currentAddressCountry!,
            currentAddressState: currentAddressState!,
            currentAddressCity: currentAddressCity!,
            //changes
            heightFeet: int.tryParse(heightFeet.toString()??'0'),
            heightInch: int.tryParse(heightInch.toString()??'0')));
        // heightFeet: heightFeet!,
        // heightInch: heightInch!));
        FirebaseAuth auth = FirebaseAuth.instance;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser?.uid)
            .update({
          'fullName': fullNameController.text,
          'bio': aboutController.text,
          'email':
              emailController.text.isNotEmpty ? emailController.text : null,
          'maritalStatus': maritalStatus != 'Select' ? maritalStatus : null,
          'gender': gender != 'Select' ? gender : null,
          'currentAddressCity': currentAddressCity,
          'currentAddressState': currentAddressState,
          'currentAddressCountry': currentAddressCountry,
          'homeCity': homeCity,
          'homeState': homeState,
          'homeCountry': homeCountry,
          'language': languagesYouKnow,
          'religion': religion != 'Select' ? religion : null,
          'heightFeet': int.tryParse(heightFeet.toString()),
          'heightInch': int.tryParse(heightInch.toString())
          //changes
          // 'heightFeet': int.parse(heightFeet!),
          // 'heightInch': int.parse(heightInch!)
        }).then((value) {
          if (store.state!.checkMandatoryFields()) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => const CareerDetails()))
                .then((value) {
              setState(() {
                autoPopulate(store.state!);
              });
            });
          }
        });
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Theme.of(context).colorScheme.background,
          title: Text(
            'Personal Details',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(6.0),
            child: !store.state!.checkMandatoryFields()
                ? InkWell(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const Home()),
                          (route) => route.settings.name == '/');
                    },
                    child: CircleAvatar(
                      child: ClipOval(
                          child: Image.network(
                        StoreProvider.of<CustomUser?>(context)
                            .state!
                            .profileImage!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )),
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          ),
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Center(child: Text("1/5")),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    value: 0.2,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ],
            ),
          ],
        ),
        body: StoreBuilder<CustomUser?>(
          onInit: (user) {
            autoPopulate(user.state!);
          },
          builder: (context, user) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(23.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'What do we call you? *',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  fullNameTextField(context),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'About *',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  aboutTextField(context),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Mobile Number *',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                        labelStyle: Theme.of(context).textTheme.labelMedium,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: phoneNumber,
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    keyboardType: TextInputType.phone,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                        'Note: Contact us if you wish to change your mobile number',
                        style: Theme.of(context).textTheme.labelSmall),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Email Address',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  emailTextField(context),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Date of Birth *',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: dateOfBirth,
                        labelStyle: Theme.of(context).textTheme.labelMedium,
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Where are you from?',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  CSCPicker(
                    flagState: CountryFlag.DISABLE,
                    citySearchPlaceholder: 'City',
                    stateSearchPlaceholder: 'State',
                    countrySearchPlaceholder: 'Country',
                    onCountryChanged: (value) {
                      setState(() {
                        homeCountry = value;
                      });
                    },
                    onStateChanged: (value) {
                      setState(() {
                        homeState = value;
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        homeCity = value;
                        enabled = checkStateChange(store.state!);
                      });
                    },
                    selectedItemStyle: Theme.of(context).textTheme.bodyMedium,
                    currentCity: homeCity,
                    currentState: homeState,
                    currentCountry: homeCountry,
                    showCities: true,
                    showStates: true,
                    disabledDropdownDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    dropdownDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Where do you currently live? *',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  CSCPicker(
                    flagState: CountryFlag.DISABLE,
                    citySearchPlaceholder: 'City',
                    stateSearchPlaceholder: 'State',
                    countrySearchPlaceholder: 'Country',
                    onCountryChanged: (value) {
                      setState(() {
                        currentAddressCountry = value;
                      });
                    },
                    onStateChanged: (value) {
                      setState(() {
                        currentAddressState = value;
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        currentAddressCity = value;
                        enabled = checkStateChange(store.state!);
                      });
                    },
                    selectedItemStyle: Theme.of(context).textTheme.bodyMedium,
                    currentCity: currentAddressCity,
                    currentState: currentAddressState,
                    currentCountry: currentAddressCountry,
                    showCities: true,
                    showStates: true,
                    disabledDropdownDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    dropdownDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),


                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'What do you identify as? *',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    constraints: const BoxConstraints(maxHeight: 45),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: DropdownButton<String>(
                        dropdownColor: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        isExpanded: true,
                        underline: const SizedBox(),
                        style: Theme.of(context).textTheme.bodyMedium,
                        value: gender,
                        items: genderTitles.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              ));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            gender = value ?? 'Select';
                            enabled = checkStateChange(store.state!) &&
                                value != 'Select';
                          });
                        }),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Marital Status',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    constraints: const BoxConstraints(maxHeight: 45),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: DropdownButton<String>(
                        dropdownColor: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        isExpanded: true,
                        underline: const SizedBox(),
                        style: Theme.of(context).textTheme.bodyMedium,
                        value: maritalStatus ?? 'Select',
                        items: maritalStatusTitles.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            maritalStatus = value ?? 'Select';
                            enabled = checkStateChange(store.state!);
                          });
                        }),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'What is your height? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 50),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          constraints: const BoxConstraints(maxHeight: 45),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: DropdownButton<String>(
                              dropdownColor:
                                  Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(10),
                              menuMaxHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                              icon:
                                  const Icon(Icons.keyboard_arrow_down_rounded),
                              underline: const SizedBox(),
                              style: Theme.of(context).textTheme.bodyMedium,
                              //changes
                              // value: heightFeet,
                              value: heightFeet?.toString(),
                              hint: const Text("Feet"),
                              items: feet.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(value.toString()),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  if (value != '0') {
                                    heightFeet = int.tryParse(value ?? 'Feet');
                                  } else {
                                    showMassage(
                                        "Please select the correct feet value.");
                                  }
                                  // changes
                                  // heightFeet = value ?? 'Feet';
                                  enabled = checkStateChange(store.state!) &&
                                      value != 'Feet';
                                });
                              }),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          constraints: const BoxConstraints(maxHeight: 45),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: DropdownButton<String>(
                              dropdownColor:
                                  Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(10),
                              menuMaxHeight:
                                  MediaQuery.of(context).size.height * 0.5,
                              icon:
                                  const Icon(Icons.keyboard_arrow_down_rounded),
                              underline: const SizedBox(),
                              style: Theme.of(context).textTheme.bodyMedium,
                              value: heightInch?.toString(),
                              // changes
                              // value: heightInch,
                              hint: const Text("Inch"),
                              items: inches.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(value.toString()),
                                    ));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  heightInch = int.tryParse(value ?? 'Inch');
                                  //Changes
                                  // heightInch = value ?? 'Inch';
                                  enabled = checkStateChange(store.state!) &&
                                      value != 'Inch';
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'What is your religious affiliation',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    constraints: const BoxConstraints(maxHeight: 45),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: DropdownButton<String>(
                        dropdownColor: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        isExpanded: true,
                        underline: const SizedBox(),
                        style: Theme.of(context).textTheme.bodyMedium,
                        value: religion ?? 'Select',
                        items: religions.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value.toString()));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            religion = value == 'Select' ? null : value;
                            enabled = checkStateChange(store.state!);
                          });
                        }),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Languages you know',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    constraints: const BoxConstraints(maxHeight: 45),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: DropdownButton<String>(
                        dropdownColor: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        isExpanded: true,
                        underline: const SizedBox(),
                        style: Theme.of(context).textTheme.bodyMedium,
                        value: 'Select',
                        items: languages.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value.toString()));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value != null &&
                                value != 'Select' &&
                                !languagesYouKnow!.contains(value)) {
                              languagesYouKnow!.add(value);
                            }
                            enabled = checkStateChange(store.state!);
                          });
                        }),
                  ),
                  languagesYouKnow!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(5, 8, 5, 5),
                          child: Wrap(
                              spacing: 10,
                              children: languagesYouKnow!.map((e) {
                                return RawChip(
                                  avatar: const Icon(Icons.close,
                                      color: Colors.white),
                                  deleteIcon: const Icon(Icons.close),
                                  showCheckmark: false,
                                  onPressed: () {
                                    setState(() {
                                      languagesYouKnow!.remove(e);
                                      enabled = checkStateChange(store.state!);
                                    });
                                  },
                                  tapEnabled: true,
                                  selected: true,
                                  label: Text(
                                    e,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  selectedColor:
                                      Theme.of(context).colorScheme.primary,
                                );
                              }).toList()),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 70,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 68,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFDB7E80),
                      Color(0xFF8147A7),
                      Color(0xFF3008D9),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              !store.state!.checkMandatoryFields()
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.97,
                      height: 64,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Prev'),
                            ),
                            InkWell(
                              onTap: submit,
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                radius: 20,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 22,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GradientButton(
                        enable: enabled,
                        label: 'Update',
                        onTap: submit,
                      ),
                    ),
            ],
          ),
        ));
  }

  void showMassage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      duration: const Duration(seconds: 2),
    ));
  }


}
