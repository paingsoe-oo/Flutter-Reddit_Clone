import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddittdemo/core/common/post_card.dart';
import 'package:reddittdemo/features/community/controller/community_controller.dart';
import 'package:reddittdemo/features/models/post_model.dart';
import 'package:reddittdemo/features/post/controller/post_controller.dart';

import '../../core/common/error_text.dart';
import '../../core/common/loader.dart';
import '../auth/controller/AuthController.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    if (!isGuest) {
      return ref.watch(userCommunitiesProvider).when(
        data: (data) =>
            ref.watch(userPostsProvider(data)).when(
              data: (data) {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final post = data[index];
                      return PostCard(post: post);
                    });
              },
              error: (error, stackTrace) {
                // print(error);
                return ErrorText(error: error.toString());
              },
              loading: () => const Loader(),
            ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      );
    } else {
      return ref.watch(userCommunitiesProvider).when(
        data: (data) => ref.watch(guestPostsProvider).when(
          data: (data) {
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final post = data[index];
                  return PostCard(post: post);
                });
          },
          error: (error, stackTrace) {
            // print(error);
            return ErrorText(error: error.toString());
          },
          loading: () => const Loader(),
        ),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      );
    }
  }
}
