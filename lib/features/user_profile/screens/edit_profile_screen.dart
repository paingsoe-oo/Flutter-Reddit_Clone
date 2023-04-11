import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddittdemo/features/auth/controller/AuthController.dart';
import 'package:reddittdemo/theme/palette.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../controller/user_profile_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;

  const EditProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (community) => Scaffold(
            backgroundColor: currentTheme.backgroundColor,
              appBar: AppBar(
                  title: const Text('Edit profile'),
                  centerTitle: false,
                  actions: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Save'),
                    )
                  ]),
              body: isLoading? const Loader() : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: selectBannerImage,
                            child: DottedBorder(
                              radius: const Radius.circular(10),
                              borderType: BorderType.RRect,
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              color: currentTheme.textTheme.bodyText2!.color!,
                              child: Container(
                                  width: double.infinity,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: bannerFile != null
                                      ? Image.file(bannerFile!)
                                      : community.banner.isEmpty ||
                                              community.banner ==
                                                  Constants.logoPath
                                          ? const Center(
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                size: 40,
                                              ),
                                            )
                                          : Image.network(
                                              community.banner,
                                              scale: 1.0,
                                            )),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: GestureDetector(
                              onTap: () {},
                              child: profileFile != null
                                  ? CircleAvatar(
                                      backgroundImage: FileImage(profileFile!),
                                      radius: 32,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(community.profilePic),
                                      radius: 32,
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Name',
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(
                          18,
                        ),
                      ),
                    )
                  ],
                ),
              )),
          loading: () => const Loader(),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
        );
  }
}
