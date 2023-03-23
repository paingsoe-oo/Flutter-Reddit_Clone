import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controller/AuthController.dart';
import '../drawers/community_list_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => displayDrawer(context),
        ),
        // actions: [
        //   IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        //   IconButton(
        //     icon: CircleAvatar(
        //       backgroundImage: NetworkImage(
        //           user.profilePic
        //       ),
        //     ),
        //     onPressed: () {},
        //   )
        // ],
      ),
      body: Center(
        child: Text(user.name.toString()),
      )
      // drawer: const CommunityListDrawer(),
    );
  }
}
