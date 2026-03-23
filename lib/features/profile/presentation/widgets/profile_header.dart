import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gotrue/gotrue.dart';
import 'package:healio_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.state});
  final AuthSuccess state;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.user.fullName,
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  fontSize: 25
              ),
            ),
            Text(
              'Personal account',
              style: TextStyle(
                  fontSize: 15
              ),
            ),
          ],
        ),
        state.user.avatarUrl != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CachedNetworkImage(
            width: 60,
            height: 60,
            imageUrl: state.user.avatarUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url){
              return Shimmer(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                  ),
                ),
              );
            },
            errorWidget: (context, url, error){
              return Center(child: Icon(Icons.error, color: Colors.white,));
            },
          ),
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
              ),
              child: Image.asset('assets/images/user-avatar-default.png', fit: BoxFit.cover,)
          ),
        )
      ],
    );
  }
}
