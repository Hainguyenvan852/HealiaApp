import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SlidingUpHeader extends StatelessWidget {
  const SlidingUpHeader({super.key, this.onVerticalDragUpdate});
  final void Function(DragUpdateDetails)? onVerticalDragUpdate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent, // Bắt sự kiện ngay cả vùng trống
            onVerticalDragUpdate: onVerticalDragUpdate,
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.transparent,
              child: Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ActionChip(
                      label: PhosphorIcon(
                        PhosphorIcons.faders(),
                        size: 20,
                      ),
                      onPressed: (){},
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      )
                  ),
                  const SizedBox(width: 10,),
                  ActionChip(
                      label: Row(
                        children: [
                          Text(
                            'Best match',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Icon(Icons.keyboard_arrow_down, size: 20,)
                        ],
                      ),
                      onPressed: (){},
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                      )
                  ),
                  const SizedBox(width: 10,),
                  ActionChip(
                      label: Row(
                        children: [
                          Text('Amenities',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Icon(Icons.keyboard_arrow_down, size: 20,)
                        ],
                      ),
                      onPressed: (){},
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                      )
                  ),
                  const SizedBox(width: 10,),
                  ActionChip(
                      label: Row(
                        children: [
                          Text('Price',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Icon(Icons.keyboard_arrow_down, size: 20,)
                        ],
                      ),
                      onPressed: (){},
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                      )
                  ),
                  const SizedBox(width: 10,),
                  ActionChip(
                      label: Row(
                        children: [
                          Text('Options',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Icon(Icons.keyboard_arrow_down, size: 20,)
                        ],
                      ),
                      onPressed: (){},
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                      )
                  ),
                  const SizedBox(width: 10,),
                  ActionChip(
                      label: Row(
                        children: [
                          PhosphorIcon(
                            PhosphorIcons.sealCheck(),
                            size: 20,
                          ),
                          const SizedBox(width: 5,),
                          Text('Only verified',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      onPressed: (){},
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                      )
                  ),
                  const SizedBox(width: 10,),
                  ActionChip(
                      label: Row(
                        children: [
                          Text('Type',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Icon(Icons.keyboard_arrow_down, size: 20,)
                        ],
                      ),
                      onPressed: (){},
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                      )
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
