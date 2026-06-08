import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/bottom_sheet_helper.dart';
import 'package:healio_app/core/utils/currency_formart.dart';
import 'package:healio_app/core/utils/date_time_helper.dart';
import 'package:healio_app/features/user/home/data/models/category_model.dart';
import 'package:healio_app/features/user/home/data/models/service_model.dart';
import 'package:healio_app/features/user/home/data/models/staff_model.dart';
import 'package:healio_app/features/user/home/presentation/bloc/booking_cubit.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SelectServiceScreen extends StatefulWidget {
  const SelectServiceScreen({super.key, required this.categories});
  final List<CategoryModel> categories;

  @override
  State<SelectServiceScreen> createState() => _SelectServiceScreenState();
}

class _SelectServiceScreenState extends State<SelectServiceScreen> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateOffsets());

    _contentScrollController.addListener(_onContentScroll);
  }

  @override
  void dispose() {
    _contentScrollController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

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

  void _onContentScroll() {
    if (_isClickScrolling || _categoryOffsets.isEmpty) return;

    final scrollOffset = _contentScrollController.offset;
    int activeIndex = 0;

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

  Future<void> _onTabTapped(int index) async {
    setState(() {
      _isClickScrolling = true;
      _selectedIndex = index;
    });

    _scrollToTab(index);

    _calculateOffsets();

    if (_categoryOffsets.isNotEmpty && index < _categoryOffsets.length) {
      final targetOffset = _categoryOffsets[index];
      await _contentScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutQuart,
      );
    }

    _isClickScrolling = false;
  }

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

  Future<List<StaffModel>> _fetchProfessional(
    List<ServiceModel> services,
  ) async {
    final store = context.read<BookingCubit>().state.currentStore;
    if (store == null) return [];

    try {
      final response = await Supabase.instance.client
          .from('members')
          .select()
          .eq('store_id', store.id)
          .eq('is_active', true)
          .order('id', ascending: true);

      return response.map((item) => StaffModel.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error fetching professionals: $e');
      return [];
    }
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
                              onExit: () => Navigator.popUntil(
                                context,
                                (route) =>
                                    route.settings.name == 'store-detail',
                              ),
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
                    AppLocalizations.of(context)!.services,
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
                            _selectedServices.length.toString() +
                                ' ' +
                                AppLocalizations.of(context)!.services2,
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
                    onPressed: () async {
                      context.read<BookingCubit>().selectServices(
                        _selectedServices,
                      );

                      final store = context
                          .read<BookingCubit>()
                          .state
                          .currentStore!;
                      if (store.storeType == 'team') {
                        final professionals = await _fetchProfessional(
                          _selectedServices,
                        );
                        context.pushNamed(
                          'select-professional',
                          extra: professionals,
                        );
                      } else {
                        context.pushNamed('select-datetime');
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.zero,
                      minimumSize: Size(120, 50),
                      maximumSize: Size(120, 50),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.continuee,
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
                  CurrencyFormart.formatVND(item.price),
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
