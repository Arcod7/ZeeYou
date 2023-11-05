import 'package:flutter/material.dart';

class ZeeButton extends StatelessWidget {
  const ZeeButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  final void Function()? onPressed;
  final bool isLoading;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                text,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
        // Row(
        //   mainAxisAlignment: isLoading ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
        //   children: [
        //     if (isLoading)
        //       const CircularProgressIndicator(),
        //     Text(
        //       text,
        //       style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
