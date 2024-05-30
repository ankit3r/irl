import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:irl/firebase_options.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/getting_started.dart';
import 'package:irl/screens/home.dart';
import 'package:irl/screens/index.dart';
import 'package:irl/screens/login.dart';
import 'package:irl/screens/profile/career_details.dart';
import 'package:irl/screens/profile/lifestyle_details.dart';
import 'package:irl/screens/profile/preference_details.dart';
import 'package:irl/screens/profile/profile_index.dart';
import 'package:irl/screens/registration/registration_dob.dart';
import 'package:irl/screens/registration/registration_location.dart';
import 'package:irl/screens/registration/selfie_verification/click_photo.dart';
import 'package:irl/screens/registration/waitlist.dart';
import 'package:irl/screens/settings/settings_index.dart';
import 'package:irl/screens/splash_screen.dart';
import 'package:redux/redux.dart';
import 'screens/registration/registration_name.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:irl/screens/registration/registration_gender.dart';
import 'package:irl/screens/registration/registration_picture.dart';

final store = Store<CustomUser?>(
  userReducer,
  initialState: null,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  runApp(IRL(store: store));
}

class IRL extends StatelessWidget {
  final Store<CustomUser?> store;
  const IRL({super.key, required this.store});
  @override
  Widget build(BuildContext context) {
    return StoreProvider<CustomUser?>(
      store: store,
      child: MaterialApp(
        title: 'In Real Life',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            cardColor: const Color(0xFF21292E),
            dialogBackgroundColor: const Color(0xFF21292E),
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Color(0xFF11171A),
              surfaceTintColor: Color(0xFF11171A),
              modalBackgroundColor: Color(0xFF11171A),
            ),
            chipTheme: ChipThemeData(
              labelStyle: Theme.of(context).textTheme.bodySmall,
            ),
            appBarTheme: AppBarTheme(
                titleTextStyle: Theme.of(context).textTheme.bodyLarge,
                backgroundColor: Colors.black,
                surfaceTintColor: Colors.black),
            snackBarTheme: SnackBarThemeData(
              backgroundColor: const Color(0xFF21292E),
              actionTextColor: const Color(0xFFCFD1D1),
              contentTextStyle:
                  GoogleFonts.urbanist(fontSize: 12, color: Colors.white),
            ),
            scaffoldBackgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Color(0xFFCFD1D1)),
            switchTheme: const SwitchThemeData(
                thumbColor: MaterialStatePropertyAll<Color>(Colors.white)),
            colorScheme: const ColorScheme(
              background: Colors.black,
              onPrimary: Color(0xFF4F5DF0),
              onSecondary: Color(0xFFDB7E80),
              brightness: Brightness.dark,
              error: Colors.red,
              onBackground: Color(0xFF11171A),
              onError: Colors.red,
              onSurface: Color(0xFFCFD1D1),
              primary: Color(0xFF4F5DF0),
              surface: Color(0xFF21292E),
              secondary: Color(0xFFDB7E80),
              tertiary: Color(0xFF21292E),
              outline: Color(0xFF21292E),
              onPrimaryContainer: Colors.white,
            ),
            primaryColor: const Color(0xFF4F5DF0),
            useMaterial3: true,
            textTheme: TextTheme(
              titleLarge: GoogleFonts.urbanist(
                  fontSize: 35,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
              titleMedium: GoogleFonts.urbanist(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
              titleSmall: GoogleFonts.urbanist(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
              displayLarge: GoogleFonts.urbanist(
                  fontSize: 28,
                  fontWeight: FontWeight.w200,
                  color: Colors.white),
              displayMedium: GoogleFonts.urbanist(
                  fontSize: 23,
                  fontWeight: FontWeight.w200,
                  color: Colors.white),
              displaySmall: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  color: Colors.white),
              bodyLarge:
                  GoogleFonts.urbanist(fontSize: 20, color: Colors.white),
              bodyMedium:
                  GoogleFonts.urbanist(fontSize: 16, color: Colors.white),
              bodySmall:
                  GoogleFonts.urbanist(fontSize: 12, color: Colors.white),
              labelLarge:
                  GoogleFonts.urbanist(fontSize: 16, color: Colors.grey),
              labelMedium:
                  GoogleFonts.urbanist(fontSize: 14, color: Colors.grey),
              labelSmall:
                  GoogleFonts.urbanist(fontSize: 12, color: Colors.grey),
            )),
        // home: const SplashScreen(),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/index': (context) => const Wrapper(),
          '/home': (context) => const Home(),
          '/splashScreen': (context) => const SplashScreen(),
          '/gettingStarted': (context) => const GettingStarted(),
          '/login': (context) => const LoginScreen(),
          '/registrationName': (context) => const RegistrationName(),
          '/registrationDOB': (context) => const RegistrationDOB(),
          '/registrationLocation': (context) => const RegistrationLocation(),
          '/registrationGender': (context) => const RegistrationGender(),
          '/registrationPicture': (context) => const RegistrationPicture(),
          '/profileIndex': (context) => const ProfileIndex(),
          '/careerDetails': (context) => const CareerDetails(),
          '/lifestyleDetails': (context) => const LifestyleDetails(),
          '/preferenceDetails': (context) => const PreferenceDetails()
        },
      ),
    );
  }
}
