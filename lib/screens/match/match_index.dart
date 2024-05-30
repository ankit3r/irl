import 'dart:async';
import 'dart:math';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:irl/models/users.dart';
import 'package:irl/screens/match/preference_sheet.dart';
import 'package:irl/screens/messaging/messages.dart';

class MatchIndex extends StatefulWidget {
  const MatchIndex({super.key});

  @override
  State<MatchIndex> createState() => _MatchIndexState();
}

class _MatchIndexState extends State<MatchIndex> {
  CustomUser? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNextUser();
  }

  Future<void> fetchNextUser() async {
    try {
      // Get the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Call the Cloud Function with user ID and preferences
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('fetchNextUser');
      final response = await callable.call({
        'userId': userId,
      });

      // Handle the response from the Cloud Function
      setState(() {
        if (response.data == null || response.data == {}) {
          // No more profiles available
          currentUser = null;
          // Display a message indicating no more profiles
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No more profiles available"),
              // style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        } else {
          // Parse the response data into a CustomUser object
          currentUser = CustomUser.fromJSON(response.data);
        }
        isLoading = false;
      });
    } catch (error) {
      if (context.mounted) {
        // Display an error message if an error occurs
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString(),
                style: Theme.of(context).textTheme.bodySmall),
          ),
        );
      }
      setState(() {
        currentUser = null; // Error occurred
      });
    }
  }

  Future<void> performSwipe(
      String currentUserId, String swipedId, String action) async {
    try {
      setState(() {
        isLoading = true;
      });
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('onSwipe');
      final result = await callable.call({
        'currentUserId': currentUserId,
        'swipedId': swipedId,
        'action': action
      });
      if (result.data['message'] == 'SUCCESS_MATCH' && context.mounted) {
        // Get the matched user data
        final matchedUser = CustomUser.fromJson(result.data['matchedUser']);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              title: Center(
                child: Text(
                  "It's a match!",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width - 60,
                height: MediaQuery.of(context).size.height * 0.30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width - 125,
                        ),
                        Positioned(
                          right: 20,
                          child: ClipOval(
                            child: Image.network(
                              StoreProvider.of<CustomUser?>(context)
                                  .state!
                                  .profileImage!,
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.height * 0.2,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          child: ClipOval(
                            child: Image.network(
                              matchedUser.profileImage!,
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.height * 0.2,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Text(
                      'Looks like you both liked each other\'s profiles!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            );
          },
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ));
      }
      setState(() {
        currentUser = null; // Error occurred
      });
    } finally {
      setState(() {
        isLoading = false; // Set loading state to false
      });
    }
  }

  bool onTap = false;
  void showSendMessage() {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: true,
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      builder: (context) {
        return SizedBox(
          height: onTap
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.network(
                              StoreProvider.of<CustomUser?>(context)
                                  .state!
                                  .profileImage!,
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.height * 0.1,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ClipOval(
                            child: Image.network(
                              currentUser!.profileImage!,
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.height * 0.1,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.height * 0.025,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Create a captivating message to introduce yourself and begin a conversation',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.black),
                      onTapOutside: (pointer) {
                        setState(() {
                          onTap = false;
                        });
                        FocusScope.of(context).unfocus();
                      },
                      onTap: () {
                        setState(() {
                          onTap = true;
                        });
                      },
                      onEditingComplete: () {
                        setState(() {
                          onTap = false;
                        });
                      },
                      minLines: 4,
                      maxLines: 6,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Enter message',
                          labelStyle: Theme.of(context).textTheme.labelMedium,
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.all(13),
                          counterText: ""),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Cancel'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white),
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Send Message',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.black)),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Offset _offset = const Offset(0, 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: null,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Image.asset(
          'assets/images/logo.png',
          height: 60,
          width: 60,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MessagesScreen()));
                },
                icon: const Icon(Icons.inbox_rounded)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height*0.9,
                      maxHeight: MediaQuery.of(context).size.height*0.9,
                    ),
                    enableDrag: true,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    builder: (context) {
                      return const PreferenceSheet(); // Remove the const keyword if PreferenceSheet is a StatefulWidget
                    },
                  ).then((_) {
                    // This block will execute after the bottom sheet is closed
                    fetchNextUser();
                    setState(() {});

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Home page reloaded!'),
                      ),
                    );
                  });
                },
                icon: const Icon(Icons.display_settings_rounded)),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentUser != null
              ? SingleChildScrollView(
                  child: Padding(
                  padding: const EdgeInsets.all(23.0),
                  child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _offset += details.delta;
                        });
                      },
                      onPanEnd: (_) {
                        if (_offset.dx > 100) {
                          performSwipe(FirebaseAuth.instance.currentUser!.uid,
                                  currentUser!.uid!, 'right')
                              .then((value) {
                            fetchNextUser();
                          });
                        } else if (_offset.dx < -100) {
                          performSwipe(FirebaseAuth.instance.currentUser!.uid,
                                  currentUser!.uid!, 'left')
                              .then((value) {
                            fetchNextUser();
                          });
                        }
                        setState(() {
                          _offset = Offset.zero;
                        });
                      },
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          transform:
                              Matrix4.translationValues(_offset.dx, 0, 0),
                          child: UserDetailsCard(
                            user: currentUser!,
                          ))),
                ))
              : const Center(child: Text('No more users')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: currentUser != null
          ? Padding(
              padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      performSwipe(FirebaseAuth.instance.currentUser!.uid,
                              currentUser!.uid!, 'left')
                          .then((value) {
                        fetchNextUser();
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      radius: 20,
                      child: const Icon(
                        Icons.close_rounded,
                        size: 22,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: () {
                      performSwipe(FirebaseAuth.instance.currentUser!.uid,
                              currentUser!.uid!, 'right')
                          .then((value) {
                        fetchNextUser();
                      });
                    },
                    child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
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
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(Icons.favorite_border_rounded, size: 32),
                        )),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      showSendMessage();
                    },
                    child: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        radius: 20,
                        child: Icon(
                          Icons.send_rounded,
                          size: 22,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }
}

class UserDetailsCard extends StatefulWidget {
  final CustomUser user;

  const UserDetailsCard({super.key, required this.user});

  @override
  State<UserDetailsCard> createState() => _UserDetailsCardState();
}

class _UserDetailsCardState extends State<UserDetailsCard> {
  Widget showPersonalDetails(BuildContext context) {
    List<Widget> bio = [],
        maritalStatus = [],
        home = [],
        religion = [],
        languages = [];
    if (widget.user.bio != null) {
      bio = [
        Text(
          "About",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(widget.user.bio!),
      ];
    }
    if (widget.user.maritalStatus != null) {
      maritalStatus = [
        const SizedBox(
          height: 20,
        ),
        Text(
          "Status",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(widget.user.maritalStatus!),
      ];
    }
    if (widget.user.homeCity != null) {
      home = [
        const SizedBox(
          height: 20,
        ),
        Text(
          "Home",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text("${widget.user.homeCity}, ${widget.user.homeState}"),
      ];
    }
    if (widget.user.religion != null) {
      religion = [
        const SizedBox(
          height: 20,
        ),
        Text(
          "Religion",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(widget.user.religion!),
      ];
    }
    if (widget.user.language != null) {
      String result = "";
      widget.user.language!.map((e) {
        result = '$result$e,';
      });
      if (result.isNotEmpty) {
        result = result.substring(0, result.length - 1);
        languages = [
          const SizedBox(
            height: 15,
          ),
          Text(
            "Languages",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(result)
        ];
      }
    }
    return Container(
        padding: const EdgeInsets.all(15.0),
        width: MediaQuery.of(context).size.width - 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...bio,
            ...maritalStatus,
            ...home,
            ...religion,
            ...languages
          ],
        ));
  }

  Widget showInterests(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      width: MediaQuery.of(context).size.width - 46,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Interests",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 76,
          child: Wrap(
            runSpacing: 10,
            spacing: 10,
            runAlignment: WrapAlignment.spaceBetween,
            alignment: WrapAlignment.start,
            children: widget.user.interests!.map((e) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(e, style: Theme.of(context).textTheme.bodySmall),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }

  Widget showLifestyle(BuildContext context) {
    List<Widget> smoke = [], drink = [], food = [], relationship = [];
    if (widget.user.smoke != null) {
      smoke = [
        const SizedBox(
          height: 15,
        ),
        Text(
          "Smokes",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(widget.user.smoke!),
      ];
    }
    if (widget.user.drink != null) {
      drink = [
        const SizedBox(
          height: 15,
        ),
        Text(
          "Drinks",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(widget.user.drink!),
      ];
    }
    if (widget.user.foodLifestyle != null) {
      food = [
        const SizedBox(
          height: 15,
        ),
        Text(
          "Food Lifestyle",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(widget.user.foodLifestyle!),
      ];
    }
    if (widget.user.relationshipType != null ||
        widget.user.relationshipType!.isNotEmpty) {
      String result = "";
      widget.user.relationshipType!.map((e) {
        result = '$result$e,';
      });
      if (result.isNotEmpty) {
        result = result.substring(0, result.length - 1);
        relationship = [
          const SizedBox(
            height: 15,
          ),
          Text(
            "Relationship Choices",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(result)
        ];
      }
    }
    return Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        width: MediaQuery.of(context).size.width - 46,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [...smoke, ...drink, ...food, ...relationship],
        ));
  }

  Widget showPersonality(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      width: MediaQuery.of(context).size.width - 46,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Personality",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 76,
          child: Wrap(
            runSpacing: 10,
            spacing: 10,
            runAlignment: WrapAlignment.spaceBetween,
            alignment: WrapAlignment.start,
            children: widget.user.personalityType!.map((e) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(e, style: Theme.of(context).textTheme.bodySmall),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    int age = now.year - widget.user.dateOfBirth!.year;
    if (now.month < widget.user.dateOfBirth!.month ||
        (now.month == widget.user.dateOfBirth!.month &&
            now.day < widget.user.dateOfBirth!.day)) {
      age--;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                width: min(MediaQuery.of(context).size.width * 0.75, 220),
                child: Text(
                  widget.user.fullName!,
                  style: Theme.of(context).textTheme.titleSmall,
                  softWrap: true,
                )),
          ],
        ),
        Text(
            '$age  |  ${widget.user.currentAddressCity}, ${widget.user.currentAddressState}'
            '  |  ${widget.user.heightFeet}\' ${widget.user.heightInch}"'),
        const SizedBox(
          height: 35,
        ),
        ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              widget.user.profileImage!,
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width - 46,
              fit: BoxFit.cover,
            )),
        const SizedBox(
          height: 25,
        ),
        showPersonalDetails(context),
        const SizedBox(
          height: 15,
        ),
        showInterests(context),
        showLifestyle(context),
        showPersonality(context),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}
