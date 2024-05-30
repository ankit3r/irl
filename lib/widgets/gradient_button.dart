import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Function onTap;
  final String label;
  final bool? enable;
  final int? height;
  const GradientButton({super.key, required this.label, required this.onTap, this.enable, this.height});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
            BoxShadow(
              color: Color(0x54000000),
              spreadRadius:4,
              blurRadius: 20,
            ),
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Material(
          child: InkWell(
            onTap: (enable==null || enable==true)?(){
              onTap();
            }:null,
            child: (enable==null || enable==true)?Ink(
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(5.0,5.0), //Offset
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
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
                  borderRadius: BorderRadius.circular(30.0)
              ),
              child: Container(
                height: height!=null?height!.toDouble():50,
                constraints: const BoxConstraints(maxWidth: 300.0, maxHeight: 50.0),
                alignment: Alignment.center,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                ),
              ),
            ):Ink(
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(5.0,5.0), //Offset
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                  color: Theme.of(context).colorScheme.outline,
                  borderRadius: BorderRadius.circular(30.0)
              ),
              child: Container(
                height: height!=null?height!.toDouble():50,
                constraints: const BoxConstraints(maxWidth: 300.0, maxHeight: 50.0),
                alignment: Alignment.center,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
