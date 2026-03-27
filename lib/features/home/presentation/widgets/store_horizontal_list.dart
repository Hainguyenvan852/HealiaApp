import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/home/presentation/widgets/store_card_1.dart';

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
            itemBuilder: (context, index){
              return StoreCard1(store: stores[index], onTap: () {
                context.read<StoreBloc>().add(AddRecentlyStore(stores[index].id.toString()));
              },);
            },
            separatorBuilder:(context, index){
              return SizedBox(width: 10,);
            },
            itemCount: stores.length
        ),
      ),
    );
  }
}
