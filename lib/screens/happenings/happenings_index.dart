import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:irl/data/sample_events.dart';
import 'package:irl/screens/happenings/event_card.dart';
import 'package:irl/screens/happenings/event_details.dart';
import 'package:irl/screens/happenings/happenings.dart';

import '../../models/users.dart';


class IRLMixer extends StatefulWidget {
  const IRLMixer({super.key});

  @override
  State<IRLMixer> createState() => _IRLMixerState();
}

class _IRLMixerState extends State<IRLMixer> {

  List<int> visitingEvents = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.04,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Gelo Events',style: Theme.of(context).textTheme.titleSmall,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/logo.png',height: 60,width: 60,),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.02,),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      events[0]['imageURL'],
                      height: MediaQuery.of(context).size.height*0.35,
                      width: MediaQuery.of(context).size.width-16,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: MediaQuery.of(context).size.width-16,
                      height: MediaQuery.of(context).size.height*0.35,
                      color: Colors.black.withOpacity(0.45), // Adjust opacity as needed
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.height*0.02,
                    bottom: MediaQuery.of(context).size.height*0.02,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.35*0.6,
                      width: (MediaQuery.of(context).size.width-16)*0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(events[0]['name'],
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(DateFormat.MMMMEEEEd().format(DateTime.parse(events[0]['DateTime'])),
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4,4,3,3),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width*0.07*3,
                                    height: MediaQuery.of(context).size.width*0.07*1.3,
                                    child: Stack(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: MediaQuery.of(context).size.width*0.042,
                                          child: ClipOval(
                                            child: Image.network(
                                              StoreProvider.of<CustomUser?>(context).state!.profileImage!,
                                              height: MediaQuery.of(context).size.width*0.074,
                                              width: MediaQuery.of(context).size.width*0.074,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: MediaQuery.of(context).size.width*0.074*0.7,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: MediaQuery.of(context).size.width*0.042,
                                            child: ClipOval(
                                              child: Image.network(
                                                StoreProvider.of<CustomUser?>(context).state!.profileImage!,
                                                height: MediaQuery.of(context).size.width*0.074,
                                                width: MediaQuery.of(context).size.width*0.074,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left:MediaQuery.of(context).size.width*0.074*1.4,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: MediaQuery.of(context).size.width*0.042,
                                            child: ClipOval(
                                              child: Image.network(
                                                  StoreProvider.of<CustomUser?>(context).state!.profileImage!,
                                                height: MediaQuery.of(context).size.width*0.074,
                                                width: MediaQuery.of(context).size.width*0.074,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Text('+20 going',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  )
                                ],
                              ),
                            ),
                            Text(events[0]['venue'],
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]
                        ),
                      ),
                    )
                  ),
                  Positioned(
                    right: MediaQuery.of(context).size.height*0.02,
                    bottom: MediaQuery.of(context).size.height*0.03,
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=> const EventDetails(isOur: true,))
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(0.1,0.1), //Offset
                                blurRadius: 2.0,
                                spreadRadius: 1.0,
                              ),
                            ],
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFDB7E80),
                                Color(0xFF8147A7),
                                Color(0xFF3008D9),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('View Event',style: Theme.of(context).textTheme.bodySmall,),
                        ),
                      ),
                    )
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.03,),
              Padding(
                padding: const EdgeInsets.fromLTRB(10,0,0,0),
                child: Text('Happenings',style: Theme.of(context).textTheme.titleSmall,),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.01,),
              Center(
                child: Wrap(
                  children: events.take(2).map((e) {
                    return  InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> const EventDetails(isOur: false,))
                        );
                      },
                      child: CustomEventCard(
                        height: max(MediaQuery.of(context).size.height*0.24,244),
                        width: min(MediaQuery.of(context).size.width*0.44,177),
                        value: visitingEvents.contains(e['id']),
                        onSelected: (value){
                          setState(() {
                            visitingEvents.add(e['id']);
                          });
                        },
                        dateTime: e['DateTime'],
                        imageUrl: e['imageURL'],
                        name: e['name'],
                        venue: e['venue'],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.009,),
              Center(
                child: TextButton(
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const HappeningsIndex())
                      );
                    },
                    child:Text('View All',style: Theme.of(context).textTheme.bodySmall,)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}