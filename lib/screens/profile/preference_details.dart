import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:irl/data/user_characteristics.dart';
import 'package:irl/main.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/home.dart';
import 'package:irl/screens/profile/interest_details.dart';
import 'package:irl/screens/profile/personality_details.dart';
import 'package:irl/screens/profile/profile_completion.dart';
import 'package:irl/widgets/gradient_button.dart';

class PreferenceDetails extends StatefulWidget {
  const PreferenceDetails({super.key});

  @override
  State<PreferenceDetails> createState() => _PreferenceDetailsState();
}

class _PreferenceDetailsState extends State<PreferenceDetails> {
  String? genderPreference = 'Select';
  TextEditingController minAge = TextEditingController();
  TextEditingController maxAge = TextEditingController();
  RangeValues ageRange = const RangeValues(18, 80);
  int? minHeightFeet;
  int? minHeightInch;
  int? maxHeightFeet;
  int? maxHeightInch;
  List<String>? languagePreference = [];
  List<String>? religionPreferences = [];
  List<String>? highestEducationPreference = [];
  List<String>? fieldOfStudyPreferences = [];
  List<String>? occupationPreferences = [];
  List<String>? interestPreferences = [];
  List<String>? foodLifestylePreferences = [];
  List<String>? personalityPreferences = [];
  bool enabled = false;
  FieldType _type = FieldType.DATE;

  void autoPopulate(CustomUser user) {
    if (user.genderPreference != null)
      genderPreference = user.genderPreference!;
    if (user.minAgePreference != null && user.maxAgePreference != null) {
      minAge.text = user.minAgePreference.toString();
      maxAge.text = user.maxAgePreference.toString();
      ageRange = RangeValues(
          user.minAgePreference!.toDouble(), user.maxAgePreference!.toDouble());
    }
    if (user.maxHeightFeet != null) maxHeightFeet = user.maxHeightFeet!;
    if (user.maxHeightInch != null) maxHeightInch = user.maxHeightInch!;
    if (user.minHeightFeet != null) minHeightFeet = user.minHeightFeet!;
    if (user.minHeightInch != null) minHeightFeet = user.minHeightInch!;
    if (user.languagePreference != null)
      languagePreference = List.from(user.languagePreference!);
    if (user.religionPreference != null)
      religionPreferences = List.from(user.religionPreference!);
    if (user.highestEducationPreference != null)
      highestEducationPreference = List.from(user.highestEducationPreference!);
    if (user.fieldOfStudyPreference != null)
      fieldOfStudyPreferences = List.from(user.fieldOfStudyPreference!);
    if (user.occupationPreference != null)
      occupationPreferences = List.from(user.occupationPreference!);
    if (user.interestPreference != null)
      interestPreferences = List.from(user.interestPreference!);
    if (user.foodLifestylePreference != null)
      foodLifestylePreferences = List.from(user.foodLifestylePreference!);
    if (user.personalityPreference != null)
      personalityPreferences = List.from(user.personalityPreference!);
    if (user.fieldType != null) {
      _type = user.fieldType!;
    }
  }

  final List<String> feet = List.generate(7, (index) => (index + 1).toString());
  final List<String> inches = List.generate(12, (index) => (index).toString());

  void submit() async {
    bool tempFirstLogin = !store.state!.checkMandatoryFields();
    if (genderPreference != 'Select') {
      store.dispatch(UpdatePreferenceDetails(
        maxHeightInch: maxHeightInch == -1 ? null : maxHeightInch,
        maxHeightFeet: maxHeightFeet == -1 ? null : maxHeightFeet,
        minHeightInch: minHeightInch == -1 ? null : minHeightInch,
        minHeightFeet: minHeightFeet == -1 ? null : minHeightFeet,
        fieldOfStudyPreferences: fieldOfStudyPreferences,
        foodLifestylePreferences: foodLifestylePreferences,
        genderPreference: genderPreference,
        highestEducationPreference: highestEducationPreference,
        interestPreferences: interestPreferences,
        languagePreference: languagePreference,
        maxAge: ageRange.end.toString(),
        minAge: ageRange.start.toString(),
        occupationPreferences: occupationPreferences,
        personalityPreferences: personalityPreferences,
        religionPreferences: religionPreferences,
        fieldType: _type,
      ));
      FirebaseAuth auth = FirebaseAuth.instance;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser?.uid)
          .update({
        'maxHeightInch': maxHeightInch == -1 ? null : maxHeightInch,
        'maxHeightFeet': maxHeightFeet == -1 ? null : maxHeightFeet,
        'minHeightInch': minHeightInch == -1 ? null : minHeightInch,
        'minHeightFeet': minHeightFeet == -1 ? null : minHeightFeet,
        'fieldOfStudyPreferences': fieldOfStudyPreferences,
        'foodLifestylePreferences': foodLifestylePreferences,
        'genderPreference': genderPreference,
        'highestEducationPreference': highestEducationPreference,
        'interestPreferences': interestPreferences,
        'languagePreference': languagePreference,
        'maxAgePreference': ageRange.end,
        'minAgePreference': ageRange.start,
        'occupationPreferences': occupationPreferences,
        'personalityPreferences': personalityPreferences,
        'religionPreferences': religionPreferences,
        'fieldType': _type.name,
      }).then((value) {
        if (tempFirstLogin) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ProfileCompletion()));
        } else {
          Navigator.of(context).pop();
        }
      });
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Enter gender preference!',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ));
      }
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
    if (user.genderPreference != genderPreference ||
        user.minAgePreference.toString() != minAge.text.trim() ||
        user.maxAgePreference.toString() != maxAge.text.trim() ||
        user.maxHeightFeet != maxHeightFeet ||
        user.maxHeightInch != maxHeightInch ||
        user.minHeightInch != minHeightInch ||
        user.minHeightFeet != minHeightFeet ||
        !listEquals(user.languagePreference, languagePreference) ||
        !listEquals(user.religionPreference, religionPreferences) ||
        !listEquals(
            user.highestEducationPreference, highestEducationPreference) ||
        !listEquals(user.fieldOfStudyPreference, fieldOfStudyPreferences) ||
        !listEquals(user.occupationPreference, occupationPreferences) ||
        !listEquals(user.interestPreference, interestPreferences) ||
        !listEquals(user.foodLifestylePreference, foodLifestylePreferences) ||
        !listEquals(user.personalityPreference, personalityPreferences) ||
        user.fieldType?.name != _type.name) {
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    minAge.text = '16';
    maxAge.text = '80';
    feet.add('Feet');
    inches.add('Inch');
    super.initState();
  }

  void rebuild(CustomUser user) {
    autoPopulate(user);
    interestTitles.sort((a, b) {
      if (interestPreferences!.contains(a) &&
          !interestPreferences!.contains(b)) {
        return -1;
      } else if ((interestPreferences!.contains(a) &&
              interestPreferences!.contains(b)) ||
          (!interestPreferences!.contains(a) &&
              !interestPreferences!.contains(b))) {
        return 0;
      }
      return 1;
    });
    personalityTitles.sort((a, b) {
      if (personalityPreferences!.contains(a) &&
          !personalityPreferences!.contains(b)) {
        return -1;
      } else if ((personalityPreferences!.contains(a) &&
              personalityPreferences!.contains(b)) ||
          (!personalityPreferences!.contains(a) &&
              !personalityPreferences!.contains(b))) {
        return 0;
      }
      return 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            'Partner Preferences',
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
                const Center(child: Text("5/5")),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    value: 1,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ],
            )
          ],
        ),
        body: StoreBuilder<CustomUser?>(
          onInit: (user) {
            autoPopulate(user.state!);
            interestTitles.sort((a, b) {
              if (interestPreferences!.contains(a) &&
                  !interestPreferences!.contains(b)) {
                return -1;
              } else if ((interestPreferences!.contains(a) &&
                      interestPreferences!.contains(b)) ||
                  (!interestPreferences!.contains(a) &&
                      !interestPreferences!.contains(b))) {
                return 0;
              }
              return 1;
            });
            personalityTitles.sort((a, b) {
              if (personalityPreferences!.contains(a) &&
                  !personalityPreferences!.contains(b)) {
                return -1;
              } else if ((personalityPreferences!.contains(a) &&
                      personalityPreferences!.contains(b)) ||
                  (!personalityPreferences!.contains(a) &&
                      !personalityPreferences!.contains(b))) {
                return 0;
              }
              return 1;
            });
          },
          builder: (context, user) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Profiles will be shown according to your preferences.',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Partner Details',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'What are you looking for?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _type = FieldType.DATE;
                          setState(() {
                            enabled = checkStateChange(store.state!);
                          });
                        },
                        child: _builderSeletableBox(
                          title: "Find a Date",
                          borderColor: _type == FieldType.DATE
                              ? Colors.blueAccent
                              : Colors.grey,
                          color: _type == FieldType.DATE
                              ? Colors.blueAccent
                              : Colors.transparent,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          _type = FieldType.NETWORK;
                          setState(() {
                            enabled = checkStateChange(store.state!);
                          });
                        },
                        child: _builderSeletableBox(
                          title: "Network",
                          borderColor: _type != FieldType.DATE
                              ? Colors.blueAccent
                              : Colors.grey,
                          color: _type != FieldType.DATE
                              ? Colors.blueAccent
                              : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Gender*',
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
                        value: genderPreference ?? 'Select',
                        items: genderTitles.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              ));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            genderPreference = value ?? 'Select';
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
                      'Age',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  RangeSlider(
                    max: 80,
                    divisions: 60,
                    min: 18,
                    values: ageRange,
                    onChanged: (values) {
                      setState(() {
                        minAge.text = values.start.toStringAsFixed(0);
                        maxAge.text = values.end.toStringAsFixed(0);
                        ageRange = values;
                        enabled = checkStateChange(store.state!);
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            constraints: const BoxConstraints(maxWidth: 100),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelText: '18',
                            labelStyle: Theme.of(context).textTheme.labelMedium,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        controller: minAge,
                        style: Theme.of(context).textTheme.bodyMedium,
                        onEditingComplete: () {
                          setState(() {
                            ageRange = RangeValues(double.parse(minAge.text),
                                double.parse(maxAge.text));
                            enabled = checkStateChange(store.state!);
                          });
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            constraints: const BoxConstraints(maxWidth: 100),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelText: '80',
                            labelStyle: Theme.of(context).textTheme.labelMedium,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        controller: maxAge,
                        style: Theme.of(context).textTheme.bodyMedium,
                        onEditingComplete: () {
                          setState(() {
                            ageRange = RangeValues(double.parse(minAge.text),
                                double.parse(maxAge.text));
                            enabled = checkStateChange(store.state!);
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Languages you prefer',
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
                                !languagePreference!.contains(value)) {
                              languagePreference!.add(value);
                            }
                            enabled = checkStateChange(store.state!);
                          });
                        }),
                  ),
                  languagePreference!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                          child: Wrap(
                              spacing: 10,
                              children: languagePreference!.map((e) {
                                return RawChip(
                                  avatar: const Icon(Icons.close,
                                      color: Colors.white),
                                  deleteIcon: const Icon(Icons.close),
                                  showCheckmark: false,
                                  onPressed: () {
                                    setState(() {
                                      languagePreference!.remove(e);
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
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Religions you prefer',
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
                        items: religions.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value.toString()));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value != null &&
                                value != 'Select' &&
                                !religionPreferences!.contains(value)) {
                              religionPreferences!.add(value);
                            }
                            enabled = checkStateChange(store.state!);
                          });
                        }),
                  ),
                  religionPreferences!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                          child: Wrap(
                              spacing: 10,
                              children: religionPreferences!.map((e) {
                                return RawChip(
                                  avatar: const Icon(Icons.close,
                                      color: Colors.white),
                                  deleteIcon: const Icon(Icons.close),
                                  showCheckmark: false,
                                  onPressed: () {
                                    setState(() {
                                      religionPreferences!.remove(e);
                                    });
                                    enabled = checkStateChange(store.state!);
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
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Maximum height',
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
                              value: maxHeightFeet == null
                                  ? 'Feet'
                                  : maxHeightFeet.toString(),
                              items: feet.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(value.toString()),
                                    ));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  maxHeightFeet = value == 'Feet'
                                      ? null
                                      : int.parse(value!);
                                  enabled = checkStateChange(store.state!);
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
                              value: maxHeightInch == null
                                  ? 'Inch'
                                  : maxHeightInch.toString(),
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
                                  maxHeightInch = value == 'Inch'
                                      ? null
                                      : int.parse(value!);
                                  enabled = checkStateChange(store.state!);
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
                      'Minimum height',
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
                              value: minHeightFeet == null
                                  ? 'Feet'
                                  : minHeightFeet.toString(),
                              items: feet.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(value.toString()),
                                    ));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  minHeightFeet = value == 'Feet'
                                      ? null
                                      : int.parse(value!);
                                  enabled = checkStateChange(store.state!);
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
                              value: minHeightInch == null
                                  ? 'Inch'
                                  : minHeightInch.toString(),
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
                                  minHeightInch = value == 'Inch'
                                      ? null
                                      : int.parse(value!);
                                  enabled = checkStateChange(store.state!);
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  const Divider(thickness: 1.5),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Career',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Highest level of education you prefer',
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
                        items: educationLevels.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value.toString()));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value != null &&
                                value != 'Select' &&
                                !highestEducationPreference!.contains(value)) {
                              highestEducationPreference!.add(value);
                            }
                            enabled = checkStateChange(store.state!);
                          });
                        }),
                  ),
                  highestEducationPreference!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                          child: Wrap(
                              spacing: 10,
                              children: highestEducationPreference!.map((e) {
                                return RawChip(
                                  avatar: const Icon(Icons.close,
                                      color: Colors.white),
                                  deleteIcon: const Icon(Icons.close),
                                  showCheckmark: false,
                                  onPressed: () {
                                    setState(() {
                                      highestEducationPreference!.remove(e);
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
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Field of study',
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
                        items: fields.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value.toString()));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value != null &&
                                value != 'Select' &&
                                !fieldOfStudyPreferences!.contains(value)) {
                              fieldOfStudyPreferences!.add(value);
                            }
                            enabled = checkStateChange(store.state!);
                          });
                        }),
                  ),
                  fieldOfStudyPreferences!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                          child: Wrap(
                              spacing: 10,
                              children: fieldOfStudyPreferences!.map((e) {
                                return RawChip(
                                  avatar: const Icon(Icons.close,
                                      color: Colors.white),
                                  deleteIcon: const Icon(Icons.close),
                                  showCheckmark: false,
                                  onPressed: () {
                                    setState(() {
                                      fieldOfStudyPreferences!.remove(e);
                                    });
                                    enabled = checkStateChange(store.state!);
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
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Occupation Preferences',
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
                        items: occupations.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value.toString()));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value != null &&
                                value != 'Select' &&
                                !occupationPreferences!.contains(value)) {
                              occupationPreferences!.add(value);
                            }
                            enabled = checkStateChange(store.state!);
                          });
                        }),
                  ),
                  occupationPreferences!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                          child: Wrap(
                              spacing: 10,
                              children: occupationPreferences!.map((e) {
                                return RawChip(
                                  avatar: const Icon(Icons.close,
                                      color: Colors.white),
                                  deleteIcon: const Icon(Icons.close),
                                  showCheckmark: false,
                                  onPressed: () {
                                    setState(() {
                                      occupationPreferences!.remove(e);
                                    });
                                    enabled = checkStateChange(store.state!);
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
                  const SizedBox(height: 35),
                  const Divider(thickness: 1.5),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Interests & Lifestyle',
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Interests you prefer',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                          spacing: 5,
                          children: interestTitles.take(10).map((e) {
                            return RawChip(
                              avatar: !interestPreferences!.contains(e)
                                  ? const Icon(
                                      Icons.add,
                                      color: Color(0xFFCFD1D1),
                                    )
                                  : null,
                              deleteIcon: const Icon(Icons.close_rounded),
                              label: Text(
                                e,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              selectedColor:
                                  Theme.of(context).colorScheme.primary,
                              selected: interestPreferences!.contains(e),
                              onSelected: (value) {
                                setState(() {
                                  if (interestPreferences!.contains(e)) {
                                    interestPreferences!.remove(e);
                                  } else {
                                    interestPreferences!.add(e);
                                  }
                                  enabled = checkStateChange(store.state!);
                                });
                              },
                            );
                          }).toList())),
                  RawChip(
                    label: Text(
                      'See More',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onPressed: () {
                      store.dispatch(
                          UpdateInterestPreference(interestPreferences));
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) =>
                                  const InterestDetails(isPreferences: true)))
                          .then((value) {
                        setState(() {
                          rebuild(user.state!);
                        });
                      });
                    },
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Food lifestyle preferences',
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
                        items: foodLifestyleTitles.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value, child: Text(value.toString()));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            if (value != null &&
                                value != 'Select' &&
                                !foodLifestylePreferences!.contains(value)) {
                              foodLifestylePreferences!.add(value);
                            }
                          });
                          enabled = checkStateChange(store.state!);
                        }),
                  ),
                  foodLifestylePreferences!.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                          child: Wrap(
                              spacing: 10,
                              children: foodLifestylePreferences!.map((e) {
                                return RawChip(
                                  avatar: const Icon(Icons.close,
                                      color: Colors.white),
                                  deleteIcon: const Icon(Icons.close),
                                  showCheckmark: false,
                                  onPressed: () {
                                    setState(() {
                                      foodLifestylePreferences!.remove(e);
                                    });
                                    enabled = checkStateChange(store.state!);
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
                  const SizedBox(height: 35),
                  const Divider(thickness: 1.5),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Personality',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Personalities you prefer',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                          spacing: 5,
                          children: personalityTitles.take(10).map((e) {
                            return RawChip(
                              avatar: !personalityPreferences!.contains(e)
                                  ? const Icon(
                                      Icons.add,
                                      color: Color(0xFFCFD1D1),
                                    )
                                  : null,
                              label: Text(
                                e,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              selectedColor:
                                  Theme.of(context).colorScheme.primary,
                              selected: personalityPreferences!.contains(e),
                              onSelected: (value) {
                                setState(() {
                                  if (personalityPreferences!.contains(e)) {
                                    personalityPreferences!.remove(e);
                                  } else {
                                    personalityPreferences!.add(e);
                                  }
                                  enabled = checkStateChange(store.state!);
                                });
                              },
                            );
                          }).toList())),
                  RawChip(
                    label: Text(
                      'See More',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onPressed: () {
                      store.dispatch(
                          UpdatePersonalityPreferences(personalityPreferences));
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) =>
                                  const PersonalityDetails(isPreference: true)))
                          .then((value) {
                        setState(() {
                          rebuild(store.state!);
                        });
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  )
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

  Widget _builderSeletableBox(
      {required String title, Color? color, required Color borderColor}) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor)),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
