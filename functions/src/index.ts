/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
// import {QueryDocumentSnapshot} from "firebase-functions/v1/firestore";
// import {QueryDocumentSnapshot} from "firebase-admin/firestore";
// import {QueryDocumentSnapshot}
//   from "firebase-functions/lib/v2/providers/firestore";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

admin.initializeApp();


export const helloWorld = functions.https.onCall(() => {
  functions.logger.info("Hello", {structuredData: true});
  return {msg: "Hello World"};
});

export const getNextUser = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.
      HttpsError("unauthenticated", "Authentication required.");
  }
  try {
    const userId = data.userId as string;

    const query1 = await admin.firestore().collection("swipes")
      .where("swiperId", "==", userId).get();

    const query2 = await admin.firestore().collection("swipes")
      .where("swipedId", "==", userId).where("action", "==", "left").get();

    const notEligibleUsers: string[] = [];
    notEligibleUsers.push(userId);
    query1.forEach((doc) => {
      const swipedId = doc.data().swipedId;
      notEligibleUsers.push(swipedId);
    });

    query2.forEach((doc) => {
      const swiperId = doc.data().swiperId;
      notEligibleUsers.push(swiperId);
    });

    // Fetch the next user who hasn't been swiped or matched yet
    const allUsersSnapshot = await admin.firestore().collection("users")
      .where("uid", "not-in", notEligibleUsers).limit(1).get();

    let nextUser = null;
    allUsersSnapshot.forEach((doc) => {
      nextUser = doc.data();
    });
    return nextUser;
  } catch (error) {
    functions.logger.info(error, {structuredData: true});
    throw new functions.https.
      HttpsError("internal", "Error fetching next user.", error);
  }
});

exports.handleLeftSwipe = functions.https.onCall(async (data) => {
  const {userId, swipedId} = data;
  try {
    await admin.firestore().collection("swipes").add({
      swiperId: userId,
      swipedId: swipedId,
      action: "left",
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {success: true};
  } catch (error) {
    functions.logger.info(error, {structuredData: true});
    return error;
  }
});

exports.handleRightSwipe = functions.https.onCall(async (data) => {
  const {userId, swipedId} = data;
  try {
    await admin.firestore().collection("swipes").add({
      swiperId: userId,
      swipedId: swipedId,
      action: "right",
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    const userSwipedBySwipedUser = await admin.firestore().collection("swipes")
      .where("swiperId", "==", swipedId)
      .where("swipedId", "==", userId)
      .where("action", "==", "right")
      .get();

    let matched = false;
    if (!userSwipedBySwipedUser.empty) {
      matched = true;
      const matchData = {
        user1Id: userId,
        user2Id: swipedId,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      };
      await admin.firestore().collection("matches").add(matchData);
    }
    return matched;
  } catch (error) {
    functions.logger.info(error, {structuredData: true});
    return error;
  }
});
/*
exports.fetchNextUser = functions.https.onCall(async (data, context) => {
  console.log("FNU", context);
  const currentUserId = data.userId;
  try {
    const db = admin.firestore();
    const currentUserDoc = db.collection("users").doc(currentUserId);
    const userDocSnapshot = await currentUserDoc.get();
    if (!userDocSnapshot.exists) {
      return {error: "User not found"};
    }

    // Retrieve user's preferences from the user document
    const userPreferences = userDocSnapshot.data();

    // Check if userPreferences is undefined
    if (!userPreferences) {
      return {error: "User preferences not found"};
    }

    // Check if the user has specified a gender preference
    if (!userPreferences.genderPreference) {
      return {error: "User has not set gender preference"};
    }

    const preferredGender = userPreferences.genderPreference;
    let baseQuery = db.collection("users")
      .where("gender", "==", preferredGender)
      .where("uid", "!=", currentUserId);

    // Add filters based on other preferences
    const minAge = userPreferences.minAgePreference || 18;
    const maxAge = userPreferences.maxAgePreference || 80;
    const minHeightFeet = parseInt(userPreferences.minHeightFeet, 10) || 0;
    const minHeightInch = parseInt(userPreferences.minHeightInch, 10) || 0;
    const maxHeightFeet = parseInt(userPreferences.maxHeightFeet, 10) || 15;
    const maxHeightInch = parseInt(userPreferences.maxHeightInch, 10) || 12;
    baseQuery = baseQuery
      .where("age", ">=", minAge)
      .where("age", "<=", maxAge)
      .where("heightFeet", ">=", minHeightFeet)
      .where("heightFeet", "<=", maxHeightFeet)
      .where("heightInch", ">=", minHeightInch)
      .where("heightInch", "<=", maxHeightInch);

    // Add filter for religionPreferences if it exists
    const religionPreferences = userPreferences.religionPreferences;
    if (religionPreferences && religionPreferences.length > 0) {
      baseQuery = baseQuery.where("religion", "in", religionPreferences);
    }

    const foodLifestylePreferences = userPreferences.foodLifestylePreferences;
    if (foodLifestylePreferences && foodLifestylePreferences.length > 0) {
      baseQuery = baseQuery.where(
        "foodLifestyle", "in", foodLifestylePreferences);
    }

    const occupationPreferences = userPreferences.occupationPreferences;
    if (occupationPreferences && occupationPreferences.length > 0) {
      baseQuery = baseQuery.where("occupation", "in", occupationPreferences);
    }

    const highestEducationPreference = userPreferences
      .highestEducationPreference;
    if (highestEducationPreference && highestEducationPreference.length > 0) {
      baseQuery = baseQuery.where(
        "highestEducation", "in", highestEducationPreference);
    }

    const fieldOfStudyPreferences = userPreferences.fieldOfStudyPreferences;
    if (fieldOfStudyPreferences && fieldOfStudyPreferences.length > 0) {
      baseQuery = baseQuery.where(
        "fieldOfStudy", "in", fieldOfStudyPreferences);
    }

    const notEligibleUserIds = new Set();

    // Get not eligible and liked user IDs
    const notEligibleUsersSnapshot = await currentUserDoc.collection(
      "notEligibleUsers").get();
    const likedUsersSnapshot = await currentUserDoc.collection(
      "likedUsers").get();

    // Add not eligible and liked user IDs to the set
    notEligibleUsersSnapshot.forEach((doc) => notEligibleUserIds.add(doc.id));
    likedUsersSnapshot.forEach((doc) => notEligibleUserIds.add(doc.id));

    // Add current user ID to the se
    notEligibleUserIds.add(currentUserId);

    // Exclude not eligible user IDs from the baseQuery
    notEligibleUserIds.forEach((userId) => {
      baseQuery = baseQuery.where(
        admin.firestore.FieldPath.documentId(), "!=", userId);
    });

    const languagePreferences = userPreferences.languagePreference;
    if (languagePreferences && languagePreferences.length > 0) {
      baseQuery = baseQuery.where(
        "languages", "array-contains-any", languagePreferences);
    }

    // Add filter for interests preferences if it exists
    const interestsPreferences = userPreferences.interests;
    if (interestsPreferences && interestsPreferences.length > 0) {
      baseQuery = baseQuery.where(
        "interests", "array-contains-any", interestsPreferences);
    }

    // Add filter for personalityType preferences if it exists
    const personalityTypePreferences = userPreferences.personalityType;
    if (personalityTypePreferences && personalityTypePreferences.length > 0) {
      baseQuery = baseQuery.where(
        "personalityType", "array-contains-any", personalityTypePreferences);
    }

    // Get a single eligible user
    const eligibleUsersSnapshot = await baseQuery.limit(1).get();

    // If there are no eligible users
    if (eligibleUsersSnapshot.empty) {
      return {message: "No More Users"};
    }

    // Extract the first eligible user from the snapshot
    const nextUserSnapshot = eligibleUsersSnapshot.docs[0];
    const nextUser = {id: nextUserSnapshot.id, ...nextUserSnapshot.data()};

    console.log("NEXT", nextUser);
    return nextUser;
  } catch (error) {
    console.error("Error fetching next user:", error);
    return {error: error.message};
  }
});
*/

// interface UserData {
//   uid: string;
//   // Add other properties here based on your user data structure
// }
exports.fetchNextUser = functions.https.onCall(async (data, context) => {
  console.log("FNU", context);
  const currentUserId = data.userId;
  try {
    const db = admin.firestore();
    const currentUserDoc = db.collection("users").doc(currentUserId);
    const userDocSnapshot = await currentUserDoc.get();
    if (!userDocSnapshot.exists) {
      return {error: "User not found"};
    }

    // Retrieve user's preferences from the user document
    const userPreferences = userDocSnapshot.data();

    // Check if userPreferences is undefined
    if (!userPreferences) {
      return {error: "User preferences not found"};
    }

    // Check if the user has specified a gender preference
    if (!userPreferences.genderPreference) {
      return {error: "User has not set gender preference"};
    }
    const preferredGender = userPreferences.genderPreference;
    let baseQuery = db.collection("users")
      .where("gender", "==", preferredGender)
      .where("uid", "!=", currentUserId);

    // Add filters based on other preferences
    const minAge = userPreferences.minAgePreference || 18;
    const maxAge = userPreferences.maxAgePreference || 80;
    const minHeightFeet = parseInt(userPreferences.minHeightFeet, 10) || 0;
    const minHeightInch = parseInt(userPreferences.minHeightInch, 10) || 0;
    const maxHeightFeet = parseInt(userPreferences.maxHeightFeet, 10) || 15;
    const maxHeightInch = parseInt(userPreferences.maxHeightInch, 10) || 12;
    baseQuery = baseQuery
      .where("age", ">=", minAge)
      .where("age", "<=", maxAge)
      .where("heightFeet", ">=", minHeightFeet)
      .where("heightFeet", "<=", maxHeightFeet)
      .where("heightInch", ">=", minHeightInch)
      .where("heightInch", "<=", maxHeightInch);

    // Add filter for religionPreferences if it exists
    const religionPreferences = userPreferences.religionPreferences;
    if (religionPreferences && religionPreferences.length > 0) {
      baseQuery = baseQuery.where("religion", "in", religionPreferences);
    }

    const foodLifestylePreferences = userPreferences.foodLifestylePreferences;
    if (foodLifestylePreferences && foodLifestylePreferences.length > 0) {
      baseQuery = baseQuery.where(
        "foodLifestyle", "in", foodLifestylePreferences);
    }

    const occupationPreferences = userPreferences.occupationPreferences;
    if (occupationPreferences && occupationPreferences.length > 0) {
      baseQuery = baseQuery.where("occupation", "in", occupationPreferences);
    }

    const highestEducationPreference = userPreferences
      .highestEducationPreference;
    if (highestEducationPreference && highestEducationPreference.length > 0) {
      baseQuery = baseQuery.where(
        "highestEducation", "in", highestEducationPreference);
    }

    const fieldOfStudyPreferences = userPreferences.fieldOfStudyPreferences;
    if (fieldOfStudyPreferences && fieldOfStudyPreferences.length > 0) {
      baseQuery = baseQuery.where(
        "fieldOfStudy", "in", fieldOfStudyPreferences);
    }

    // Define an array to store the results of each query
    const queryResults = [];

    // Add filter for language preferences if it exists
    const languagePreferences = userPreferences.languagePreference;
    if (languagePreferences && languagePreferences.length > 0) {
      const languageQuery = baseQuery.where(
        "languages", "array-contains-any", languagePreferences);
      queryResults.push(languageQuery.get());
    }

    // Add filter for interests preferences if it exists
    const interestsPreferences = userPreferences.interests;
    if (interestsPreferences && interestsPreferences.length > 0) {
      const interestsQuery = baseQuery.where(
        "interests", "array-contains-any", interestsPreferences);
      queryResults.push(interestsQuery.get());
    }

    // Add filter for personality type preferences if it exists
    const personalityTypePreferences = userPreferences.personalityType;
    if (personalityTypePreferences && personalityTypePreferences.length > 0) {
      const personalityTypeQuery = baseQuery.where(
        "personalityType", "array-contains-any", personalityTypePreferences);
      queryResults.push(personalityTypeQuery.get());
    }


    // Wait for all queries to resolve
    const snapshots = await Promise.all(queryResults);
    const eligibleUsers: admin.firestore.DocumentData[] = [];
    snapshots.forEach((querySnapshot) => {
      querySnapshot.forEach((doc) => {
        eligibleUsers.push(doc.data());
      });
    });

    const notEligibleUsersSnapshot = await currentUserDoc.collection(
      "notEligibleUsers").get();
    const likedUsersSnapshot = await currentUserDoc.collection(
      "likedUsers").get();

    // Combine not eligible and liked user IDs
    const combinedUserIds = new Set();
    notEligibleUsersSnapshot.forEach((doc) => combinedUserIds.add(doc.id));
    likedUsersSnapshot.forEach((doc) => combinedUserIds.add(doc.id));
    combinedUserIds.add(currentUserId); // Add current user ID

    // Exclude combinedUserIds from the eligible users
    const filteredUsers = eligibleUsers.filter(
      (user) => !combinedUserIds.has(user.uid));

    // Randomly select a user from the filtered list of eligible users
    const nextUser = filteredUsers[Math.floor(
      Math.random() * filteredUsers.length)];
    console.log("NEXT", nextUser);
    return nextUser;
  } catch (error) {
    console.error("Error fetching next user:", error);
    return {error: error};
  }
});
exports.onSwipe = functions.https.onCall(async (data) => {
  const {currentUserId, swipedId, action} = data;
  try {
    if (action === "left") {
      const result = await leftSwipe(currentUserId, swipedId);
      return result;
    } else if (action === "right") {
      const matchResult = await rightSwipe(currentUserId, swipedId);
      return matchResult;
    } else {
      return {error: "Invalid action specified!"};
    }
  } catch (error) {
    return {error};
  }
});


/**
 * Handles the left swipe action.
 * @param {string} currentUserId - The ID of the current user
 * @param {string} swipedId - The ID of the user being swiped left.
 * @return {Promise<Object>} A message indicating the result
 */
async function leftSwipe(currentUserId:string, swipedId:string) {
  const db = admin.firestore();
  const currentUserDoc = db.collection("users").doc(currentUserId);
  const swipedUserDoc = db.collection("users").doc(swipedId);
  await currentUserDoc.collection("notEligibleUsers").doc(swipedId).set({
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
  });
  await swipedUserDoc.collection("notEligibleUsers").doc(currentUserId).set({
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
  });
  return {message: "SUCCESS_LEFT"};
}


/**
 * Handles the right swipe action.
 * @param {string} currentUserId - The ID of the current user
 * @param {string} swipedId - The ID of the user being swiped left.
 * @return {Promise<Object>} A message indicating the result
 */
async function rightSwipe(currentUserId:string, swipedId:string) {
  const db = admin.firestore();
  const currentUserDoc = db.collection("users").doc(currentUserId);
  const swipedUserDoc = db.collection("users").doc(swipedId);
  const likedByRef = currentUserDoc.collection("likedBy").doc(swipedId);
  const likedBySnapshot = await likedByRef.get();
  if (likedBySnapshot.exists) {
    await Promise.all([
      swipedUserDoc.collection("matchedUsers").doc(currentUserId).set({
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      }),
      currentUserDoc.collection("matchedUsers").doc(swipedId).set({
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      }),
      currentUserDoc.collection("likedUsers").doc(swipedId).set({
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      }),
      swipedUserDoc.collection("likedBy").doc(currentUserId).set({
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      }),
    ]);
    return {message: "SUCCESS_MATCH"};
  } else {
    await Promise.all([
      currentUserDoc.collection("likedUsers").doc(swipedId).set({
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      }),
      swipedUserDoc.collection("likedBy").doc(currentUserId).set({
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      }),
    ]);
    return {message: "SUCCESS_RIGHT"};
  }
}


exports.checkUserExist = functions.https.onCall( async (data, context) => {
  try {
    if (!context.auth) {
      throw new functions.
        https.HttpsError("unauthenticated", "Authentication required.");
    }
    const phoneNumber = data.phoneNumber;
    const userSnapshot = await admin.firestore()
      .collection("users")
      .where("phoneNumber", "==", phoneNumber)
      .get();
    if (userSnapshot.empty) {
      return false;
    } else {
      return true;
    }
  } catch (error) {
    console.error("Error:", error);
    throw new functions.
      https
      .HttpsError("internal",
        "An error occurred while checking user existence.");
  }
});
