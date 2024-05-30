import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:irl/widgets/custom_wave_appbar.dart';
import 'package:irl/widgets/gradient_button.dart';
class SubscriptionIndex extends StatefulWidget {
  const SubscriptionIndex({super.key});

  @override
  State<SubscriptionIndex> createState() => _SubscriptionIndexState();
}

class _SubscriptionIndexState extends State<SubscriptionIndex> {
  int plan =0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height*0.27),
        child: const CustomWaveAppBar(
          popEnable: true,
          title: 'Choose your plan',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: (){
                  setState(() {
                    plan=0;
                  });
                },
                child: SubscriptionItem(
                  leading: 'Basic',
                  title: 'Free',
                  value: plan==0,
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: (){
                  setState(() {
                    plan=1;
                  });
                },
                child: SubscriptionItem(
                  leading: 'Silver',
                  title: '₹500 / Month',
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\u2022 Account interactions: Unlimited',
                        style: Theme.of(context).textTheme.labelMedium,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('\u2022 Preference based account interactions: Yes',
                        style: Theme.of(context).textTheme.labelMedium,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('\u2022 Messages(Texts+Images) : Yes',
                        style: Theme.of(context).textTheme.labelMedium,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  value: plan==1
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: (){
                  setState(() {
                    plan=2;
                  });
                },
                child: SubscriptionItem(
                    leading: 'Gold',
                    title: '₹2000 / Quarterly',
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('\u2022 Account interactions: Unlimited',
                          style: Theme.of(context).textTheme.labelMedium,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text('\u2022 Preference based account interactions: Yes',
                          style: Theme.of(context).textTheme.labelMedium,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text('\u2022 Messages(Texts+Images) : Yes',
                          style: Theme.of(context).textTheme.labelMedium,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    value: plan==2
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: (){
                  setState(() {
                    plan=3;
                  });
                },
                child: SubscriptionItem(
                    leading: 'Members',
                    title: '₹5000 / Quarterly',
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('\u2022 Join the elite club!',
                          style: Theme.of(context).textTheme.labelMedium,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text('\u2022 Exclusive events only for members',
                          style: Theme.of(context).textTheme.labelMedium,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text('\u2022 Highly curated events',
                          style: Theme.of(context).textTheme.labelMedium,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    value: plan==3
                ),
              ),
              const SizedBox(height: 100,)
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GradientButton(
        onTap: (){
          showModalBottomSheet(
            context: context,
            backgroundColor: Theme.of(context).colorScheme.primary,
            isScrollControlled: true,
            enableDrag: true,
            showDragHandle: true,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height*0.8
            ),
            builder: (context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.98,
                builder: (context, scrollController){
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Upgrade to \nPremium Now",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            IconButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                                icon: const Icon(Icons.close_rounded, size: 30,)
                            )
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("₹500 / month",
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          fontWeight: FontWeight.bold
                                      )
                                  ),
                                  const SizedBox(height: 20,),
                                  RichText(
                                    text: TextSpan(
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      children: [
                                        TextSpan(
                                          text: "•  Account Interactions: ",
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        const TextSpan(
                                            text: "Go unlimited with Premium.",
                                        ),
                                      ]
                                    )
                                  ),
                                  const SizedBox(height: 15,),
                                  RichText(
                                      text: TextSpan(
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          children: [
                                            TextSpan(
                                              text: "•  Preference based account interactions: ",
                                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            const TextSpan(
                                              text: "Connect with those who match your preferences.",
                                            ),
                                          ]
                                      )
                                  ),
                                  const SizedBox(height: 15,),
                                  RichText(
                                      text: TextSpan(
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          children: [
                                            TextSpan(
                                              text: "•  Messages (Texts + Images): ",
                                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            const TextSpan(
                                              text: "Send texts and images hassle-free.",
                                            ),
                                          ]
                                      )
                                  ),
                                  const SizedBox(height: 15,),
                                  RichText(
                                      text: TextSpan(
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          children: [
                                            TextSpan(
                                              text: "•  Happenings: ",
                                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            const TextSpan(
                                              text: "Access exclusive events and meetups.",
                                            ),
                                          ]
                                      )
                                  ),
                                  const SizedBox(height: 15,),
                                  RichText(
                                      text: TextSpan(
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          children: [
                                            TextSpan(
                                              text: "•  Profile Visibility Customization: ",
                                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            const TextSpan(
                                              text: "Take control of your profile's visibility.",
                                            ),
                                          ]
                                      )
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                height: 50,
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
                                    child: Text('Upgrade',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                            color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextButton(
                              onPressed: (){},
                              child: Text("Skip Now",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              );
            }
          );
        },
        label: 'Select Plan',
      ),
    );
  }
}

class SubscriptionItem extends StatelessWidget {
  final String leading;
  final String title;
  final Widget? subtitle;
  final bool value;

  const SubscriptionItem({
    super.key, required this.leading, required this.title, this.subtitle, required this.value
  });
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
        decoration: BoxDecoration(
            gradient: value?const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF3008D9),
                  Color(0xFF8147A7),
                  Color(0xFFDB7E80),
                ]
            ):null,
          color:value?null:Theme.of(context).colorScheme.surface
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.background,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width-30)*0.27,
                    child: Text(leading, textAlign: TextAlign.center,),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Theme.of(context).colorScheme.surface,
                            width: 1.4
                          )
                        )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, textAlign: TextAlign.left,),
                            subtitle!=null?subtitle!:const SizedBox(),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: (){},
                                  child: Text('View Plan > ',
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      decoration: TextDecoration.underline
                                    ),
                                  )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          )
        ),
      ),
    );
  }
}
