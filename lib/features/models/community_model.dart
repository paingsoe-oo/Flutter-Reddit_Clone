class Community {
  final String id;
  final String name;
  final String banner;
  final String avatar;
  final List<String> members;
  final List<String> mods;

  const Community({
    required this.id,
    required this.name,
    required this.banner,
    required this.avatar,
    required this.members,
    required this.mods,
  });

  Community copyWith({
    String? id,
    String? name,
    String? banner,
    String? avatar,
    List<String>? members,
    List<String>? mods,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      banner: banner ?? this.banner,
      avatar: avatar ?? this.avatar,
      members: members ?? this.members,
      mods: mods ?? this.mods,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'banner': this.banner,
      'avatar': this.avatar,
      'members': this.members,
      'mods': this.mods,
    };
  }



  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'] as String,
      name: map['name'] as String,
      banner: map['banner'] as String,
      avatar: map['avatar'] as String,
      members: map['members'] as List<String>,
      mods: map['mods'] as List<String>,
    );
  }
}