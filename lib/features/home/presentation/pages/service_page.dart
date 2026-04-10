import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/core/utils/bottom_sheet_helper.dart';
import 'package:healio_app/core/utils/currency_formart.dart';
import 'package:healio_app/core/utils/date_time_helper.dart';
import 'package:healio_app/features/explore/domain/usecases/get_team_member_by_service_usecase.dart';
import 'package:healio_app/features/home/data/models/category_model.dart';
import 'package:healio_app/features/home/data/models/service_model.dart';
import 'package:healio_app/features/home/data/models/team_member_model.dart';
import 'package:healio_app/features/home/presentation/bloc/booking_cubit.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key, required this.categories});
  final List<CategoryModel> categories;

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final ScrollController _contentScrollController = ScrollController();
  final ScrollController _tabScrollController = ScrollController();
  final GlobalKey _scrollViewKey = GlobalKey(); // Key của vùng cuộn chính

  int _selectedIndex = 0;
  bool _isClickScrolling = false;
  List<double> _categoryOffsets = [];
  final List<ServiceModel> _selectedServices = [];
  double _totalPrice = 0;
  int _totalDuration = 0;

  @override
  void initState() {
    super.initState();
    // Tính toán tọa độ (offset) của từng danh mục sau khi UI đã render xong
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateOffsets());

    // Lắng nghe sự kiện cuộn danh sách
    _contentScrollController.addListener(_onContentScroll);
  }

  @override
  void dispose() {
    _contentScrollController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  // Hàm tính toán vị trí Y của từng danh mục
  void _calculateOffsets() {
    if (_scrollViewKey.currentContext == null) return;
    final RenderBox scrollBox =
        _scrollViewKey.currentContext!.findRenderObject() as RenderBox;

    _categoryOffsets = widget.categories.map((category) {
      if (category.key.currentContext == null) return 0.0;
      final RenderBox box =
          category.key.currentContext!.findRenderObject() as RenderBox;
      // Tính offset tương đối so với ScrollView
      final offset = box.localToGlobal(Offset.zero, ancestor: scrollBox);
      return offset.dy + _contentScrollController.offset;
    }).toList();
  }

  // Khi cuộn danh sách bằng tay -> Cập nhật Tab
  void _onContentScroll() {
    if (_isClickScrolling || _categoryOffsets.isEmpty) return;

    final scrollOffset = _contentScrollController.offset;
    int activeIndex = 0;

    // Tìm danh mục đang nằm ở vị trí trên cùng (kèm theo một chút sai số bù trừ ~50px)
    for (int i = 0; i < _categoryOffsets.length; i++) {
      if (scrollOffset >= _categoryOffsets[i] - 50) {
        activeIndex = i;
      }
    }

    if (_selectedIndex != activeIndex) {
      setState(() => _selectedIndex = activeIndex);
      _scrollToTab(activeIndex);
    }
  }

  // Khi bấm vào Tab -> Cuộn danh sách tới danh mục tương ứng
  Future<void> _onTabTapped(int index) async {
    setState(() {
      _isClickScrolling = true;
      _selectedIndex = index;
    });

    _scrollToTab(index);

    // Tính toán lại offset một lần nữa cho chắc chắn nếu UI bị thay đổi
    _calculateOffsets();

    if (_categoryOffsets.isNotEmpty && index < _categoryOffsets.length) {
      final targetOffset = _categoryOffsets[index];
      await _contentScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutQuart,
      );
    }

    // Mở khóa cờ sau khi cuộn xong
    _isClickScrolling = false;
  }

  // Giữ Tab đang active luôn nằm trong tầm nhìn của thanh trượt ngang
  void _scrollToTab(int index) {
    double targetOffset = index * 80.0;
    if (_tabScrollController.hasClients) {
      _tabScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<List<TeamMemberModel>> _fetchProfessional(List<ServiceModel> services) async {
    List<TeamMemberModel> professionals = [];

    for (var item in services) {
      final result = await inj<GetTeamMemberByServiceUseCase>().call(item.id);
      if (result.isNotEmpty) {
        professionals.addAll(result);
      }
    }

    return professionals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: PhosphorIcon(
                          PhosphorIcons.arrowLeft(),
                          size: 25,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_selectedServices.isNotEmpty) {
                            BottomSheetHelper.showExitConfirmationBottomSheet(
                              context: context,
                              onExit: () => context.pop(),
                            );
                          } else {
                            context.pop();
                          }
                        },
                        child: PhosphorIcon(PhosphorIcons.x(), size: 25),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Services',
                    style: GoogleFonts.quicksand(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 40,
              child: ListView.builder(
                controller: _tabScrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: widget.categories.length,
                itemBuilder: (context, index) {
                  final isActive = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () => _onTabTapped(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.black : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          widget.categories[index].name,
                          style: GoogleFonts.quicksand(
                            color: isActive ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                key: _scrollViewKey,
                controller: _contentScrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Dấu 3 chấm giúp tách bóc và đưa từng phần tử trong map vào children
                    ...widget.categories.map(
                      (category) => _buildCategorySection(category),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _selectedServices.isNotEmpty
          ? Container(
              height: MediaQuery.of(context).size.height * 0.1,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        CurrencyFormart.formatVND(_totalPrice),
                        style: GoogleFonts.quicksand(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          PhosphorIcon(PhosphorIcons.shoppingBag(), size: 20),
                          const SizedBox(width: 10),
                          Text(
                            _selectedServices.length.toString() + ' services',
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.fiber_manual_record,
                            size: 5,
                            color: Colors.black45,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            DateTimeHelper.minuteToHourAndMinute(
                              _totalDuration,
                            ),
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  FilledButton(
                    onPressed: () async{
                      context.read<BookingCubit>().selectServices(_selectedServices);
                      final professionals = await _fetchProfessional(_selectedServices);
                      if(professionals.isEmpty){
                        context.push('/home/store-detail/select-datetime');
                      } else{
                        context.push('/home/store-detail/select-professional', extra: professionals);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.zero,
                      minimumSize: Size(120, 50),
                      maximumSize: Size(120, 50),
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildCategorySection(CategoryModel category) {
    return Container(
      key: category.key,
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.name,
            style: GoogleFonts.quicksand(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (category.services != null)
            ...category.services!.map((item) => _buildServiceItem(item))
          else
            SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildServiceItem(ServiceModel item) {
    final bool isSelected = _selectedServices.contains(item);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateTimeHelper.minuteToHourAndMinute(item.duration),
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.priceType != 'fix'
                      ? (item.priceType != 'from'
                            ? 'Free'
                            : 'From ' + CurrencyFormart.formatVND(item.price))
                      : CurrencyFormart.formatVND(item.price),
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedServices.remove(item);
                  _totalPrice -= item.price;
                  _totalDuration -= item.duration;
                } else {
                  _selectedServices.add(item);
                  _totalPrice += item.price;
                  _totalDuration += item.duration;
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 35,
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isSelected
                    ? null
                    : Border.all(color: Colors.grey.shade300),
                color: isSelected ? Colors.purple : Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    color: isSelected
                        ? Colors.purple.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.15),
                    spreadRadius: 0,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                isSelected ? Icons.check : Icons.add,
                size: 20,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
