import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddittdemo/core/common/post_card.dart';
import 'package:reddittdemo/features/auth/controller/AuthController.dart';
import 'package:reddittdemo/features/post/controller/post_controller.dart';
import 'package:reddittdemo/features/post/widgets/comment_card.dart';
import 'package:reddittdemo/responsive/responsive.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../models/post_model.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
        context: context, text: commentController.text.trim(), post: post);

    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
          data: (data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostCard(post: data),
                const SizedBox(
                  height: 10,
                ),
                if (!isGuest)
                  Responsive(
                    child: TextField(
                      onSubmitted: (val) => addComment(data),
                      controller: commentController,
                      decoration:const InputDecoration(
                        hintText: 'What are your thoughts?.',
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ref.watch(getPostCommentsProvider(widget.postId)).when(
                    data: (data) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final comment = data[index];
                              return CommentCard(comment: comment);
                            }),
                      );
                    },
                    error: (error, stackTrace) {
                      return ErrorText(error: error.toString());
                    },
                    loading: () => const Loader()),
              ],
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
