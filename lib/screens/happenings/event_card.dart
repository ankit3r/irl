import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:irl/models/users.dart';

class CustomEventCard extends StatefulWidget {
  final double height;
  final double width;
  final String imageUrl;
  final String venue;
  final String dateTime;
  final String name;
  final bool value;
  final Function? onSelected;
  const CustomEventCard({
    super.key, required this.imageUrl, required this.venue, required this.dateTime, required this.name, required this.value, this.onSelected, required this.height, required this.width,
  });

  @override
  State<CustomEventCard> createState() => _CustomEventCardState();
}

class _CustomEventCardState extends State<CustomEventCard> {
  bool _isSelected = false;

  @override
  void initState() {
    _isSelected = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11)
      ),
      surfaceTintColor: Theme.of(context).colorScheme.background,
      clipBehavior: Clip.hardEdge,
      elevation: 10,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFDB7E80),
                  Color(0xFF8147A7),
                  Color(0xFF3008D9),
                ]
            )
        ),
        child: Padding(
          padding: EdgeInsets.all(_isSelected?1.0:0),
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(9)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF3d3d3d),
                      Color(0xFF11171A),
                    ]
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          child: Image.network(widget.imageUrl,
                            fit: BoxFit.cover,
                            height: widget.height*0.4,
                            width: widget.width,
                          )
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              _isSelected = !_isSelected;
                              widget.onSelected?.call(_isSelected);
                            });
                          },
                          child: CircleAvatar(
                              radius: 16,
                              backgroundColor: _isSelected?Colors.white:Colors.white54,
                              child: _isSelected?ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (Rect bounds) => const LinearGradient(
                                    colors: [
                                      Color(0xFFDB7E80),
                                      Color(0xFF8147A7),
                                      Color(0xFF3008D9),
                                    ]
                                ).createShader(bounds),
                                child: const Icon(
                                  Icons.favorite,
                                ),
                              ):const Icon(
                                Icons.favorite_border_rounded,
                                color: Colors.white,
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4,6,2,2),
                    child: Text(widget.name, style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color:Colors.white
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4,4,2,4),
                    child: Text(
                      '${DateFormat.MMMd().format(DateTime.parse(widget.dateTime))} | ${DateFormat.jm().format(DateTime.parse(widget.dateTime))}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4,4,3,3),
                    child: Row(
                      children: [
                        SizedBox(
                          width: widget.width*0.35,
                          height: widget.height*0.55*0.20,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: widget.width*0.35*0.20,
                                child: ClipOval(
                                  child: Image.network(
                                    StoreProvider.of<CustomUser?>(context).state!.profileImage!,
                                    height: widget.width*0.35*0.37,
                                    width: widget.width*0.35*0.37,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: MediaQuery.of(context).size.width*0.06*0.7,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: MediaQuery.of(context).size.width*0.032,
                                  child: ClipOval(
                                    child: Image.network(
                                      StoreProvider.of<CustomUser?>(context).state!.profileImage!,
                                      height: MediaQuery.of(context).size.width*0.06,
                                      width: MediaQuery.of(context).size.width*0.06,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left:MediaQuery.of(context).size.width*0.06*1.4,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: MediaQuery.of(context).size.width*0.032,
                                  child: ClipOval(
                                    child: Image.network(
                                      StoreProvider.of<CustomUser?>(context).state!.profileImage!,
                                      height: MediaQuery.of(context).size.width*0.06,
                                      width: MediaQuery.of(context).size.width*0.06,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Text('+20 going',
                          style: Theme.of(context).textTheme.labelSmall,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4,2,2,2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(Icons.location_on_outlined,color: Colors.grey, size: 15),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: SizedBox(
                            width: min(MediaQuery.of(context).size.width*0.4,200)*0.8,
                            height: min(MediaQuery.of(context).size.width*0.3,150)*0.13,
                            child: Text(widget.venue,
                              style: Theme.of(context).textTheme.labelSmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}