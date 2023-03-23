import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddittdemo/core/constants/constants.dart';
import 'package:reddittdemo/features/community/repository/community_repository.dart';
import 'package:reddittdemo/features/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/utils.dart';
import '../../auth/controller/AuthController.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final communityControllerProvider = StateNotifierProvider<CommunityController, bool>((ref) {

  final communityRepository = ref.watch(communityRepositoryProvider);

  return CommunityController(
      communityRepository: communityRepository,
      ref: ref);
});

final getCommunitybyNameProvider = StreamProvider.family((ref, String name) {
  return ref.watch(communityControllerProvider.notifier).getCommunitybyName(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;

   CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _ref = ref,
        super(false);
        

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';

    Community community = Community(
      id: name,
      name: name,
      banner: Constants.logoPath,
      avatar: Constants.logoPath,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          showSnackBar(context, 'Community created success');
          Routemaster.of(context).pop();
        },
    );
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunitybyName(String name) {
    return _communityRepository.getCommunityByName(name);
  }
}