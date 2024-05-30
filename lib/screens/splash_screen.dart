import 'package:flutter/material.dart';
import 'package:irl/screens/index.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<dynamic> _animation;

  @override
  void initState() {
    super.initState();
    // Simulate a delay before moving to the main screen.
    // loadPage();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Adjust duration as needed
    );

    _animation = TweenSequence([
      TweenSequenceItem(
        tween: GradientTween(
          begin: const LinearGradient(
            colors: [Color(0xFF11171A), Colors.black],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          end: const LinearGradient(
            colors: [
              Color(0xFFDB7E80),
              Color(0xFF8147A7),
              Color(0xFF3008D9),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        weight: 4,
      ),
      TweenSequenceItem(
        tween: GradientTween(
          begin: const LinearGradient(
            colors: [
              Color(0xFFDB7E80),
              Color(0xFF8147A7),
              Color(0xFF3008D9),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          end: const LinearGradient(
            colors: [
              Colors.black,
              Colors.black
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        weight: 3,
      ),
    ]).animate(_controller);

    _controller.forward().then((value){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (ctx) {
                return const Wrapper();
              }
          )
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              gradient: _animation.value is LinearGradient
                  ? _animation.value
                  : null,
              color: _animation.value is Color ? _animation.value : null,
            ),
            child: Center(
              child: Image.asset(
                "assets/images/plain_logo.png",
                height: 160,
                width: 160,
              )
            )
          );
        },
      ),
    );
  }
}


class GradientTween extends Tween<dynamic> {
  GradientTween({super.begin, super.end});

  @override
  dynamic lerp(double t) {
    if (begin is LinearGradient && end is LinearGradient) {
      int n = begin.colors.length, m = end.colors.length;
      return LinearGradient(
        colors: [
          Color.lerp(begin.colors[0], end.colors[0], t)!,
          Color.lerp(begin.colors[n-1], end.colors[m-1], t)!,
        ],
        begin: Alignment.lerp(begin.begin, end.begin, t)!,
        end: Alignment.lerp(begin.end, end.end, t)!,
      );
    } else if (begin is Color && end is Color) {
      return Color.lerp(begin, end, t);
    }
    throw ArgumentError('Invalid types for GradientTween');
  }
}