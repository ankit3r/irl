import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:irl/data/sample_events.dart';
import 'package:irl/main.dart';
import 'package:irl/models/users.dart';
import 'package:irl/widgets/gradient_button.dart';

class EventDetails extends StatefulWidget {
  final bool isOur;
  const EventDetails({super.key, required this.isOur});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  int tab =0;
  bool expanded=false;
  bool enabled=false;

  void showTicket(){
    showDialog(
      context: context,
      builder: (context){
        return Center(
          child: SizedBox(
            height: 280,
            width: MediaQuery.of(context).size.width*0.8,
            child: CustomPaint(
              painter: TicketPainter(
                height: 280,
                width: MediaQuery.of(context).size.width*0.8,
                borderColor: Colors.black,
                bgColor: const Color(0xFFDB7E80),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("Music Festival",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.black
                      ),
                    ),
                    Text("Great to have you on board!",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.black
                      ),
                    ),
                    Text("Pass For: ${store.state!.fullName}",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.black
                      ),
                    ),
                    Text("Date:  "
                        "${DateFormat.yMMMMEEEEd().format(DateTime.parse(events[0]['DateTime']))}"
                      ,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.black
                      ),
                    ),
                    Text("Time:"
                        "${DateFormat.jmv().format(DateTime.parse(events[0]['DateTime']))}"
                      ,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.black
                      ),
                    ),
                    Text("Venue:"
                        "${events[0]["venue"]}"
                      ,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.black
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Cost:"
                            "Rs. 400"
                          ,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.black
                          ),
                        ),
                        Text("Enjoy your day"
                          ,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.black
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(events[0]['name'],style: Theme.of(context).textTheme.titleSmall,),
                    IconButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          size: min(MediaQuery.of(context).size.width*0.075,25),
                        )
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(events[0]['imageURL'],
                      height: MediaQuery.of(context).size.height*0.3,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                Row(
                  children: [
                    const Expanded(
                      child: Wrap(
                        children: [
                          Text('Music | '),
                          Text('Cocktails | '),
                          Text('21+ years | ')
                        ],

                      ),
                    ),
                    IconButton(
                      onPressed: (){},
                      icon: const Icon(Icons.share),
                    )
                  ],
                ),
                FutureBuilder(
                    future: FirebaseFirestore.instance.collection('users').get(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return const Center(child: CircularProgressIndicator(),);
                      }
                      else if(snapshot.hasData){
                        List<CustomUser> going = snapshot.data!.docs.map((e){
                          return CustomUser.fromJSON(e.data());
                        }).toList();
                        return Row(
                          children: [
                            Wrap(
                              spacing: 10,
                              children: going.take(2).map((e){
                                return CircleAvatar(
                                  radius: max(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)*0.13*0.25,
                                  child: ClipOval(
                                    child: Image.network(
                                      e.profileImage!,
                                      height: max(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)*0.13,
                                      width: max(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)*0.13,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox( width: 10,),
                            CircleAvatar(
                              radius: max(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)*0.13*0.25,
                              child: ClipOval(
                                child: Stack(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        going[3].profileImage!,
                                        height: max(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)*0.13,
                                        width: max(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)*0.13,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    BackdropFilter(
                                      filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                                      child: const SizedBox(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox( width: 10,),
                            InkWell(
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                                radius: max(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)*0.13*0.25,
                                child: CircleAvatar(
                                  radius: max(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)*0.13*0.25-1,
                                  backgroundColor: Theme.of(context).colorScheme.background,
                                  child: Text('+25',style: Theme.of(context).textTheme.bodySmall,),
                                ),
                              ),
                              onTap: (){
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context){
                                      return BottomSheet(
                                          enableDrag: true,
                                          showDragHandle: true,
                                          onClosing: (){},
                                          builder: (context){
                                            return Padding(
                                              padding: const EdgeInsets.fromLTRB(8,0,8,8),
                                              child: Scaffold(
                                                  appBar: AppBar(
                                                      centerTitle: true,
                                                      title: Text('People Going',
                                                        style: Theme.of(context).textTheme.bodyLarge,
                                                      ),
                                                      surfaceTintColor: Theme.of(context).colorScheme.onBackground,
                                                      backgroundColor: Theme.of(context).colorScheme.onBackground
                                                  ),
                                                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                                                  floatingActionButton: const Divider(color: Colors.white,),
                                                  floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
                                                  body: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        ...going.map((e){
                                                          return Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: ListTile(
                                                              leading: CircleAvatar(
                                                                radius: max(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)*0.13*0.25,
                                                                child: ClipOval(
                                                                  child: Image.network(
                                                                    e.profileImage!,
                                                                    height: max(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)*0.13,
                                                                    width: max(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)*0.13,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              ),
                                                              title: Text(e.fullName!,
                                                                style: Theme.of(context).textTheme.bodyMedium,
                                                              ),
                                                            ),
                                                          );
                                                        })
                                                      ],
                                                    ),
                                                  )
                                              ),
                                            );
                                          }
                                      );
                                    }
                                );
                              },
                            )
                          ],
                        );
                      }
                      return const CircleAvatar();
                    }
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Text("+20 Others",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
                const Divider(thickness: 1.5,),
                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          color: Theme.of(context).colorScheme.surface
                      )
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          onTap: (){
                            setState(() {
                              tab=0;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                color: tab==0?Theme.of(context).colorScheme.primary:null
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: Center(
                                child: Text('Overview',
                                  style: tab==0?Theme.of(context).textTheme.bodyMedium:
                                  Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.grey
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          onTap: (){
                            setState(() {
                              tab=1;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                color: tab==1?Theme.of(context).colorScheme.primary:null
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: Center(
                                child: Text('Event Details',
                                  style: tab==1?Theme.of(context).textTheme.bodyMedium:
                                  Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.grey
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                tab==0?Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,4,4,4),
                      child: Text(
                        "${DateFormat.MMMMEEEEd().format(DateTime.parse(events[0]['DateTime']))} at "
                            "${DateFormat.jmv().format(DateTime.parse(events[0]['DateTime']))}",
                        style: Theme.of(context).textTheme.bodyMedium,
                        softWrap: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,4,4,4),
                      child: Text(events[0]['venue'],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ):
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(events[0]['description'],
                        maxLines: !expanded?4:1000,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                        onPressed: (){
                          setState(() {
                            expanded=!expanded;
                          });
                        },
                        child: Text(
                            expanded?'View Less':'Read More'
                        )
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.09,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: (){
            setState(() {
              if(enabled==false){
                enabled=true;
              }
              else{
                enabled=false;
              }
            });
          },
          child: !widget.isOur?GradientButton(
            enable: enabled,
            label: 'I\'m going',
            onTap: (){
              setState(() {
                if(enabled==false){
                  enabled=true;
                }
                else{
                  enabled=false;
                }
              });
            }
          ):
          GradientButton(
              enable: true,
              label: 'Book Slot',
              onTap: (){
                showTicket();
              }
          ),
        ),
      ),
    );
  }
}


class TicketPainter extends CustomPainter {
  final Color borderColor;
  final Color bgColor;
  final double height;
  final double width;
  static const _cornerGap = 20.0;
  static const _cutoutRadius = 20.0;
  static const _cutoutDiameter = _cutoutRadius * 2;

  TicketPainter({required this.bgColor, required this.borderColor,required this.height, required this.width, });

  @override
  void paint(Canvas canvas, Size size) {
    final maxWidth = width;
    final maxHeight = height;

    final cutoutStartPos = maxHeight - maxHeight * 0.2;
    final leftCutoutStartY = cutoutStartPos;
    final rightCutoutStartY = cutoutStartPos - _cutoutDiameter;
    final dottedLineY = cutoutStartPos - _cutoutRadius;
    double dottedLineStartX = _cutoutRadius;
    final double dottedLineEndX = maxWidth - _cutoutRadius;
    const double dashWidth = 8.5;
    const double dashSpace = 4;

    final paintBg = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..color = bgColor;

    final paintBorder = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = borderColor;

    final paintDottedLine = Paint()
      ..color = borderColor.withOpacity(0.5)
      ..strokeWidth = 1.2;

    var path = Path();

    path.moveTo(_cornerGap, 0);
    path.lineTo(maxWidth - _cornerGap, 0);
    _drawCornerArc(path, maxWidth, _cornerGap);
    path.lineTo(maxWidth, rightCutoutStartY);
    _drawCutout(path, maxWidth, rightCutoutStartY + _cutoutDiameter);
    path.lineTo(maxWidth, maxHeight - _cornerGap);
    _drawCornerArc(path, maxWidth - _cornerGap, maxHeight);
    path.lineTo(_cornerGap, maxHeight);
    _drawCornerArc(path, 0, maxHeight - _cornerGap);
    path.lineTo(0, leftCutoutStartY);
    _drawCutout(path, 0.0, leftCutoutStartY - _cutoutDiameter);
    path.lineTo(0, _cornerGap);
    _drawCornerArc(path, _cornerGap, 0);

    canvas.drawPath(path, paintBg);
    canvas.drawPath(path, paintBorder);

    while (dottedLineStartX < dottedLineEndX) {
      canvas.drawLine(
        Offset(dottedLineStartX, dottedLineY),
        Offset(dottedLineStartX + dashWidth, dottedLineY),
        paintDottedLine,
      );
      dottedLineStartX += dashWidth + dashSpace;
    }
  }

  _drawCutout(Path path, double startX, double endY) {
    path.arcToPoint(
      Offset(startX, endY),
      radius: const Radius.circular(_cutoutRadius),
      clockwise: false,
    );
  }

  _drawCornerArc(Path path, double endPointX, double endPointY) {
    path.arcToPoint(
      Offset(endPointX, endPointY),
      radius: const Radius.circular(_cornerGap),
    );
  }

  @override
  bool shouldRepaint(TicketPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TicketPainter oldDelegate) => false;
}
