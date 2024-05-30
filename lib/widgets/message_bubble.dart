import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Bubble extends StatefulWidget {
  const Bubble(
      {
        super.key,
        required this.message,
        required this.dateTime,
        required this.uid
      }
      );
  final String message;
  final DateTime dateTime;
  final String uid;

  @override
  State<Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  var id=FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: id==widget.uid?MainAxisAlignment.end:MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(9,5,5,5),
          margin: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width*0.7,
          ),
          decoration: BoxDecoration(
            color: id==widget.uid?Theme.of(context).colorScheme.surface:Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(widget.message,
                  style:Theme.of(context).textTheme.bodyMedium,
                  softWrap: true,
                ),
              ),
              const SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.fromLTRB(5,5,5,0),
                child: Text(DateFormat('HH:mm').format(widget.dateTime).toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}