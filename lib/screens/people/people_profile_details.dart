import 'package:flutter/material.dart';
import 'package:irl/models/users.dart';


enum Profile{
  liked,
  matched,
  likeYou,
}


class PeopleProfileDetails extends StatefulWidget {
  final CustomUser profile;
  final Profile type;
  const PeopleProfileDetails({super.key, required this.profile, required this.type});

  @override
  State<PeopleProfileDetails> createState() => _PeopleProfileDetailsState();
}

class _PeopleProfileDetailsState extends State<PeopleProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(23,0,23,0),
          child: SingleChildScrollView(
              child: Center(child: UserDetailsCard(user: widget.profile,type: widget.type,))
            )
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: widget.type==Profile.likeYou?Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text("Do you wanna like them back?")
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: (){},
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        radius: 20,
                        child: const Icon(Icons.close_rounded, size: 22,),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: (){},
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                        radius: 20,
                        child: Icon(
                          Icons.favorite_border_rounded,
                          size: 22,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ):null,
    );
  }
}


class UserDetailsCard extends StatefulWidget {
  final CustomUser user;
  final Profile type;

  const UserDetailsCard({super.key,
    required this.user, required this.type
  });

  @override
  State<UserDetailsCard> createState() => _UserDetailsCardState();
}

class _UserDetailsCardState extends State<UserDetailsCard> {
  Widget showPersonalDetails(BuildContext context){
    List<Widget> bio=[],maritalStatus=[],home=[],religion=[],languages=[];
    if(widget.user.bio!=null){
      bio = [
        Text("About", style: Theme.of(context).textTheme.bodySmall,),
        Text(widget.user.bio!),
      ];
    }
    if(widget.user.maritalStatus!=null){
      maritalStatus = [
        const SizedBox(height: 20,),
        Text("Status", style: Theme.of(context).textTheme.bodySmall,),
        Text(widget.user.maritalStatus!),
      ];
    }
    if(widget.user.homeCity!=null){
      home=[
        const SizedBox(height: 20,),
        Text("Home", style: Theme.of(context).textTheme.bodySmall,),
        Text("${widget.user.homeCity}, ${widget.user.homeState}"),
      ];
    }
    if(widget.user.religion!=null){
      religion =[
        const SizedBox(height: 20,),
        Text("Religion", style: Theme.of(context).textTheme.bodySmall,),
        Text(widget.user.religion!),
      ];
    }
    if(widget.user.language!=null){
      String result="";
      widget.user.language!.map((e){
        result = '$result$e,';
      });
      if(result.isNotEmpty){
        result = result.substring(0,result.length-1);
        languages = [
          const SizedBox(height: 15,),
          Text("Languages", style: Theme.of(context).textTheme.bodySmall,),
          Text(result)
        ];
      }
    }
    return Container(
        padding: const EdgeInsets.all(15.0),
        width: MediaQuery.of(context).size.width-46,
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
        )
    );
  }

  Widget showInterests(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(15.0),
      width: MediaQuery.of(context).size.width-46,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Interests", style: Theme.of(context).textTheme.bodySmall,),
            const SizedBox(height: 10,),
            SizedBox(
              width: MediaQuery.of(context).size.width-76,
              child: Wrap(
                runSpacing: 10,
                spacing: 10,
                runAlignment: WrapAlignment.spaceBetween,
                alignment: WrapAlignment.start,
                children: widget.user.interests!.map((e){
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(e,style: Theme.of(context).textTheme.bodySmall),
                  );
                }).toList(),
              ),
            ),
          ]
      ),
    );
  }

  Widget showLifestyle(BuildContext context){
    List<Widget> smoke=[],drink=[],food=[],relationship=[];
    if(widget.user.smoke!=null){
      smoke = [
        const SizedBox(height: 15,),
        Text("Smokes", style: Theme.of(context).textTheme.bodySmall,),
        Text(widget.user.smoke!),
      ];
    }
    if(widget.user.drink!=null){
      drink = [
        const SizedBox(height: 15,),
        Text("Drinks", style: Theme.of(context).textTheme.bodySmall,),
        Text(widget.user.drink!),
      ];
    }
    if(widget.user.foodLifestyle!=null){
      food = [
        const SizedBox(height: 15,),
        Text("Food Lifestyle", style: Theme.of(context).textTheme.bodySmall,),
        Text(widget.user.foodLifestyle!),
      ];
    }
    if(widget.user.relationshipType!=null || widget.user.relationshipType!.isNotEmpty){
      String result="";
      widget.user.relationshipType!.map((e){
        result = '$result$e,';
      });
      if(result.isNotEmpty){
        result = result.substring(0,result.length-1);
        relationship = [
          const SizedBox(height: 15,),
          Text("Relationship Choices", style: Theme.of(context).textTheme.bodySmall,),
          Text(result)
        ];
      }
    }
    return Container(
        padding: const EdgeInsets.fromLTRB(15,0,15,15),
        width: MediaQuery.of(context).size.width-46,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...smoke,
            ...drink,
            ...food,
            ...relationship
          ],
        )
    );
  }

  Widget showPersonality(BuildContext context){
    return Container(
      padding: const EdgeInsets.fromLTRB(15,0,15,15),
      width: MediaQuery.of(context).size.width-46,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Personality", style: Theme.of(context).textTheme.bodySmall,),
            const SizedBox(height: 10,),
            SizedBox(
              width: MediaQuery.of(context).size.width-76,
              child: Wrap(
                runSpacing: 10,
                spacing: 10,
                runAlignment: WrapAlignment.spaceBetween,
                alignment: WrapAlignment.start,
                children: widget.user.personalityType!.map((e){
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(e,style: Theme.of(context).textTheme.bodySmall),
                  );
                }).toList(),
              ),
            ),
          ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    int age = now.year - widget.user.dateOfBirth!.year;
    if (now.month < widget.user.dateOfBirth!.month
        || (now.month == widget.user.dateOfBirth!.month
            && now.day < widget.user.dateOfBirth!.day)) {
      age--;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: MediaQuery.of(context).size.width,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    child: Text(widget.user.fullName!.split(" ").first,
                      style: Theme.of(context).textTheme.titleSmall,
                      softWrap: true,
                    )
                ),
                Icon(
                  widget.user.gender=='Male'?Icons.male_rounded:Icons.female_rounded,
                  size: 30,
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  constraints: const BoxConstraints(minWidth: 50),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.send_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      builder: (context){
                        return SizedBox(
                          height: widget.type==Profile.likeYou?MediaQuery.of(context).size.height*0.33:MediaQuery.of(context).size.height*0.43,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  widget.type!=Profile.likeYou?ListTile(
                                    onTap: (){},
                                    title: Center(
                                      child: Text(
                                        widget.type==Profile.liked?"Remove like":"Unmatch",
                                        style: Theme.of(context).textTheme.displaySmall,
                                      ),
                                    ),
                                  ):const SizedBox(),
                                  widget.type!=Profile.likeYou?const Divider(color: Colors.white,):const SizedBox(),
                                  ListTile(
                                    onTap: (){},
                                    title: Center(
                                      child: Text("Restrict Account",
                                        style: Theme.of(context).textTheme.displaySmall,
                                      ),
                                    ),
                                  ),
                                  const Divider(color: Colors.white,),
                                  ListTile(
                                    onTap: (){},
                                    title: Center(
                                      child: Text("Block Account",
                                        style: Theme.of(context).textTheme.displaySmall,
                                      ),
                                    ),
                                  ),
                                  const Divider(color: Colors.white,),
                                  ListTile(
                                    onTap: (){},
                                    title: Center(
                                      child: Text("Report Account",
                                        style: Theme.of(context).textTheme.displaySmall,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(23.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Center(
                                      child: InkWell(
                                        onTap: (){},
                                        child: Container(
                                          width: MediaQuery.of(context).size.width*0.7,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            border: Border.all(
                                                color: Colors.white
                                            ),
                                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('Cancel',
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                      color: Colors.black
                                                  )
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    );
                  },
                  icon: const Icon(Icons.more_vert)
                )
              ],
            ),
          ],
        ),
        Text(
            '$age  |  ${widget.user.currentAddressCity}, ${widget.user.currentAddressState}'
                '  |  ${widget.user.heightFeet}\' ${widget.user.heightInch}"'
        ),
        const SizedBox(height: 35,),
        ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(widget.user.profileImage!,
              height: MediaQuery.of(context).size.height*0.5,
              width: MediaQuery.of(context).size.width-46,
              fit: BoxFit.cover,
            )
        ),
        const SizedBox(height: 25,),
        showPersonalDetails(context),
        const SizedBox(height: 15,),
        showInterests(context),
        showLifestyle(context),
        showPersonality(context),
        const SizedBox( height: 100,)
      ],
    );
  }
}