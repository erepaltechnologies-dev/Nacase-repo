import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/user_profile_provider.dart';

class ProfileAvatar extends StatelessWidget {
  final double radius;
  final Color? backgroundColor;
  final Widget? child;

  const ProfileAvatar({
    Key? key,
    this.radius = 20,
    this.backgroundColor,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProfileProvider>();
    
    ImageProvider? backgroundImage;
    
    // Priority: local bytes > remote URL > default asset
    if (userProvider.hasCustomImage) {
      backgroundImage = MemoryImage(userProvider.profileImageBytes!);
    } else if (userProvider.profileImageUrl != null) {
      backgroundImage = NetworkImage(userProvider.profileImageUrl!);
    } else {
      backgroundImage = AssetImage(userProvider.defaultImagePath);
    }
    
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: backgroundImage,
      child: child,
    );
  }
}