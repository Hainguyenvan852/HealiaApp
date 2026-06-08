import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/core/utils/date_time_helper.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/user/auth/domain/usecases/check_current_user_usecase.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/home/data/models/category_model.dart';
import 'package:healio_app/features/user/home/data/models/review_model.dart';
import 'package:healio_app/features/user/home/data/models/store_working_hour_model.dart';
import 'package:healio_app/features/user/home/presentation/bloc/booking_cubit.dart';
import 'package:healio_app/features/user/home/presentation/bloc/store_bloc.dart';
import 'package:healio_app/features/user/home/presentation/bloc/store_infomation_cubit.dart';
import 'package:healio_app/features/user/home/presentation/widgets/category_tabbar_view.dart';
import 'package:healio_app/features/user/home/presentation/widgets/image_slide.dart';
import 'package:healio_app/features/user/home/presentation/widgets/rating_line.dart';
import 'package:healio_app/features/user/home/presentation/widgets/store_card_1.dart';
import 'package:healio_app/features/user/home/presentation/widgets/store_detail_page_shimmer.dart';
import 'package:healio_app/features/user/profile/presentation/blocs/favorite_store_cubit.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:lottie/lottie.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class StoreDetailPage extends StatefulWidget {
  const StoreDetailPage({super.key});

  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> {
  int countTotalSevices(List<CategoryModel> categories) {
    int total = 0;
    for (var item in categories) {
      total += item.services != null ? item.services!.length : 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreInfomationCubit, StoreInfomationState>(
      listenWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      listener: (context, state) {
        if (state.error != null) {
          SnackBarHelper.showError(state.error.toString());
        }
      },
      builder: (context, state) {
        if (state.isLoading ||
            state.error != null ||
            state.currentStore == null) {
          return StoreDetailPageShimmer();
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            physics: const ScrollPhysics(),
            slivers: [
              StoreDetailAppBar(state: state),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStoreHeader(store: state.currentStore!),
                      BuildCategoryList(categories: state.categories),
                      state.reviews.isNotEmpty
                          ? BuildReviewList(
                              reviews: state.reviews,
                              store: state.currentStore!,
                            )
                          : SizedBox.shrink(),
                      BuildStoreIntro(store: state.currentStore!),
                      const SizedBox(height: 30),
                      BuildOpenTime(times: state.workingHours),
                      const SizedBox(height: 30),
                      BuildAddInformation(store: state.currentStore!),
                      const SizedBox(height: 50),
                      Text(
                        AppLocalizations.of(context)!.venuesNearby,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 10),
                      StoreHorizontalList(stores: state.nearbyStores),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomSheet: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.black.withValues(alpha: 0.15)),
              ),
            ),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${countTotalSevices(state.categories)} ${AppLocalizations.of(context)!.servicesAvailable}',
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
                FilledButton(
                  onPressed: () => context.pushNamed(
                    'select-service',
                    extra: state.categories,
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.zero,
                    minimumSize: Size(120, 50),
                    maximumSize: Size(120, 50),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.bookNow,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStoreHeader({required StoreModel store}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          store.name,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 5),
        store.rating == 0
            ? Text(
                AppLocalizations.of(context)!.noRatingYet,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black54,
                ),
              )
            : Row(
                children: [
                  Text(
                    store.rating.toStringAsFixed(1),
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 5),
                  RatingLine(rating: store.rating, iconSize: 20),
                  const SizedBox(width: 5),
                  Text(
                    '(${store.ratingNumber.toString()})',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ],
              ),
        const SizedBox(height: 2),
        Row(
          children: [
            if (store.distance != null)
              Text(
                store.distance!.toStringAsFixed(1) + ' km',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            if (store.distance != null) const SizedBox(width: 5),
            if (store.distance != null)
              Icon(Icons.fiber_manual_record, size: 5, color: Colors.black45),
            if (store.distance != null) const SizedBox(width: 5),
            Expanded(
              child: Text(
                store.address,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class StoreDetailAppBar extends StatefulWidget {
  const StoreDetailAppBar({super.key, required this.state});
  final StoreInfomationState state;

  @override
  State<StoreDetailAppBar> createState() => _StoreDetailAppBarState();
}

class _StoreDetailAppBarState extends State<StoreDetailAppBar>
    with TickerProviderStateMixin {
  late bool showLottie;
  late AnimationController _lottieController;
  List<String> images = [];

  Future<void> _callStore() async {
    if (widget.state.currentStore!.phoneNumber.isNotEmpty) {
      final url = Uri.parse('tel:${widget.state.currentStore!.phoneNumber}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        SnackBarHelper.showError('Could not launch phone app');
      }
    } else {
      SnackBarHelper.showError('No phone number available');
    }
  }

  Future<void> _emailStore() async {
    if (widget.state.currentStore!.email.isNotEmpty) {
      final url = Uri.parse('mailto:${widget.state.currentStore!.email}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        SnackBarHelper.showError('Could not launch email app');
      }
    } else {
      SnackBarHelper.showError('No email available');
    }
  }

  Future<void> _shareStore(double lat, double lng) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    final String shareContent =
        'Check out this amazing store: ${widget.state.currentStore!.name}';
    await SharePlus.instance.share(
      ShareParams(
        uri: Uri.parse(googleMapsUrl),
        title: shareContent,
        subject:
            'Find amazing stores near you at ${widget.state.currentStore!.address}',
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    images.addAll(widget.state.images.map((item) => item.imageUrl));

    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _lottieController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          showLottie = false;
        });
      }
    });

    if (widget.state.isFavorite != null) {
      showLottie = widget.state.isFavorite!;
      _lottieController.forward();
    } else {
      showLottie = false;
    }
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      stretch: true,
      pinned: true,
      backgroundColor: Colors.white,
      leadingWidth: 50,
      scrolledUnderElevation: 0,
      leading: GestureDetector(
        onTap: () {
          context.read<StoreInfomationCubit>().clearState();
          context.read<BookingCubit>().clearState();
          context.pop();
        },
        child: Container(
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: PhosphorIcon(PhosphorIcons.arrowLeft(), size: 22),
        ),
      ),
      actions: [
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            alignment: Alignment.center,
            customButton: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: PhosphorIcon(
                PhosphorIcons.dotsThreeOutlineVertical(),
                size: 22,
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              width: 130,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              offset: const Offset(0, -10),
            ),
            onChanged: (value) {},
            items: [
              DropdownItem(
                onTap: () => _shareStore(
                  widget.state.currentStore!.latitude,
                  widget.state.currentStore!.longitude,
                ),
                value: 'share',
                child: Row(
                  children: [
                    PhosphorIcon(PhosphorIcons.shareNetwork(), size: 22),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)!.share,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              DropdownItem(
                onTap: () => _callStore(),
                value: 'call',
                child: Row(
                  children: [
                    PhosphorIcon(PhosphorIcons.phoneCall(), size: 22),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)!.contact,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              DropdownItem(
                onTap: () => _emailStore(),
                value: 'email',
                child: Row(
                  children: [
                    PhosphorIcon(PhosphorIcons.envelopeSimple(), size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'Email',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () async {
            final user = inj<CheckCurrentUserUseCase>().call();
            if (user != null && widget.state.isFavorite != null) {
              if (!widget.state.isFavorite!) {
                _lottieController.forward();
                context.read<StoreInfomationCubit>().addFavoriteStore(
                  user.id,
                  widget.state.currentStore!.id,
                );
                context.read<FavoriteStoreCubit>().addFavorite(
                  user.id,
                  widget.state.currentStore!,
                );
                setState(() {
                  showLottie = true;
                });
              } else {
                _lottieController.reverse();
                context.read<StoreInfomationCubit>().removeFavoriteStore(
                  user.id,
                  widget.state.currentStore!.id,
                );
                context.read<FavoriteStoreCubit>().removeFavorite(
                  user.id,
                  widget.state.currentStore!,
                );
              }
            } else {
              final String currentPath = GoRouterState.of(
                context,
              ).uri.toString();
              context.push('/login?from=$currentPath');
            }
          },
          child: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                showLottie
                    ? SizedBox(
                        height: 55,
                        width: 55,
                        child: Lottie.asset(
                          'assets/animations/like.json',
                          controller: _lottieController,
                          fit: BoxFit.cover,
                        ),
                      )
                    : PhosphorIcon(PhosphorIcons.heart(), size: 22),
              ],
            ),
          ),
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final top = constraints.biggest.height;
          final collapsedHeight =
              MediaQuery.of(context).padding.top + kToolbarHeight + 50;
          final isCollapsed = top <= collapsedHeight;

          return FlexibleSpaceBar(
            centerTitle: true,
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isCollapsed ? 1.0 : 0.0,
              child: SizedBox(
                width: 200,
                child: Text(
                  widget.state.currentStore!.name,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            background: StoreImageSlider(images: images),
          );
        },
      ),
    );
  }
}

class BuildCategoryList extends StatefulWidget {
  const BuildCategoryList({super.key, required this.categories});

  final List<CategoryModel> categories;

  @override
  State<BuildCategoryList> createState() => _BuildCategoryListState();
}

class _BuildCategoryListState extends State<BuildCategoryList>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: widget.categories.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          AppLocalizations.of(context)!.services,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 30),

        TabBar(
          controller: _tabController,
          isScrollable: true,
          dividerHeight: 0,
          splashFactory: NoSplash.splashFactory,
          splashBorderRadius: BorderRadius.circular(25),
          indicatorColor: Colors.transparent,
          tabAlignment: TabAlignment.start,
          labelPadding: EdgeInsets.zero,
          onTap: (index) => setState(() {}),
          tabs: widget.categories
              .map(
                (item) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color:
                        widget.categories.indexOf(item) == _tabController.index
                        ? Colors.black
                        : Colors.white,
                  ),
                  child: Text(
                    item.name,
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      color:
                          widget.categories.indexOf(item) ==
                              _tabController.index
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 30),
        CategoryTabBarView(
          services: widget.categories[_tabController.index].services,
        ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: () =>
              context.pushNamed('select-service', extra: widget.categories),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black.withValues(alpha: 0.15)),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.seeAll,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class BuildReviewList extends StatefulWidget {
  const BuildReviewList({
    super.key,
    required this.reviews,
    required this.store,
  });

  final List<ReviewModel> reviews;
  final StoreModel store;

  @override
  State<BuildReviewList> createState() => _BuildReviewListState();
}

class _BuildReviewListState extends State<BuildReviewList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Text(
          AppLocalizations.of(context)!.reviews1,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 20),
        RatingLine(rating: widget.store.rating, iconSize: 40),
        const SizedBox(height: 10),
        Text(
          widget.store.rating.toString() + ' (${widget.store.ratingNumber})',
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        Divider(height: 1, color: Colors.black.withValues(alpha: 0.15)),
        ListView.separated(
          padding: EdgeInsets.only(top: 10),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.reviews.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        width: 60,
                        height: 60,
                        imageUrl:
                            widget.reviews[index].avatarUrl != null &&
                                widget.reviews[index].avatarUrl!.isNotEmpty
                            ? widget.reviews[index].avatarUrl!
                            : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small_2x/default-avatar-icon-of-social-media-user-vector.jpg',
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
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.reviews[index].customerName!,
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          DateFormat(
                            "EEE, MMM dd. yyyy 'at' h:mm a",
                          ).format(widget.reviews[index].createdAt),
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                RatingLine(rating: widget.store.rating, iconSize: 20),
                if (widget.reviews[index].comment != null)
                  const SizedBox(height: 10),
                if (widget.reviews[index].comment != null)
                  Text(
                    widget.reviews[index].comment!,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 30);
          },
        ),
        SizedBox(height: 20),
        OutlinedButton(
          onPressed: () => context.pushNamed(
            'all-reviews',
            extra: {'all-reviews': widget.reviews, 'store': widget.store},
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black.withValues(alpha: 0.15)),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.seeAll,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class BuildStoreIntro extends StatefulWidget {
  const BuildStoreIntro({super.key, required this.store});
  final StoreModel store;

  @override
  State<BuildStoreIntro> createState() => _BuildStoreIntroState();
}

class _BuildStoreIntroState extends State<BuildStoreIntro> {
  bool isReadMore = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          AppLocalizations.of(context)!.about,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 10),
        !isReadMore
            ? Text(
                '\"${widget.store.introduction}\"',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Colors.black,
                ),
              )
            : Text(
                '\"${widget.store.introduction}\"',
                textAlign: TextAlign.justify,
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
        !isReadMore && widget.store.introduction.length > 50
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isReadMore = true;
                  });
                },
                child: Text(
                  AppLocalizations.of(context)!.readMore,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

class BuildOpenTime extends StatelessWidget {
  const BuildOpenTime({super.key, required this.times});
  final List<StoreWorkingHourModel> times;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.openingTimes,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        ListView.separated(
          padding: EdgeInsets.only(top: 10),
          shrinkWrap: true,
          itemCount: times.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Icon(
                      Icons.fiber_manual_record,
                      size: 18,
                      color: times[index].isDayOff
                          ? Colors.black.withValues(alpha: 0.15)
                          : const Color.fromARGB(255, 93, 214, 97),
                    ),
                    Text(
                      DateTimeHelper.intToDayOfWeek(times[index].dayOfWeek),
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  DateTimeHelper.transformTime24To12(
                        times[index].startTime.hour,
                        times[index].startTime.minute,
                      ) +
                      ' - ' +
                      DateTimeHelper.transformTime24To12(
                        times[index].endTime.hour,
                        times[index].endTime.minute,
                      ),
                  style: GoogleFonts.quicksand(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 15);
          },
        ),
      ],
    );
  }
}

class BuildAddInformation extends StatelessWidget {
  const BuildAddInformation({super.key, required this.store});
  final StoreModel store;

  Future<void> openMap(double lat, double lng) async {
    Uri mapUri;

    if (Platform.isAndroid) {
      mapUri = Uri.parse('geo:$lat,$lng?q=$lat,$lng');
    } else if (Platform.isIOS) {
      mapUri = Uri.parse('http://maps.apple.com/?ll=$lat,$lng&q=$lat,$lng');
    } else {
      mapUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );
    }

    if (await canLaunchUrl(mapUri)) {
      await launchUrl(mapUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Cannot launch to coordinates: $lat, $lng';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tileKey = dotenv.env['GOONG_MAP_TILE_KEY'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.additionalInformation,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          spacing: 10,
          children: [
            Icon(Icons.check_rounded, size: 20),
            Text(
              AppLocalizations.of(context)!.instantConfirmation,
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 230,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                IgnorePointer(
                  child: MapLibreMap(
                    styleString:
                        "https://tiles.goong.io/assets/goong_map_web.json?api_key=$tileKey",
                    initialCameraPosition: CameraPosition(
                      target: LatLng(store.latitude, store.longitude),
                      zoom: 13.0,
                    ),
                    compassEnabled: false,
                    zoomGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                  ),
                ),

                CustomPaint(
                  size: const Size(40, 50),
                  painter: RatingMarkerPainter(
                    rating: store.rating.toStringAsFixed(1),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          store.address,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        GestureDetector(
          onTap: () => openMap(store.latitude, store.longitude),
          child: Text(
            AppLocalizations.of(context)!.getDirections,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ),
      ],
    );
  }
}

class RatingMarkerPainter extends CustomPainter {
  final String rating;

  RatingMarkerPainter({required this.rating});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. CẤU HÌNH KÍCH THƯỚC
    const double width = 80 / 2;
    const double height = 50 / 2;
    const double tailHeight = 15 / 2;
    const double tailWidth = 18 / 2;
    const double cornerRadius = 25.0 / 2;

    const double shadowBlur = 8.0 / 2;
    const double shadowOffset = 5.0 / 2;

    // Dịch bút vẽ vào trong để chừa lề cho bóng đổ
    canvas.translate(shadowBlur, shadowBlur);

    // 2. KHỞI TẠO BÚT VẼ (Đã đổi thành nền Đen)
    final Paint mainPaint = Paint()..color = Colors.black;

    // Bút vẽ bóng đổ
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, shadowBlur);

    // 3. VẼ ĐƯỜNG BAO (PATH)
    final Path path = Path();
    path.moveTo(cornerRadius, 0);
    path.lineTo(width - cornerRadius, 0);
    path.arcToPoint(
      const Offset(width, cornerRadius),
      radius: const Radius.circular(cornerRadius),
    );
    path.lineTo(width, height - cornerRadius);
    path.arcToPoint(
      const Offset(width - cornerRadius, height),
      radius: const Radius.circular(cornerRadius),
    );
    path.lineTo(width / 2 + tailWidth / 2, height);
    path.lineTo(width / 2, height + tailHeight); // Mũi nhọn đuôi
    path.lineTo(width / 2 - tailWidth / 2, height);
    path.lineTo(cornerRadius, height);
    path.arcToPoint(
      const Offset(0, height - cornerRadius),
      radius: const Radius.circular(cornerRadius),
    );
    path.lineTo(0, cornerRadius);
    path.arcToPoint(
      const Offset(cornerRadius, 0),
      radius: const Radius.circular(cornerRadius),
    );
    path.close();

    // 4. THỰC HIỆN VẼ
    canvas.drawPath(path.shift(const Offset(0, shadowOffset)), shadowPaint);
    canvas.drawPath(path, mainPaint);

    // 5. VẼ CHỮ (Đã đổi thành chữ Trắng)
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: rating,
        style: const TextStyle(
          color: Colors.white, // Chữ màu trắng
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    textPainter.layout();

    // Căn giữa chữ
    final double textX = (width - textPainter.width) / 2;
    final double textY = (height - textPainter.height) / 2;

    textPainter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Nếu điểm đánh giá thay đổi thì mới cần vẽ lại
    if (oldDelegate is RatingMarkerPainter) {
      return oldDelegate.rating != rating;
    }
    return false;
  }
}

class StoreHorizontalList extends StatelessWidget {
  const StoreHorizontalList({super.key, required this.stores});
  final List<StoreModel> stores;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return StoreCard1(
            store: stores[index],
            onTap: () {
              final user = inj<CheckCurrentUserUseCase>().call();

              context.read<StoreBloc>().add(
                AddRecentlyStore(stores[index].id.toString()),
              );
              context.read<BookingCubit>().selectStore(stores[index]);
              context.read<StoreInfomationCubit>().clearState();
              context.read<StoreInfomationCubit>().loadInfomationStore(
                stores[index],
                user != null ? user.id : null,
              );
              context.pushNamed('store-detail');
            },
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: 15);
        },
        itemCount: 5,
      ),
    );
  }
}
