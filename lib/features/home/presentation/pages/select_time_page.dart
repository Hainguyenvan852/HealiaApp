import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/bottom_sheet_helper.dart';
import 'package:healio_app/features/home/data/models/team_member_model.dart';
import 'package:healio_app/features/home/presentation/bloc/booking_cubit.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';

class SelectTimePage extends StatefulWidget {
  const SelectTimePage({
    super.key,
    this.professionals,
    this.selectedProfessional,
  });
  final List<TeamMemberModel>? professionals;
  final TeamMemberModel? selectedProfessional;

  @override
  State<SelectTimePage> createState() => _SelectTimePageState();
}

class _SelectTimePageState extends State<SelectTimePage> {
  late DateTime _selectedDate;

  late List<DateTime> _availableDates;
  TeamMemberModel? _selectedProfessional;

  late String _selectedProfessionalName;

  // Danh sách giờ giả lập (bạn có thể thay bằng API sau)
  final List<String> _timeSlots = [
    '9:00 AM',
    '9:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '1:00 PM',
    '2:30 PM',
    '3:00 PM',
    '3:30 PM',
    '4:00 PM',
    '4:30 PM',
    '5:00 PM',
    '5:30 PM',
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime(2026, 4, 5);

    _selectedProfessionalName = widget.selectedProfessional != null
        ? (widget.selectedProfessional!.id != 0
              ? widget.selectedProfessional!.fullName
              : 'Any professional')
        : 'None';

    _selectedProfessional = widget.selectedProfessional;
    _selectedDate = today;

    _availableDates = List.generate(
      60,
      (index) => today.add(Duration(days: index)),
    );
  }

  Future<TeamMemberModel?> _openProfessionalBottomSheet(
    List<TeamMemberModel> professionals,
    TeamMemberModel selectedProfessional,
  ) async {
    final response = await showModalBottomSheet<TeamMemberModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.9,
            child: SelectProfessionalScreen(
              professionals: professionals,
              selectedProfessional: selectedProfessional,
            ),
          ),
        );
      },
    );

    if (response != null) {
      return response;
    }
    return null;
  }

  void _openCalendarBottomSheet() async {
    final DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CalendarBottomSheet(initialDate: _selectedDate),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        // Nếu ngày chọn từ lịch không có trong list cuộn ngang (ngoài 60 ngày),
        // bạn có thể viết logic add thêm vào đây.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String monthYearDisplay = DateFormat('MMM yyyy').format(_selectedDate);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<BookingCubit>().clearProfessional();
                          context.pop(context);
                        },
                        child: const PhosphorIcon(
                          PhosphorIconsRegular.arrowLeft,
                          size: 25,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          BottomSheetHelper.showExitConfirmationBottomSheet(
                            context: context,
                            onExit: () {
                              context.read<BookingCubit>().clearAllExpectStore();
                              context.go('/home/store-detail');
                            },
                          );
                        },
                        child: const PhosphorIcon(
                          PhosphorIconsRegular.x,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Select time',
                    style: GoogleFonts.quicksand(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (widget.selectedProfessional != null &&
                              widget.professionals != null)
                          ? InkWell(
                              onTap: () async {
                                final result =
                                    await _openProfessionalBottomSheet(
                                      widget.professionals!,
                                      _selectedProfessional!,
                                    );

                                if (result != null) {
                                  setState(() {
                                    _selectedProfessionalName = result.fullName;
                                    _selectedProfessional = result;
                                  });
                                }
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF2EFFF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: _selectedProfessional!.id == 0
                                          ? const PhosphorIcon(
                                              PhosphorIconsRegular.user,
                                              size: 16,
                                              color: Color(0xFF5B45FF),
                                            )
                                          : (_selectedProfessional!.avatarUrl !=
                                                    null
                                                ? Image.network(
                                                    _selectedProfessional!
                                                        .avatarUrl!,
                                                    height: 30,
                                                    width: 30,
                                                    fit: BoxFit.cover,
                                                  )
                                                : const PhosphorIcon(
                                                    PhosphorIconsRegular.user,
                                                    size: 16,
                                                    color: Color(0xFF5B45FF),
                                                  )),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _selectedProfessionalName,
                                      style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const PhosphorIcon(
                                      PhosphorIconsRegular.caretDown,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),

                      InkWell(
                        onTap: _openCalendarBottomSheet,
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            shape: BoxShape.circle,
                          ),
                          child: const PhosphorIcon(
                            PhosphorIconsRegular.calendarBlank,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                monthYearDisplay,
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _availableDates.length,
                itemBuilder: (context, index) {
                  final date = _availableDates[index];
                  final isSelected =
                      date.year == _selectedDate.year &&
                      date.month == _selectedDate.month &&
                      date.day == _selectedDate.day;

                  return _buildDateItem(date, isSelected);
                },
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                itemCount: _timeSlots.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _buildTimeSlotItem(_timeSlots[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateItem(DateTime date, bool isSelected) {
    String dayNumber = DateFormat('d').format(date);
    String dayOfWeek = DateFormat('E').format(date);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF5B45FF)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF5B45FF)
                      : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  dayNumber,
                  style: GoogleFonts.quicksand(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              dayOfWeek,
              style: GoogleFonts.quicksand(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotItem(String time) {
    return InkWell(
      onTap: () {
        context.read<BookingCubit>().selectDateTime(_selectedDate, TimeOfDay(hour: 12, minute: 0));
        context.push('/home/store-detail/review-confirm');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          time,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class CalendarBottomSheet extends StatefulWidget {
  final DateTime initialDate;
  const CalendarBottomSheet({super.key, required this.initialDate});

  @override
  State<CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  late DateTime _displayedMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      1,
    );
  }

  void _changeMonth(int offset) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + offset,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String monthYearDisplay = DateFormat('MMMM yyyy').format(_displayedMonth);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Thanh gạt Drag Handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft),
                    onPressed: () => _changeMonth(-1),
                  ),
                  Text(
                    monthYearDisplay,
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const PhosphorIcon(PhosphorIconsRegular.caretRight),
                    onPressed: () => _changeMonth(1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Lưới Lịch
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildCalendarGrid(),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    const List<String> weekDays = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];

    int firstDayWeekday = _displayedMonth.weekday;
    if (firstDayWeekday == 7) firstDayWeekday = 0;

    int daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;

    int totalCells = firstDayWeekday + daysInMonth;
    int rows = (totalCells / 7).ceil();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rows * 7,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            if (index < firstDayWeekday || index >= totalCells) {
              return const SizedBox();
            }

            int dayNumber = index - firstDayWeekday + 1;
            DateTime cellDate = DateTime(
              _displayedMonth.year,
              _displayedMonth.month,
              dayNumber,
            );

            bool isSelected =
                cellDate.year == _selectedDate.year &&
                cellDate.month == _selectedDate.month &&
                cellDate.day == _selectedDate.day;

            return GestureDetector(
              onTap: () {
                Navigator.pop(context, cellDate);
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF5B45FF)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF5B45FF)
                        : Colors.transparent,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$dayNumber',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class SelectProfessionalScreen extends StatefulWidget {
  const SelectProfessionalScreen({
    super.key,
    required this.professionals,
    required this.selectedProfessional,
  });
  final List<TeamMemberModel> professionals;
  final TeamMemberModel selectedProfessional;

  @override
  State<SelectProfessionalScreen> createState() =>
      _SelectProfessionalScreenState();
}

class _SelectProfessionalScreenState extends State<SelectProfessionalScreen> {
  late int _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedProfessional.id;
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const PhosphorIcon(
                          PhosphorIconsRegular.x,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Select professional',
                    style: GoogleFonts.quicksand(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: widget.professionals.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.grey.shade200, height: 1),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildNoPreference(_selectedId == 0);
                  }
                  final item = widget.professionals[index];
                  final isSelected = _selectedId == item.id;
                  return _buildProfessionalItem(item, isSelected);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalItem(TeamMemberModel item, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          _buildAvatar(item),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.fullName,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (item.jobTitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.jobTitle,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: isSelected ? _buildVerifyIcon() : _buildSelectButton(item),
          ),
        ],
      ),
    );
  }

  Widget _buildNoPreference(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF2EFFF),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: PhosphorIcon(
                PhosphorIconsRegular.users,
                color: Color(0xFF5B45FF),
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No preference',
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'for maximum availability',
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: isSelected
                ? _buildVerifyIcon()
                : OutlinedButton(
                    key: const ValueKey('select_btn'),
                    onPressed: () {
                      setState(() {
                        _selectedId = 0;
                      });
                      context.read<BookingCubit>().selectProfessional(
                        TeamMemberModel(
                          id: 0,
                          fullName: 'Any professional',
                          email: '',
                          phoneNumber: '',
                          jobTitle: '',
                          birthDay: DateTime(2026),
                          startDate: DateTime(2026),
                        ),
                      );
                      Navigator.pop(
                        context,
                        TeamMemberModel(
                          id: 0,
                          fullName: 'Any professional',
                          email: '',
                          phoneNumber: '',
                          jobTitle: '',
                          birthDay: DateTime(2026),
                          startDate: DateTime(2026),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      disabledForegroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      minimumSize: const Size(0, 36),
                    ),
                    child: Text(
                      'Select',
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(TeamMemberModel item) {
    if (item.id == 0) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFF2EFFF),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: PhosphorIcon(
            PhosphorIconsRegular.users,
            color: Color(0xFF5B45FF),
            size: 28,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey.shade200,
      backgroundImage: NetworkImage(item.avatarUrl ?? ''),
      onBackgroundImageError: (e, s) {},
    );
  }

  Widget _buildSelectButton(TeamMemberModel item) {
    return OutlinedButton(
      key: const ValueKey('select_btn'),
      onPressed: () {
        if (_selectedId != item.id) {
          setState(() {
            _selectedId = item.id;
          });

          context.read<BookingCubit>().selectProfessional(
            widget.professionals.singleWhere((item) => item.id == _selectedId),
          );

          Navigator.pop(
            context,
            widget.professionals.singleWhere((item) => item.id == _selectedId),
          );
        }
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        disabledForegroundColor: Colors.black,
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        minimumSize: const Size(0, 36),
      ),
      child: Text(
        'Select',
        style: GoogleFonts.quicksand(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildVerifyIcon() {
    return Container(
      key: const ValueKey('verify_icon'),
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: Color(0xFF5B45FF),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: PhosphorIcon(
          PhosphorIconsRegular.check,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
