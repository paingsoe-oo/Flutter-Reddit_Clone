import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddittdemo/features/repository/auth_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(userProvider)!;

    return Scaffold(
      body: Center(
        child:  Text(
          user?.name
          user.name
        ),
      )
    );
  }
}
