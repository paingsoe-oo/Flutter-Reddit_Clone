import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddittdemo/core/common/sign_in_button.dart';
import 'package:reddittdemo/core/constants/constants.dart';
import 'package:reddittdemo/features/controller/AuthController.dart';

import '../../core/common/loader.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            Constants.logoPath,
            height: 40,
          ),
          actions: [
            TextButton(
                onPressed: () {},
                child: const Text("Skip",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue)))
          ],
        ),
        body: isLoading
            ? const Loader()
            : Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Dive into anything',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      Constants.logoPath,
                      height: 400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SignInButton(),
                ],
              ));
  }
}
