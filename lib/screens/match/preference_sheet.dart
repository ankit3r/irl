import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:irl/data/user_characteristics.dart';
import 'package:irl/main.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/profile/interest_details.dart';
import 'package:irl/screens/profile/personality_details.dart';

import '../../widgets/gradient_button.dart';

class PreferenceSheet extends StatefulWidget {
  const PreferenceSheet({super.key});

  @override
  State<PreferenceSheet> createState() => _PreferenceSheetState();
}

class _PreferenceSheetState extends State<PreferenceSheet> {
  String genderPreference = 'Select';
  TextEditingController minAge = TextEditingController();
  TextEditingController maxAge = TextEditingController();
  RangeValues ageRange = const RangeValues(18, 80);
  int minHeightFeet = -1;
  int minHeightInch = -1;
  int maxHeightFeet = -1;
  int maxHeightInch = -1;
  List<String> languagePreference = [];
  List<String> religionPreferences = [];
  List<String> highestEducationPreference = [];
  List<String> fieldOfStudyPreferences = [];
  List<String> occupationPreferences = [];
  List<String> interestPreferences = [];
  List<String> foodLifestylePreferences = [];
  List<String> personalityPreferences = [];
  FieldType _type = FieldType.DATE;

  void autoPopulate(CustomUser user) {
    if (user.genderPreference != null) {
      genderPreference = user.genderPreference!;
    }
    if (user.minAgePreference != null && user.maxAgePreference != null) {
      minAge.text = user.minAgePreference.toString();
      maxAge.text = user.maxAgePreference.toString();
      ageRange = RangeValues(
          user.minAgePreference!.toDouble(), user.maxAgePreference!.toDouble());
    }
    if (user.languagePreference != null) {
      languagePreference = user.languagePreference!;
    }
    if (user.religionPreference != null) {
      religionPreferences = user.religionPreference!;
    }
    if (user.highestEducationPreference != null) {
      highestEducationPreference = user.highestEducationPreference!;
    }
    if (user.fieldOfStudyPreference != null) {
      fieldOfStudyPreferences = user.fieldOfStudyPreference!;
    }
    if (user.occupationPreference != null) {
      occupationPreferences = user.occupationPreference!;
    }
    if (user.interestPreference != null) {
      interestPreferences = user.interestPreference!;
    }
    if (user.foodLifestylePreference != null) {
      foodLifestylePreferences = user.foodLifestylePreference!;
    }
    if (user.personalityPreference != null) {
      personalityPreferences = user.personalityPreference!;
    }
    if (user.fieldType != null) {
      _type = user.fieldType!;
    }
  }

  final List<String> feet =
      List.generate(15, (index) => (index + 1).toString());
  final List<String> inches = List.generate(12, (index) => (index).toString());

  @override
  void initState() {
    // TODO: implement initState
    minAge.text = '18';
    maxAge.text = '80';
    feet.add('Feet');
    inches.add('Inch');
    super.initState();
  }

  void submit() async {
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
        'fieldType': _type,
      }).then((value) {
        Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<CustomUser?>(
      onInit: (user) {
        autoPopulate(user.state!);
        interestTitles.sort((a, b) {
          if (interestPreferences.contains(a) &&
              !interestPreferences.contains(b)) {
            return -1;
          } else if ((interestPreferences.contains(a) &&
                  interestPreferences.contains(b)) ||
              (!interestPreferences.contains(a) &&
                  !interestPreferences.contains(b))) {
            return 0;
          }
          return 1;
        });
        personalityTitles.sort((a, b) {
          if (personalityPreferences.contains(a) &&
              !personalityPreferences.contains(b)) {
            return -1;
          } else if ((personalityPreferences.contains(a) &&
                  personalityPreferences.contains(b)) ||
              (!personalityPreferences.contains(a) &&
                  !personalityPreferences.contains(b))) {
            return 0;
          }
          return 1;
        });
      },
      builder: (context, user) => DraggableScrollableSheet(
        expand: true,
        initialChildSize: 0.98, // adjust as needed
        minChildSize: 0.6, // minimum size when fully collapsed
        maxChildSize: 0.98,
        builder: (context, scroll) => Scaffold(
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Filter by Preferences',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              leading: const SizedBox(),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close_rounded)),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: Text(
                        'Personal Preferences',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
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
                            setState(() {});
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
                            setState(() {});
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
                        'Gender',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
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
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          menuMaxHeight:
                              MediaQuery.of(context).size.height * 0.5,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          isExpanded: true,
                          underline: const SizedBox(),
                          style: Theme.of(context).textTheme.bodyMedium,
                          value: genderPreference,
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
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                              constraints: const BoxConstraints(maxWidth: 100),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: '18',
                              labelStyle:
                                  Theme.of(context).textTheme.labelMedium,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          controller: minAge,
                          style: Theme.of(context).textTheme.bodyMedium,
                          onEditingComplete: () {
                            setState(() {
                              ageRange = RangeValues(double.parse(minAge.text),
                                  double.parse(maxAge.text));
                            });
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              constraints: const BoxConstraints(maxWidth: 100),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: '80',
                              labelStyle:
                                  Theme.of(context).textTheme.labelMedium,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          controller: maxAge,
                          style: Theme.of(context).textTheme.bodyMedium,
                          onEditingComplete: () {
                            setState(() {
                              ageRange = RangeValues(double.parse(minAge.text),
                                  double.parse(maxAge.text));
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      constraints: const BoxConstraints(maxHeight: 45),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButton<String>(
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          menuMaxHeight:
                              MediaQuery.of(context).size.height * 0.5,
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
                                  !languagePreference.contains(value)) {
                                languagePreference.add(value);
                              }
                            });
                          }),
                    ),
                    languagePreference.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                            child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: languagePreference.map((e) {
                                  return RawChip(
                                    showCheckmark: false,
                                    onPressed: () {
                                      setState(() {
                                        languagePreference.remove(e);
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      constraints: const BoxConstraints(maxHeight: 45),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButton<String>(
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          menuMaxHeight:
                              MediaQuery.of(context).size.height * 0.5,
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
                                  !religionPreferences.contains(value)) {
                                religionPreferences.add(value);
                              }
                            });
                          }),
                    ),
                    religionPreferences.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                            child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: religionPreferences.map((e) {
                                  return RawChip(
                                    showCheckmark: false,
                                    onPressed: () {
                                      setState(() {
                                        religionPreferences.remove(e);
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
                                icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded),
                                underline: const SizedBox(),
                                style: Theme.of(context).textTheme.bodyMedium,
                                value: maxHeightFeet == -1
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
                                    maxHeightFeet = value == 'Select'
                                        ? -1
                                        : int.parse(value!);
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
                                icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded),
                                underline: const SizedBox(),
                                style: Theme.of(context).textTheme.bodyMedium,
                                value: maxHeightInch == -1
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
                                    maxHeightInch = value == 'Select'
                                        ? -1
                                        : int.parse(value!);
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
                                icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded),
                                underline: const SizedBox(),
                                style: Theme.of(context).textTheme.bodyMedium,
                                value: minHeightFeet == -1
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
                                    minHeightFeet = value == 'Select'
                                        ? -1
                                        : int.parse(value!);
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
                                icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded),
                                underline: const SizedBox(),
                                style: Theme.of(context).textTheme.bodyMedium,
                                value: minHeightInch == -1
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
                                    minHeightInch = value == 'Select'
                                        ? -1
                                        : int.parse(value!);
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    const Divider(thickness: 0.3),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        'Career Preferences',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'What are your highest level of education preferences?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
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
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          menuMaxHeight:
                              MediaQuery.of(context).size.height * 0.5,
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
                                  !highestEducationPreference.contains(value)) {
                                highestEducationPreference.add(value);
                              }
                            });
                          }),
                    ),
                    highestEducationPreference.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                            child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: highestEducationPreference.map((e) {
                                  return RawChip(
                                    showCheckmark: false,
                                    onPressed: () {
                                      setState(() {
                                        highestEducationPreference.remove(e);
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      constraints: const BoxConstraints(maxHeight: 45),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButton<String>(
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          menuMaxHeight:
                              MediaQuery.of(context).size.height * 0.5,
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
                                  !fieldOfStudyPreferences.contains(value)) {
                                fieldOfStudyPreferences.add(value);
                              }
                            });
                          }),
                    ),
                    fieldOfStudyPreferences.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                            child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: fieldOfStudyPreferences.map((e) {
                                  return RawChip(
                                    showCheckmark: false,
                                    onPressed: () {
                                      setState(() {
                                        fieldOfStudyPreferences.remove(e);
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
                        'Occupation Preferences',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
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
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          menuMaxHeight:
                              MediaQuery.of(context).size.height * 0.5,
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
                                  !occupationPreferences.contains(value)) {
                                occupationPreferences.add(value);
                              }
                            });
                          }),
                    ),
                    occupationPreferences.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                            child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: occupationPreferences.map((e) {
                                  return RawChip(
                                    showCheckmark: false,
                                    onPressed: () {
                                      setState(() {
                                        occupationPreferences.remove(e);
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
                    const SizedBox(height: 35),
                    const Divider(thickness: 0.3),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        'Interests & Lifestyle Preferences',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text('What are your interests?',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                            spacing: 5,
                            children: interestTitles.take(10).map((e) {
                              return RawChip(
                                backgroundColor:
                                    Theme.of(context).colorScheme.onBackground,
                                label: Text(
                                  e,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                                selected: interestPreferences.contains(e),
                                onSelected: (value) {
                                  setState(() {
                                    if (interestPreferences.contains(e)) {
                                      interestPreferences.remove(e);
                                    } else {
                                      interestPreferences.add(e);
                                    }
                                    store.dispatch(UpdateInterestPreference(
                                        interestPreferences));
                                  });
                                },
                              );
                            }).toList())),
                    RawChip(
                      backgroundColor:
                          Theme.of(context).colorScheme.onBackground,
                      label: Text(
                        'See More',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const InterestDetails(isPreferences: true)));
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      constraints: const BoxConstraints(maxHeight: 45),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButton<String>(
                          dropdownColor: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          menuMaxHeight:
                              MediaQuery.of(context).size.height * 0.5,
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
                                  !foodLifestylePreferences.contains(value)) {
                                foodLifestylePreferences.add(value);
                              }
                            });
                          }),
                    ),
                    foodLifestylePreferences.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                            child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: foodLifestylePreferences.map((e) {
                                  return RawChip(
                                    showCheckmark: false,
                                    onPressed: () {
                                      setState(() {
                                        foodLifestylePreferences.remove(e);
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
                    const SizedBox(height: 35),
                    const Divider(thickness: 0.3),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        'Personality Preferences',
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
                                backgroundColor:
                                    Theme.of(context).colorScheme.onBackground,
                                label: Text(
                                  e,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                                selected: personalityPreferences.contains(e),
                                onSelected: (value) {
                                  setState(() {
                                    if (personalityPreferences.contains(e)) {
                                      personalityPreferences.remove(e);
                                    } else {
                                      personalityPreferences.add(e);
                                    }
                                    store.dispatch(UpdatePersonalityPreferences(
                                        personalityPreferences));
                                  });
                                },
                              );
                            }).toList())),
                    RawChip(
                      backgroundColor:
                          Theme.of(context).colorScheme.onBackground,
                      label: Text(
                        'See More',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const PersonalityDetails(isPreference: true)));
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SizedBox(
              height: 68,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 300,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white),
                        ),
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Reset",
                              style: Theme.of(context).textTheme.bodyMedium,
                            )),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GradientButton(
                        enable: true,
                        label: 'Apply',
                        onTap: submit,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
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
