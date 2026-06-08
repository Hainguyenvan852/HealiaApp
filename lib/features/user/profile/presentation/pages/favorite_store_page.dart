import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/home/presentation/bloc/booking_cubit.dart';
import 'package:healio_app/features/user/home/presentation/bloc/store_bloc.dart';
import 'package:healio_app/features/user/home/presentation/bloc/store_infomation_cubit.dart';
import 'package:healio_app/features/user/profile/data/models/user_model.dart';
import 'package:healio_app/features/user/profile/presentation/blocs/favorite_store_cubit.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FavoriteStoresPage extends StatefulWidget {
  const FavoriteStoresPage({super.key, required this.currentUser});
  final UserModel currentUser;

  @override
  State<FavoriteStoresPage> createState() => _FavoriteStoresPageState();
}

class _FavoriteStoresPageState extends State<FavoriteStoresPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteStoreCubit>().loadData(widget.currentUser.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<FavoriteStoreCubit, FavoriteStoreState>(
        listenWhen: (previous, current) => previous.error != current.error,
        listener: (BuildContext context, FavoriteStoreState state) {
          if (state.error != null) {
            SnackBarHelper.showError(state.error.toString());
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: ColorTheme.mainAppColor(),
                size: 50,
              ),
            );
          }
          if (state.error != null) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.somethingWentWrong,
                style: GoogleFonts.quicksand(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            );
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.favorites,
                        style: GoogleFonts.quicksand(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox.shrink(),
                    ],
                  ),
                  state.stores.isEmpty
                      ? const EmptyFavoriteList()
                      : Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            itemCount: state.stores.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 24),
                            itemBuilder: (context, index) {
                              return _buildStoreCard(state.stores[index]);
                            },
                          ),
                        ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStoreCard(StoreModel store) {
    return GestureDetector(
      onTap: () {
        context.read<StoreBloc>().add(AddRecentlyStore(store.id.toString()));
        context.read<BookingCubit>().selectStore(store);
        context.read<StoreInfomationCubit>().clearState();
        context.read<StoreInfomationCubit>().loadInfomationStore(
          store,
          widget.currentUser.id,
        );
        context.pushNamed('store-detail');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Image.network(
                store.primaryImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          Text(
            store.name,
            style: GoogleFonts.quicksand(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          Row(
            children: [
              PhosphorIcon(
                PhosphorIcons.star(PhosphorIconsStyle.fill),
                color: Color(0xFFFFB800),
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                store.rating.toString(),
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${store.ratingNumber})',
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          Text(
            '${store.address}, ${store.province}',
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black.withValues(alpha: 0.5),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          Text(
            store.primaryCategory,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyFavoriteList extends StatelessWidget {
  const EmptyFavoriteList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [
                  Color(0xFFEAD6FE),
                  Color(0xFF8E84FC),
                  Color(0xFF5B45FF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: const Icon(Icons.favorite, size: 72, color: Colors.white),
          ),
          const SizedBox(height: 24),

          Text(
            AppLocalizations.of(context)!.noFavorites,
            style: GoogleFonts.quicksand(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            AppLocalizations.of(context)!.noFavoritesMessage,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
