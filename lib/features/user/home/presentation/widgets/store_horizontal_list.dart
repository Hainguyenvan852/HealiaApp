import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/user/auth/domain/usecases/check_current_user_usecase.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/home/presentation/bloc/booking_cubit.dart';
import 'package:healio_app/features/user/home/presentation/bloc/store_infomation_cubit.dart';
import 'package:healio_app/features/user/home/presentation/widgets/store_card_1.dart';

import '../bloc/store_bloc.dart';

class StoreHorizontalList extends StatelessWidget {
  const StoreHorizontalList({super.key, required this.stores});
  final List<StoreModel> stores;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
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
                context.read<StoreInfomationCubit>().loadInfomationStore(stores[index], user != null ? user.id : null);
                context.pushNamed('store-detail');
              },
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(width: 10);
          },
          itemCount: stores.length,
        ),
      ),
    );
  }
}
