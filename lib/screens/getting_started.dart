import 'dart:async';
import 'package:flutter/material.dart';
import 'package:irl/screens/login.dart';
import 'package:irl/widgets/custom_appbar.dart';
import 'package:irl/data/getting_started_data.dart';
import 'package:irl/widgets/gradient_button.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({super.key});
  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  late PageController _pageController;
  int index=0;
  bool isPointerDown = false;

  void startAutoSlide() {
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!isPointerDown) {
        if (index < map.length - 1) {
          index++;
        } else {
          index = 0;
        }
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 1000),

          curve: Curves.fastEaseInToSlowEaseOut,
        );
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: 0);
    startAutoSlide();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(250),
        child: CustomAppBar(imageAddress: map[index]['image']!),
      ),
      body: GestureDetector(
        onTapDown: (_) {
          setState(() {
            isPointerDown = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            isPointerDown = false;
          });
        },
        child: AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              return PageView.builder(
                  controller: _pageController,
                  itemCount: map.length,
                  onPageChanged: (newIndex) {
                    setState(() {
                      index = newIndex;
                    });
                  },
                  itemBuilder: (context,index) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Flexible(
                                fit: FlexFit.tight,
                                  flex: 1,
                                  child: SizedBox()
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: Text(
                                  map[index]['title']!,
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Flexible(
                                  fit: FlexFit.tight,
                                flex: 1,
                                child: Text(map[index]['subtitle']!,textAlign: TextAlign.center,)
                              ),
                              const Flexible(
                                  fit: FlexFit.tight,
                                flex: 1,
                                child: SizedBox()
                              )
                            ]
                        ),
                      ),
                    );
                  }
              );
            }
        ),
      ),
      floatingActionButton : Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: InkWell(
                    onTap: (){
                      setState(() {
                        index = 0;
                      });
                    },
                    child: index==0 ?
                    Container(
                      height: 9,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ):
                    CircleAvatar(radius: 3, child: CircleAvatar(radius: 2,backgroundColor: Theme.of(context).colorScheme.background,),)
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: InkWell(
                    onTap: (){
                      setState(() {
                        index = 1;
                      });
                    },
                    child: index==1 ?
                    Container(
                      height: 9,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ):
                    CircleAvatar(radius: 3, child: CircleAvatar(radius: 2,backgroundColor: Theme.of(context).colorScheme.background,),)
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: InkWell(
                    onTap: (){
                      setState(() {
                        index = 2;
                      });
                    },
                    child: index==2 ?
                    Container(
                      height: 9,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ):
                    CircleAvatar(radius: 3, child: CircleAvatar(radius: 2,backgroundColor: Theme.of(context).colorScheme.background,),)
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          GradientButton(
            height: 50,
            label: 'Get Started',
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const LoginScreen())
              );
            },
          ),
          const SizedBox(height: 30,),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}