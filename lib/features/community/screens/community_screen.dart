import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddittdemo/features/community/controller/community_controller.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;

  const CommunityScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getCommunitybyNameProvider(name)).when(
          data: (community) => NestedScrollView(
              headerSliverBuilder: (context, innberBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(child: Image.network(community.banner)),
                      ],
                    ),

                  )
                ];
              },
              body: const Text('Displaying  posts')
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
