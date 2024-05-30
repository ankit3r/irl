import 'dart:math';
import 'package:flutter/material.dart';
import 'package:irl/data/sample_events.dart';
import 'package:irl/screens/happenings/event_card.dart';
import 'package:irl/screens/happenings/event_details.dart';

class HappeningsIndex extends StatefulWidget {
  const HappeningsIndex({super.key});

  @override
  State<HappeningsIndex> createState() => _HappeningsIndexState();
}

class _HappeningsIndexState extends State<HappeningsIndex> {

  List<int> visitingEvents = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('Happenings',style: Theme.of(context).textTheme.bodyLarge),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.surface
                  ),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(10)
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5,0,5,0),
                child: TextField(
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      icon: const Padding(
                        padding: EdgeInsets.fromLTRB(8,0,8,0),
                        child: Icon(Icons.search,color: Colors.grey,),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Search',
                      labelStyle: Theme.of(context).textTheme.labelMedium,
                      border: const OutlineInputBorder(borderSide: BorderSide.none)
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: events.map((event){
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const EventDetails(isOur: false,))
                    );
                  },
                  child: CustomEventCard(
                    onSelected: (value){
                      setState(() {
                        visitingEvents.add(event['id']);
                      });
                    },
                    imageUrl: event['imageURL'],
                    venue: event['venue'],
                    dateTime: event['DateTime'],
                    name: event['name'],
                    value: visitingEvents.contains(event['id']),
                    height: max(MediaQuery.of(context).size.height*0.26,246.8),
                    width: min(MediaQuery.of(context).size.width*0.45,179.25),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}