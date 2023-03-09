import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddittdemo/core/constants/constants.dart';
import 'package:reddittdemo/features/controller/AuthController.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({Key? key}) : super(key: key);

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(context, ref),
        icon: Image.asset(
          Constants.logoPath,
          width: 35,
        ),
        label: const Text(
          "Continue with Google",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            double.infinity,
            50
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
