import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/bottom_sheet_helper.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/user/explore/presentation/pages/add_my_address_page.dart';
import 'package:healio_app/features/user/explore/presentation/widgets/address_card.dart';
import 'package:healio_app/features/user/profile/presentation/blocs/user_address_bloc.dart';
import 'package:healio_app/features/user/profile/presentation/blocs/user_info_cubit.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  void initState() {
    super.initState();
    final currentUser = context.read<UserInfoCubit>().state.user!;
    context.read<UserAddressBloc>().add(GetUserAddress(userId: currentUser.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const PhosphorIcon(
            PhosphorIconsRegular.arrowLeft,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.myProfile,
          style: GoogleFonts.quicksand(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: BlocBuilder<UserInfoCubit, UserInfoState>(
          builder: (context, userState) {
            if (userState.isLoading) {
              return const MyProfileShimmer();
            }
            return BlocConsumer<UserAddressBloc, UserAddressState>(
              listener: (context, state) {
                if (state.error != null) {
                  SnackBarHelper.showError(state.error.toString());
                }
              },
              builder: (context, state) {
                if (state.isLoading) {
                  return const MyProfileShimmer();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCard(userState),
                    const SizedBox(height: 32),
                    Text(
                      AppLocalizations.of(context)!.myAddresses,
                      style: GoogleFonts.quicksand(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    state.homeAddress != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: AddressCard(
                              iconData: PhosphorIcons.house(
                                PhosphorIconsStyle.fill,
                              ),
                              title: AppLocalizations.of(context)!.home,
                              iconColor: const Color(0xFF6B4EFF),
                              iconBackgroundColor: Colors.deepPurpleAccent
                                  .withValues(alpha: 0.2),
                              content: state.homeAddress!.address,
                              menuButton: GestureDetector(
                                onTap: () =>
                                    BottomSheetHelper.showSettingAddressBottomSheet(
                                      context,
                                      context.read<UserAddressBloc>(),
                                      state.homeAddress!,
                                      userState.user!.id,
                                    ),
                                child: PhosphorIcon(
                                  PhosphorIconsRegular.dotsThreeVertical,
                                  color: Colors.grey.shade800,
                                  size: 24,
                                ),
                              ),
                              onTap: () =>
                                  BottomSheetHelper.showSettingAddressBottomSheet(
                                    context,
                                    context.read<UserAddressBloc>(),
                                    state.homeAddress!,
                                    userState.user!.id,
                                  ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: AddressCard(
                              iconData: PhosphorIcons.house(
                                PhosphorIconsStyle.fill,
                              ),
                              title: AppLocalizations.of(context)!.home,
                              iconColor: Colors.black,
                              iconBackgroundColor: Colors.black.withValues(
                                alpha: 0.1,
                              ),
                              content: AppLocalizations.of(context)!.addAddress,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<UserAddressBloc>(),
                                    child: AddMyAddressPage(
                                      addressName: 'Home',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                    state.workAddress != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: AddressCard(
                              iconData: PhosphorIcons.briefcase(
                                PhosphorIconsStyle.fill,
                              ),
                              title: AppLocalizations.of(context)!.work,
                              iconColor: const Color(0xFF6B4EFF),
                              iconBackgroundColor: Colors.deepPurpleAccent
                                  .withValues(alpha: 0.2),
                              content: state.workAddress!.address,
                              menuButton: GestureDetector(
                                onTap: () =>
                                    BottomSheetHelper.showSettingAddressBottomSheet(
                                      context,
                                      context.read<UserAddressBloc>(),
                                      state.workAddress!,
                                      userState.user!.id,
                                    ),
                                child: PhosphorIcon(
                                  PhosphorIconsRegular.dotsThreeVertical,
                                  color: Colors.grey.shade800,
                                  size: 24,
                                ),
                              ),
                              onTap: () =>
                                  BottomSheetHelper.showSettingAddressBottomSheet(
                                    context,
                                    context.read<UserAddressBloc>(),
                                    state.workAddress!,
                                    userState.user!.id,
                                  ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: AddressCard(
                              iconData: PhosphorIcons.briefcase(
                                PhosphorIconsStyle.fill,
                              ),
                              title: AppLocalizations.of(context)!.work,
                              iconColor: Colors.black,
                              iconBackgroundColor: Colors.black.withValues(
                                alpha: 0.1,
                              ),
                              content: AppLocalizations.of(context)!.addAddress,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<UserAddressBloc>(),
                                    child: AddMyAddressPage(
                                      addressName: 'Work',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                    ...state.anotherAddress.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: AddressCard(
                          iconData: PhosphorIcons.mapPin(
                            PhosphorIconsStyle.fill,
                          ),
                          title: item.name,
                          iconColor: const Color(0xFF6B4EFF),
                          iconBackgroundColor: Colors.deepPurpleAccent
                              .withValues(alpha: 0.2),
                          content: item.address,
                          menuButton: GestureDetector(
                            onTap: () =>
                                BottomSheetHelper.showSettingAddressBottomSheet(
                                  context,
                                  context.read<UserAddressBloc>(),
                                  item,
                                  userState.user!.id,
                                ),
                            child: PhosphorIcon(
                              PhosphorIconsRegular.dotsThreeVertical,
                              color: Colors.grey.shade800,
                              size: 24,
                            ),
                          ),
                          onTap: () =>
                              BottomSheetHelper.showSettingAddressBottomSheet(
                                context,
                                context.read<UserAddressBloc>(),
                                item,
                                userState.user!.id,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildAddButton(),
                    const SizedBox(height: 40),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard(UserInfoState userState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () async {
                await context.pushNamed('edit-profile', extra: userState.user);
              },
              child: Text(
                AppLocalizations.of(context)!.edit,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6B4EFF),
                ),
              ),
            ),
          ),

          // Avatar
          userState.user!.avatarUrl != null &&
                  userState.user!.avatarUrl!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: CachedNetworkImage(
                    width: 120,
                    height: 120,
                    filterQuality: FilterQuality.high,
                    imageUrl: userState.user!.avatarUrl!,
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
                    width: 120,
                    height: 120,
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
          const SizedBox(height: 20),

          Text(
            userState.user!.fullName,
            style: GoogleFonts.quicksand(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Divider(color: Colors.grey.shade200, height: 1),
          ),

          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoField(
                  AppLocalizations.of(context)!.fullName,
                  userState.user!.fullName,
                ),
                const SizedBox(height: 20),
                _buildInfoField(
                  AppLocalizations.of(context)!.mobileNumber,
                  userState.user!.phoneNumber ?? 'Not set',
                ),
                const SizedBox(height: 20),
                _buildInfoField('Email', userState.user!.email),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.quicksand(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<UserAddressBloc>(),
              child: AddMyAddressPage(addressName: 'Custom'),
            ),
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: BorderSide(color: Colors.black.withValues(alpha: 0.3)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        icon: const PhosphorIcon(PhosphorIconsRegular.plus, size: 18),
        label: Text(
          AppLocalizations.of(context)!.add,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyProfileShimmer extends StatelessWidget {
  const MyProfileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color skeletonColor = Colors.grey.shade300;

    return Shimmer(
      duration: const Duration(seconds: 2),
      color: Colors.white,
      colorOpacity: 0.5,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 32),

          Container(
            height: 24,
            width: 140,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 16),

          ...List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                height: 84,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
