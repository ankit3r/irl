import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:irl/main.dart';

enum FieldType { DATE, NETWORK }

class CustomUser {
  String? uid;
  String? fullName;
  String? bio;
  String? phoneNumber;
  String? email;
  DateTime? dateOfBirth;
  String? gender;
  String? address;
  String? currentAddressCountry;
  String? currentAddressState;
  String? currentAddressCity;
  String? homeCountry;
  String? homeState;
  String? homeCity;
  String? maritalStatus;
  int? heightFeet;
  int? heightInch;
  String? religion;
  List<String>? language;
  String? highestEducation;
  String? fieldOfStudy;
  String? occupation;
  List<String>? interests;
  String? smoke;
  String? drink;
  List<String>? relationshipType;
  String? foodLifestyle;
  List<String>? personalityType;
  String? genderPreference;
  int? minAgePreference;
  int? maxAgePreference;
  double? heightPreference;
  List<String>? languagePreference;
  List<String>? religionPreference;
  List<String>? highestEducationPreference;
  List<String>? fieldOfStudyPreference;
  List<String>? occupationPreference;
  List<String>? interestPreference;
  List<String>? foodLifestylePreference;
  List<String>? personalityPreference;
  int? minHeightFeet;
  int? maxHeightFeet;
  int? minHeightInch;
  int? maxHeightInch;
  String? profileImage;
  String? profileImagePath;
  FieldType? fieldType; // Add the enum property here

  CustomUser(
      {this.uid,
      this.fullName,
      this.bio,
      this.phoneNumber,
      this.email,
      this.dateOfBirth,
      this.gender,
      this.address,
      this.currentAddressCountry,
      this.currentAddressState,
      this.currentAddressCity,
      this.homeCountry,
      this.homeState,
      this.homeCity,
      this.maritalStatus,
      this.heightFeet,
      this.heightInch,
      this.religion,
      this.language,
      this.highestEducation,
      this.fieldOfStudy,
      this.occupation,
      this.interests,
      this.smoke,
      this.drink,
      this.relationshipType,
      this.foodLifestyle,
      this.personalityType,
      this.genderPreference,
      this.minAgePreference,
      this.maxAgePreference,
      this.heightPreference,
      this.languagePreference,
      this.religionPreference,
      this.highestEducationPreference,
      this.fieldOfStudyPreference,
      this.occupationPreference,
      this.interestPreference,
      this.foodLifestylePreference,
      this.personalityPreference,
      this.minHeightInch,
      this.minHeightFeet,
      this.maxHeightFeet,
      this.maxHeightInch,
      this.profileImage,
      this.profileImagePath,
      this.fieldType}); // Add the enum property here

  factory CustomUser.fromJSON(Map<String, dynamic> json) {
    List<dynamic>? languageMap =
        json.containsKey('language') ? json['language'] : null;
    List<String>? language = languageMap?.map((e) => e.toString()).toList();

    // Parsing the enum from the JSON
    FieldType? fieldType;
    if (json.containsKey('fieldType')) {
      try {
        String fieldTypeString = json['fieldType'];
        fieldType = FieldType.values.firstWhere((e) =>
            e.toString().split('.').last.toUpperCase() ==
            fieldTypeString.toUpperCase());
      } catch (e) {
        fieldType = null;
      }
    }

    return CustomUser(
      uid: json['uid'] as String?,
      fullName: json['fullName'] as String?,
      bio: json['bio'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      dateOfBirth: json.containsKey('dateOfBirth')
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      currentAddressCountry: json['currentAddressCountry'] as String?,
      currentAddressCity: json['currentAddressCity'] as String?,
      currentAddressState: json['currentAddressState'] as String?,
      homeCity: json['homeCity'] as String?,
      homeCountry: json['homeCountry'] as String?,
      homeState: json['homeState'] as String?,
      maritalStatus: json['maritalStatus'] as String?,
      heightFeet: json.containsKey('heightFeet') && json['heightFeet'] != 'null'
          ? int.tryParse(json['heightFeet'].toString())
          : null,
      heightInch: json.containsKey('heightInch') && json['heightInch'] != 'null'
          ? int.tryParse(json['heightInch'].toString())
          : null,
      religion: json['religion'] as String?,
      language: language,
      highestEducation: json['highestEducation'] as String?,
      fieldOfStudy: json['fieldOfStudy'] as String?,
      occupation: json['occupation'] as String?,
      interests: json.containsKey('interests')
          ? List<String>.from(json['interests'])
          : null,
      smoke: json['smoke'] as String?,
      drink: json['drink'] as String?,
      relationshipType: json.containsKey('relationshipType')
          ? List<String>.from(json['relationshipType'])
          : null,
      foodLifestyle: json['foodLifestyle'] as String?,
      personalityType: json.containsKey('personalityType')
          ? List<String>.from(json['personalityType'])
          : null,
      genderPreference: json['genderPreference'] as String?,
      minAgePreference: json.containsKey('minAgePreference')
          ? json['minAgePreference'].toInt()
          : null,
      maxAgePreference: json.containsKey('maxAgePreference')
          ? json['maxAgePreference'].toInt()
          : null,
      heightPreference: json.containsKey('heightPreference')
          ? json['heightPreference'].toDouble()
          : null,
      languagePreference: json.containsKey('languagePreference')
          ? List<String>.from(json['languagePreference'])
          : null,
      religionPreference: json.containsKey('religionPreference')
          ? List<String>.from(json['religionPreference'])
          : null,
      highestEducationPreference: json.containsKey('highestEducationPreference')
          ? List<String>.from(json['highestEducationPreference'])
          : null,
      fieldOfStudyPreference: json.containsKey('fieldOfStudyPreference')
          ? List<String>.from(json['fieldOfStudyPreference'])
          : null,
      occupationPreference: json.containsKey('occupationPreference')
          ? List<String>.from(json['occupationPreference'])
          : null,
      interestPreference: json.containsKey('interestPreference')
          ? List<String>.from(json['interestPreference'])
          : null,
      foodLifestylePreference: json.containsKey('foodLifestylePreference')
          ? List<String>.from(json['foodLifestylePreference'])
          : null,
      personalityPreference: json.containsKey('personalityPreference')
          ? List<String>.from(json['personalityPreference'])
          : null,
      profileImage:
          json.containsKey('profileImage') ? json['profileImage'] : null,
      profileImagePath: json.containsKey('profileImagePath')
          ? json['profileImagePath']
          : null,
      fieldType: fieldType, // Initialize the enum property here
    );
  }

  bool checkMandatoryFields() {
    if (uid == null ||
        bio == null ||
        dateOfBirth == null ||
        gender == null ||
        currentAddressCity == null ||
        currentAddressState == null ||
        currentAddressCountry == null ||
        heightFeet == null ||
        heightInch == null ||
        interests == null ||
        interests!.isEmpty ||
        relationshipType == null ||
        personalityType == null ||
        genderPreference == null ||
        minAgePreference == null ||
        maxAgePreference == null ||
        profileImage == null) {
      return false;
    }
    return true;
  }

  bool hasRegistered() {
    if (uid == null ||
        dateOfBirth == null ||
        gender == null ||
        currentAddressCity == null ||
        currentAddressState == null ||
        currentAddressCountry == null ||
        profileImage == null) {
      return false;
    }
    return true;
  }

  CustomUser copyWith(
      {String? uid,
      String? fullName,
      String? bio,
      String? phoneNumber,
      String? email,
      DateTime? dateOfBirth,
      String? gender,
      String? address,
      String? currentAddressCountry,
      String? currentAddressState,
      String? currentAddressCity,
      String? homeCountry,
      String? homeState,
      String? homeCity,
      String? maritalStatus,
      int? heightFeet,
      int? heightInch,
      String? religion,
      List<String>? language,
      String? highestEducation,
      String? fieldOfStudy,
      String? occupation,
      List<String>? interests,
      String? smoke,
      String? drink,
      List<String>? relationshipType,
      String? foodLifestyle,
      List<String>? personalityType,
      String? genderPreference,
      int? minAgePreference,
      int? maxAgePreference,
      double? heightPreference,
      List<String>? languagePreference,
      List<String>? religionPreference,
      List<String>? highestEducationPreference,
      List<String>? fieldOfStudyPreference,
      List<String>? occupationPreference,
      List<String>? interestPreference,
      List<String>? foodLifestylePreference,
      List<String>? personalityPreference,
      int? minHeightFeet,
      int? minHeightInch,
      int? maxHeightFeet,
      int? maxHeightInch,
      String? profileImage,
      String? profileImagePath,
      FieldType? fieldType}) {
    return CustomUser(
        uid: uid ?? this.uid,
        fullName: fullName ?? this.fullName,
        bio: bio ?? this.bio,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        gender: gender ?? this.gender,
        address: address ?? this.address,
        currentAddressCountry:
            currentAddressCountry ?? this.currentAddressCountry,
        currentAddressState: currentAddressState ?? this.currentAddressState,
        currentAddressCity: currentAddressCity ?? this.currentAddressCity,
        homeCountry: homeCountry ?? this.homeCountry,
        homeState: homeState ?? this.homeState,
        homeCity: homeCity ?? this.homeCity,
        maritalStatus: maritalStatus ?? this.maritalStatus,
        heightFeet: heightFeet ?? this.heightFeet,
        heightInch: heightInch ?? this.heightInch,
        religion: religion ?? this.religion,
        language: language ?? this.language,
        highestEducation: highestEducation ?? this.highestEducation,
        fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
        occupation: occupation ?? this.occupation,
        interests: interests ?? this.interests,
        smoke: smoke ?? this.smoke,
        drink: drink ?? this.drink,
        relationshipType: relationshipType ?? this.relationshipType,
        foodLifestyle: foodLifestyle ?? this.foodLifestyle,
        personalityType: personalityType ?? this.personalityType,
        genderPreference: genderPreference ?? this.genderPreference,
        minAgePreference: minAgePreference ?? this.minAgePreference,
        maxAgePreference: maxAgePreference ?? this.maxAgePreference,
        heightPreference: heightPreference ?? this.heightPreference,
        languagePreference: languagePreference ?? this.languagePreference,
        religionPreference: religionPreference ?? this.religionPreference,
        highestEducationPreference:
            highestEducationPreference ?? this.highestEducationPreference,
        fieldOfStudyPreference:
            fieldOfStudyPreference ?? this.fieldOfStudyPreference,
        occupationPreference: occupationPreference ?? this.occupationPreference,
        interestPreference: interestPreference ?? this.interestPreference,
        foodLifestylePreference:
            foodLifestylePreference ?? this.foodLifestylePreference,
        personalityPreference:
            personalityPreference ?? this.personalityPreference,
        minHeightFeet: minHeightFeet ?? this.minHeightFeet,
        minHeightInch: minHeightInch ?? this.minHeightInch,
        maxHeightFeet: maxHeightFeet ?? this.maxHeightFeet,
        maxHeightInch: maxHeightInch ?? this.maxHeightInch,
        profileImage: profileImage ?? this.profileImage,
        profileImagePath: profileImagePath ?? this.profileImagePath,
        fieldType:
            fieldType ?? this.fieldType); // Handle the enum property here
  }

  static fromJson(data) {}
}

class CreateUserAction {
  final CustomUser user;
  CreateUserAction(this.user);
}

class CreateUserErrorAction {
  final String errorMessage;
  CreateUserErrorAction(this.errorMessage);
}

class UpdateUID {
  final String uid;
  UpdateUID({required this.uid});
}

class UpdateUserNameAction {
  final String firstName;
  final String lastName;
  UpdateUserNameAction(this.firstName, this.lastName);
}

class UpdatePhoneNumber {
  final String phoneNumber;
  UpdatePhoneNumber(this.phoneNumber);
}

class UpdateDateOfBirth {
  final DateTime dateOfBirth;
  UpdateDateOfBirth(this.dateOfBirth);
}

class UpdateCurrentAddress {
  final String currentAddressCountry;
  final String currentAddressState;
  final String currentAddressCity;
  UpdateCurrentAddress(this.currentAddressCountry, this.currentAddressCity,
      this.currentAddressState);
}

class UpdateGender {
  final String gender;
  UpdateGender(this.gender);
}

class UpdateProfileImage {
  final String profileImage;
  UpdateProfileImage(this.profileImage);
}

class UpdateProfileImagePath {
  final String profileImagePath;
  UpdateProfileImagePath(this.profileImagePath);
}

class UpdatePersonalDetails {
  final String fullName;
  final String? email;
  final String bio;
  final String gender;
  final String? maritalStatus;
  final String currentAddressCountry;
  final String currentAddressState;
  final String currentAddressCity;
  final String? homeCity;
  final String? homeState;
  final String? homeCountry;
  final int? heightFeet;
  final int? heightInch;
  final String? religion;
  final List<String>? language;
  final FieldType? fieldType;

  UpdatePersonalDetails({
    required this.fullName,
    this.email,
    required this.bio,
    required this.gender,
    this.maritalStatus,
    required this.currentAddressCountry,
    required this.currentAddressState,
    required this.currentAddressCity,
    this.homeCity,
    this.homeState,
    this.homeCountry,
    this.heightFeet,
    this.heightInch,
    this.religion,
    this.language,
    this.fieldType,
  });
}

class UpdateCareerDetails {
  final String? highestEducation;
  final String? fieldOfStudy;
  final String? occupation;
  UpdateCareerDetails(
      this.highestEducation, this.fieldOfStudy, this.occupation);
}

class UpdateInterestDetails {
  final List<String>? interests;
  UpdateInterestDetails(this.interests);
}

class UpdateLifestyleDetails {
  final String? smoke;
  final String? drink;
  final List<String>? relationshipType;
  final String? foodChoice;
  final List<String> interests;
  UpdateLifestyleDetails(this.smoke, this.drink, this.relationshipType,
      this.foodChoice, this.interests);
}

class UpdatePersonalityDetails {
  final List<String>? personalityType;
  UpdatePersonalityDetails(this.personalityType);
}

class UpdatePreferenceDetails {
  final String? genderPreference;
  final String? minAge;
  final String? maxAge;
  final int? minHeightFeet;
  final int? minHeightInch;
  final int? maxHeightFeet;
  final int? maxHeightInch;
  final List<String>? languagePreference;
  final List<String>? religionPreferences;
  final List<String>? highestEducationPreference;
  final List<String>? fieldOfStudyPreferences;
  final List<String>? occupationPreferences;
  final List<String>? interestPreferences;
  final List<String>? foodLifestylePreferences;
  final List<String>? personalityPreferences;
  final FieldType? fieldType;
  UpdatePreferenceDetails({
    this.genderPreference,
    this.minAge,
    this.maxAge,
    this.minHeightFeet,
    this.minHeightInch,
    this.maxHeightFeet,
    this.maxHeightInch,
    this.languagePreference,
    this.religionPreferences,
    this.highestEducationPreference,
    this.fieldOfStudyPreferences,
    this.occupationPreferences,
    this.interestPreferences,
    this.foodLifestylePreferences,
    this.personalityPreferences,
    this.fieldType,
  });
}

class UpdateInterestPreference {
  final List<String>? interestPreference;
  UpdateInterestPreference(this.interestPreference);
}

class UpdatePersonalityPreferences {
  final List<String>? personalityPreference;
  UpdatePersonalityPreferences(this.personalityPreference);
}

class ClearUserAction {}

CustomUser? userReducer(CustomUser? user, dynamic action) {
  if (action is CreateUserAction) {
    return action.user;
  }
  if (action is UpdateUID) {
    return user!.copyWith(uid: action.uid);
  }
  if (action is UpdateUserNameAction) {
    return user!.copyWith(
      fullName: '${action.firstName} ${action.lastName}',
    );
  }
  if (action is UpdatePhoneNumber) {
    return user!.copyWith(phoneNumber: action.phoneNumber);
  }
  if (action is UpdateDateOfBirth) {
    return user!.copyWith(dateOfBirth: action.dateOfBirth);
  }
  if (action is UpdateCurrentAddress) {
    return user!.copyWith(
        currentAddressCity: action.currentAddressCity,
        currentAddressCountry: action.currentAddressCountry,
        currentAddressState: action.currentAddressState);
  }
  if (action is UpdateGender) {
    return user!.copyWith(gender: action.gender);
  }
  if (action is UpdateProfileImage) {
    return user!.copyWith(profileImage: action.profileImage);
  }
  if (action is UpdateProfileImagePath) {
    return user!.copyWith(profileImagePath: action.profileImagePath);
  }
  if (action is UpdatePersonalDetails) {
    return user!.copyWith(
        fullName: action.fullName,
        email: action.email,
        bio: action.bio,
        gender: action.gender,
        maritalStatus: action.maritalStatus,
        currentAddressCountry: action.currentAddressCountry,
        currentAddressState: action.currentAddressState,
        currentAddressCity: action.currentAddressCity,
        homeCity: action.homeCity,
        homeState: action.homeState,
        homeCountry: action.homeCountry,
        heightFeet: action.heightFeet,
        heightInch: action.heightInch,
        religion: action.religion,
        language: action.language,
        fieldType: action.fieldType);
  }
  if (action is UpdateCareerDetails) {
    return user!.copyWith(
        highestEducation: action.highestEducation,
        fieldOfStudy: action.fieldOfStudy,
        occupation: action.occupation);
  }
  if (action is UpdateInterestDetails) {
    return user!.copyWith(interests: action.interests);
  }
  if (action is ClearUserAction) {
    return null;
  }
  if (action is UpdateLifestyleDetails) {
    return user!.copyWith(
        smoke: action.smoke,
        drink: action.drink,
        relationshipType: action.relationshipType,
        interests: action.interests,
        foodLifestyle: action.foodChoice);
  }
  if (action is UpdatePersonalityDetails) {
    return user!.copyWith(personalityType: action.personalityType);
  }
  if (action is UpdatePreferenceDetails) {
    return user!.copyWith(
      genderPreference: action.genderPreference,
      minAgePreference: double.parse(action.minAge!).round(),
      maxAgePreference: double.parse(action.maxAge!).round(),
      minHeightFeet: action.minHeightFeet,
      minHeightInch: action.minHeightInch,
      maxHeightFeet: action.maxHeightFeet,
      maxHeightInch: action.maxHeightInch,
      languagePreference: action.languagePreference,
      religionPreference: action.religionPreferences,
      highestEducationPreference: action.highestEducationPreference,
      fieldOfStudyPreference: action.fieldOfStudyPreferences,
      occupationPreference: action.occupationPreferences,
      interestPreference: action.interestPreferences,
      foodLifestylePreference: action.foodLifestylePreferences,
      personalityPreference: action.personalityPreferences,
      fieldType: action.fieldType,
    );
  }
  if (action is UpdateInterestPreference) {
    return user!.copyWith(interestPreference: action.interestPreference);
  }
  if (action is UpdatePersonalityPreferences) {
    return user!.copyWith(personalityPreference: action.personalityPreference);
  }
  return user;
}

Future<Stream<String?>> getProfileImageUrlStream() async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final StreamController<String?> streamController =
      StreamController<String?>();

  FirebaseFirestore.instance.collection('users').doc(userId).snapshots().listen(
      (documentSnapshot) {
    if (documentSnapshot.exists) {
      var userData = documentSnapshot.data() as Map<String, dynamic>;
      String? profileImageUrl = userData['profileImage'];
      streamController.add(profileImageUrl);
    } else {
      streamController.add(null);
    }
  }, onError: (error) {
    streamController.addError('Error fetching document: $error');
  });

  return streamController.stream;
}

void createUser({required String fullName}) {
  try {
    if (fullName.isEmpty) {
      throw Exception('Full name is mandatory.');
    }
    CustomUser user = CustomUser(fullName: fullName);
    store.dispatch(CreateUserAction(user));
  } catch (e) {
    store.dispatch(CreateUserErrorAction(e.toString()));
  }
}
