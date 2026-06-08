import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/bottom_sheet_helper.dart';
import 'package:healio_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:healio_app/features/user/profile/data/models/profile_button_model.dart';
import 'package:healio_app/features/user/profile/presentation/blocs/user_info_cubit.dart';
import 'package:healio_app/features/user/profile/presentation/widgets/personal_setting_shimmer.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  void _signOut() {
    context.read<AuthBloc>().add(UserSignedOutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AuthBloc, OAuthState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: state is AuthSuccess
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        ProfileHeader(state: state),
                        const SizedBox(height: 50),
                        ButtonCard(
                          buttonList: [
                            ProfileButtonModel(
                              AppLocalizations.of(context)!.profile,
                              PhosphorIcon(
                                PhosphorIcons.userRectangle(),
                                color: Colors.black,
                                size: 25,
                              ),
                              () => context.pushNamed('my-profile'),
                            ),
                            ProfileButtonModel(
                              AppLocalizations.of(context)!.favorites,
                              PhosphorIcon(
                                PhosphorIcons.heart(),
                                color: Colors.black,
                                size: 25,
                              ),
                              () => context.pushNamed(
                                'favorites',
                                extra: state.user,
                              ),
                            ),
                            // ProfileButtonModel(
                            //   AppLocalizations.of(context)!.forms,
                            //   PhosphorIcon(
                            //     PhosphorIcons.clipboardText(),
                            //     color: Colors.black,
                            //     size: 25,
                            //   ),
                            //   () {},
                            // ),
                            ProfileButtonModel(
                              AppLocalizations.of(context)!.settings,
                              PhosphorIcon(
                                PhosphorIcons.gearSix(),
                                color: Colors.black,
                                size: 25,
                              ),
                              () => context.pushNamed('setting'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ButtonCard(
                          buttonList: [
                            ProfileButtonModel(
                              AppLocalizations.of(context)!.support,
                              PhosphorIcon(
                                PhosphorIcons.lifebuoy(),
                                color: Colors.black,
                                size: 25,
                              ),
                              () => context.pushNamed('helper-center'),
                            ),
                            ProfileButtonModel(
                              AppLocalizations.of(context)!.language,
                              PhosphorIcon(
                                PhosphorIcons.globeHemisphereWest(),
                                color: Colors.black,
                                size: 25,
                              ),
                              () => context.pushNamed("language-setting"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ButtonCard(
                          buttonList: [
                            ProfileButtonModel(
                              AppLocalizations.of(context)!.logout,
                              PhosphorIcon(
                                PhosphorIcons.signOut(),
                                color: Colors.black,
                                size: 25,
                              ),
                              () => BottomSheetHelper.showLogOutBottomSheet(
                                context,
                                context.read<AuthBloc>(),
                                () => _signOut(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    )
                  : const PersonalSettingShimmer(),
            ),
          );
        },
      ),
    );
  }
}

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key, required this.state});
  final AuthSuccess state;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  void initState() {
    super.initState();
    context.read<UserInfoCubit>().loadCurrentUser(widget.state.user);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoCubit, UserInfoState>(
      builder: (context, state) {
        if (state.isLoading) {
          return _buildHeaderShimmer();
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.user!.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.personalAccount,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            state.user!.avatarUrl != null && state.user!.avatarUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      width: 60,
                      height: 60,
                      imageUrl: state.user!.avatarUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return Shimmer(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Center(
                          child: Icon(Icons.error, color: Colors.white),
                        );
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
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/user-avatar-default.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderShimmer() {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer(
                child: Container(
                  width: 200,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withValues(alpha: 0.4),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Shimmer(
                child: Container(
                  width: 140,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ],
          ),
          Shimmer(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonCard extends StatelessWidget {
  const ButtonCard({super.key, required this.buttonList});
  final List<ProfileButtonModel> buttonList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.5),
          width: 0.8,
        ),
      ),
      child: Column(
        children: buttonList
            .map(
              (button) => FilledButton.icon(
                onPressed: button.onPress,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.only(),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: button.icon,
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      button.title,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                      size: 15,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
