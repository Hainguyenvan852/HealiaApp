import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import 'package:healio_app/core/utils/currency_formart.dart';
import 'package:healio_app/core/utils/date_time_helper.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/home/data/models/service_model.dart';
import 'package:healio_app/features/user/home/domain/usecases/get_categories_usecase.dart';
import 'package:healio_app/features/user/home/domain/usecases/get_services_usecase.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../core/injector/dependency_injector.dart';
import '../../../auth/domain/usecases/check_current_user_usecase.dart';
import '../../../home/presentation/bloc/booking_cubit.dart';
import '../../../home/presentation/bloc/store_bloc.dart';
import '../../../home/presentation/bloc/store_infomation_cubit.dart';
import 'image_slide.dart';

class StoreCard2 extends StatefulWidget {
  const StoreCard2({super.key, required this.store});
  final StoreModel store;

  @override
  State<StoreCard2> createState() => _StoreCard2State();
}

class _StoreCard2State extends State<StoreCard2> {
  late final Future<List<ServiceModel>> _future;

  Future<List<ServiceModel>> _loadServices() async {
    final categories = await inj<GetCategoriesUsecase>().call(widget.store.id);

    if (categories.isNotEmpty) {
      final services = await inj<GetServicesUsecase>().call(categories[0].id);
      return services;
    }

    return [];
  }

  @override
  void initState() {
    super.initState();
    _future = _loadServices();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting ||
            asyncSnapshot.hasError) {
          return SizedBox(
            height: 250,
            child: Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: ColorTheme.mainAppColor(),
                size: 30,
              ),
            ),
          );
        }

        final services = asyncSnapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                final user = inj<CheckCurrentUserUseCase>().call();
                context.read<StoreBloc>().add(
                  AddRecentlyStore(widget.store.id.toString()),
                );
                context.read<BookingCubit>().selectStore(widget.store);
                context.read<StoreInfomationCubit>().clearState();
                context.read<StoreInfomationCubit>().loadInfomationStore(
                  widget.store,
                  user != null ? user.id : null,
                );
                context.pushNamed('store-detail');
              },
              child: StoreImageSlider(store: widget.store),
            ),
            const SizedBox(height: 15),
            widget.store.ratingNumber != 0
                ? Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: Text(
                          widget.store.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Icon(
                        FontAwesomeIcons.solidStar,
                        color: Colors.orange,
                        size: 14,
                      ),
                      Text(
                        widget.store.rating.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '(${widget.store.ratingNumber.toString()})',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : Row(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.store.name,
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.noRatingYet,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
            Row(
              spacing: 5,
              children: [
                if (widget.store.distance != null)
                  Text(
                    widget.store.distance! > 5
                        ? '> 5 km'
                        : '${widget.store.distance!.toStringAsFixed(1)} km',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (widget.store.distance != null)
                  Icon(
                    Icons.fiber_manual_record,
                    size: 5,
                    color: Colors.grey.shade700,
                  ),
                Expanded(
                  child: Text(
                    widget.store.address,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(247, 247, 247, 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            services[index].name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            CurrencyFormart.formatVND(services[index].price),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        DateTimeHelper.minuteToHourAndMinute(
                          services[index].duration,
                        ),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemCount: services.length,
            ),
            TextButton(
              onPressed: () {
                final user = inj<CheckCurrentUserUseCase>().call();
                context.read<StoreBloc>().add(
                  AddRecentlyStore(widget.store.id.toString()),
                );
                context.read<BookingCubit>().selectStore(widget.store);
                context.read<StoreInfomationCubit>().clearState();
                context.read<StoreInfomationCubit>().loadInfomationStore(
                  widget.store,
                  user != null ? user.id : null,
                );
                context.pushNamed('store-detail');
              },
              style: TextButton.styleFrom(foregroundColor: Colors.purple),
              child: Text(
                AppLocalizations.of(context)!.seeAllServices,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
