import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class CustomPinInput extends StatelessWidget {
  final bool enabled;
  final TextEditingController pinController;
  final Function? onChanged;
  const CustomPinInput({super.key, required this.pinController, required this.enabled, this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Pinput(
        onChanged: (value){
          if(onChanged!=null) onChanged!.call(value);
        },
        enabled: enabled,
          onTapOutside: (pointer){
            FocusScope.of(context).unfocus();
          },
          length: 6,
          controller: pinController,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          defaultPinTheme: PinTheme(
              constraints: const BoxConstraints(maxWidth: 300,maxHeight: 50),
              width: 40, height: 40,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface
                  )
              )
          ),
          focusedPinTheme: PinTheme(
              constraints: const BoxConstraints(maxWidth: 300,maxHeight: 50),
              width: 40, height: 40,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface
                  )
              )
          )
      ),
    );
  }
}