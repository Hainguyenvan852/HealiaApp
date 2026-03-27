import 'package:flutter/material.dart';
import 'package:healio_app/features/explore/data/models/store_model.dart';
import 'package:healio_app/features/explore/presentation/widgets/store_card_2.dart';

class StoresList extends StatelessWidget {
  const StoresList({super.key, required this.scrollCtrl, required this.stores});
  final ScrollController scrollCtrl;
  final List<StoreModel> stores;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 80.0, left: 15, right: 15),
        child: CustomScrollView(
          controller: scrollCtrl,
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                  child: Text(
                    '${stores.length} venues nearby',
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 10,),
            ),
            SliverList.separated(
              itemCount: stores.length,
              itemBuilder: (context, i){
                return StoreCard2(store: stores[i],);
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 20,);
              },
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20,),
            ),
          ],
        )
    );
  }
}
