import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/registration/registration_location.dart';
import 'package:irl/widgets/gradient_button.dart';
import 'package:irl/main.dart';

class RegistrationDOB extends StatefulWidget {
  const RegistrationDOB({super.key});

  @override
  State<RegistrationDOB> createState() => _RegistrationDOBState();
}

class _RegistrationDOBState extends State<RegistrationDOB> {
  String selectedDay = '1';
  String selectedMonth = '1';
  String selectedYear = '2023';

  final List<String> days =
      List.generate(31, (index) => (index + 1).toString());
  final List<String> months =
      List.generate(12, (index) => (index + 1).toString());
  final List<String> years =
      List.generate(100, (index) => (2023 - index).toString());
  bool isLoading = false;
  bool isEligible = true;

  int calculateAge(int birthYear, int birthMonth, int birthDay) {
    DateTime currentDate = DateTime.now();
    DateTime birthDate = DateTime(birthYear, birthMonth, birthDay);
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: StoreBuilder<CustomUser?>(
        onInit: (store) {
          if (store.state!.dateOfBirth != null) {
            selectedDay = store.state!.dateOfBirth!.day.toString();
            selectedMonth = store.state!.dateOfBirth!.month.toString();
            selectedYear = store.state!.dateOfBirth!.year.toString();
          }
        },
        builder: (context, user) => isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                appBar: AppBar(
                  leading: const SizedBox(),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          'What is your date of birth?',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Day',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      DropdownButton<String>(
                                        dropdownColor: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius: BorderRadius.circular(10),
                                        menuMaxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        underline: const SizedBox(),
                                        value: selectedDay,
                                        items: days.map((String day) {
                                          return DropdownMenuItem<String>(
                                            value: day,
                                            child: Text(
                                              day,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedDay = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Month',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      DropdownButton<String>(
                                        dropdownColor: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius: BorderRadius.circular(10),
                                        menuMaxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        underline: const SizedBox(),
                                        value: selectedMonth,
                                        items: months.map((String month) {
                                          return DropdownMenuItem<String>(
                                            value: month,
                                            child: Text(
                                              month,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedMonth = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Year',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      DropdownButton<String>(
                                        dropdownColor: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius: BorderRadius.circular(10),
                                        menuMaxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        underline: const SizedBox(),
                                        value: selectedYear,
                                        items: years.map((String year) {
                                          return DropdownMenuItem<String>(
                                            value: year,
                                            child: Text(
                                              year,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedYear = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: !isEligible ? 10 : 0,
                            ),
                            !isEligible
                                ? Text('Users should be above 18 years',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error))
                                : const SizedBox(),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
                floatingActionButton: GradientButton(
                  label: 'Next',
                  onTap: () async {
                    try {
                      DateTime dateTime = DateTime(int.parse(selectedYear),
                          int.parse(selectedMonth), int.parse(selectedDay));
                      if (calculateAge(
                              dateTime.year, dateTime.month, dateTime.day) <
                          18) {
                        setState(() {
                          isEligible = false;
                        });
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        store.dispatch(UpdateDateOfBirth(dateTime));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Selected Date: ${DateFormat('yyyy-MM-dd').format(dateTime)}'), // Formatting the date
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const RegistrationLocation()));
                      }
                    } catch (e) {
                      setState(() {
                        isLoading = false;
                      });
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              ),
      ),
    );
  }
}
