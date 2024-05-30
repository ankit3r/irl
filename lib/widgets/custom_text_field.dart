import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? type;
  final Function? onEditingComplete;
  final Function? onChanged;
  final int? maxLength;
  const CustomTextField({super.key, required this.controller, required this.labelText, this.type, this.onEditingComplete, this.onChanged, this.maxLength});

  @override
  Widget build(BuildContext context) {
    return TextField(

      onTapOutside: (pointer){
        FocusScope.of(context).unfocus();
      },
      onEditingComplete: (){
        FocusScope.of(context).unfocus();
        if(onEditingComplete!=null) onEditingComplete!();

      },
      onChanged: (value){
        if(onChanged!=null) onChanged!.call(value);
      },
      keyboardType: type ?? TextInputType.multiline,
      controller: controller,
      style: Theme.of(context).textTheme.bodyMedium,
      maxLength: maxLength,

      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: Theme.of(context).textTheme.labelMedium,
          filled: true,
          fillColor: Theme.of(context).colorScheme.tertiary,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30),
          ),
          constraints: const BoxConstraints(maxWidth: 300),
        contentPadding: const EdgeInsets.all(13),
        counterText: ""
      ),
    );
  }
}
