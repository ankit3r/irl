import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/registration/registration_gender.dart';
import 'package:irl/widgets/gradient_button.dart';
import 'package:irl/main.dart';

class RegistrationLocation extends StatefulWidget {
  const RegistrationLocation({super.key});

  @override
  State<RegistrationLocation> createState() => _RegistrationLocationState();
}

class _RegistrationLocationState extends State<RegistrationLocation> {
  String? countryValue;
  String? stateValue;
  String? cityValue;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading?const Center(child: CircularProgressIndicator(),):Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Where do\nyou live?',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.7,
                    child: CSCPicker(
                      layout: Layout.vertical,
                      flagState: CountryFlag.DISABLE,
                      citySearchPlaceholder: 'City',
                      stateSearchPlaceholder: 'State',
                      countrySearchPlaceholder: 'Country',
                      onCountryChanged: (value){
                        setState(() {
                          countryValue=value;
                        });
                      },
                      onStateChanged: (value){
                        setState(() {
                          stateValue=value;
                        });
                      },
                      onCityChanged: (value){
                        setState(() {
                          cityValue=value;
                        });
                      },
                      currentCity: cityValue,
                      currentState: stateValue,
                      currentCountry: countryValue,
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
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    "Add your current location for a better experience.",
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
      floatingActionButton: GradientButton(
        enable: countryValue != null &&
            stateValue != null &&
            cityValue != null &&
            countryValue != 'Country' &&
            stateValue != 'State' &&
            cityValue != 'City',
        label: 'Next',
        onTap: () async {
          try{
              setState(() {
                isLoading = true;
              });
              store.dispatch(UpdateCurrentAddress(countryValue!, cityValue!, stateValue!));
              setState(() {
                isLoading = false;
              });
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegistrationGender()));
          }
          catch(e){
            setState(() {
              isLoading = false;
            });
            if(context.mounted){
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(e.toString())));
            }
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}