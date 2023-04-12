import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {

  final String type;

  const AddPostTypeScreen({Key? key, required this.type}) : super(key: key);

  @override
  ConsumerState<AddPostTypeScreen> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
