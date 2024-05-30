import 'package:flutter/material.dart';

class CustomWaveAppBar extends StatelessWidget{
  final String title;
  final bool? popEnable;
  const CustomWaveAppBar({super.key, required this.title, this.popEnable});
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClip(),
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16,0,16,16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/plain_logo.png',
                    height: 100,
                    width: 100,
                  ),
                  popEnable!=null&&popEnable!?
                  IconButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 30,
                    )
                  ):const SizedBox(),
                ],
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,0,0,0),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



class WaveClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final lowPoint = size.height - 60;
    final highPoint = size.height - 120;
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        1 / 4 * size.width, size.height, size.width / 2 , lowPoint);
    path.quadraticBezierTo(
        3 / 4 * size.width, highPoint, size.width, lowPoint);
    path.lineTo(size.width, 0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}