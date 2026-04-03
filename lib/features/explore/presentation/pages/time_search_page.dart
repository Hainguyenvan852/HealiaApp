import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/snackbar_helper.dart';
import 'package:healio_app/features/explore/presentation/blocs/search_cubit.dart';
import 'package:healio_app/features/explore/presentation/blocs/search_state.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/utils/date_time_helper.dart';

class TimeSearchPage extends StatefulWidget {
  const TimeSearchPage({super.key, this.date, this.startTime, this.endTime, this.timeText, this.dateText});
  final DateTime? date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String? timeText;
  final String? dateText;

  @override
  State<TimeSearchPage> createState() => _TimeSearchPageState();
}

class _TimeSearchPageState extends State<TimeSearchPage> {

  late DateTime _focusedDate;
  DateTime? _selectedDate;
  TimeOfDay? _selectedCustomTimeStart;
  TimeOfDay? _selectedCustomTimeEnd;

  late String _selectedTimeType;
  late String _selectedDateText;

  void _onClear(){
    setState(() {
      _selectedTimeType = 'Anytime';
      _selectedDateText = 'Any date';
      _selectedDate = null;
    });
  }

  void _onCancel(){
    context.pop();
  }

  void _onConfirmed(SearchFilterState state){
    if(_selectedTimeType.toLowerCase() == 'custom' && _selectedCustomTimeStart == null && _selectedCustomTimeEnd == null){
      SnackBarHelper.showError('You haven\'t selected a time yet');
    } else{
      if(_selectedTimeType.toLowerCase() == 'custom'){
        context.read<SearchFilterCubit>().updateSearch(state.copyWith(startTime: _selectedCustomTimeStart, endTime: _selectedCustomTimeEnd, date: _selectedDate, dateText: _selectedDateText, timeText: _selectedTimeType));
      } else if(_selectedTimeType.toLowerCase() == 'morning'){
        context.read<SearchFilterCubit>().updateSearch(state.copyWith(startTime: TimeOfDay(hour: 6, minute: 0), endTime: TimeOfDay(hour: 12, minute: 0), date: _selectedDate, dateText: _selectedDateText, timeText: _selectedTimeType));
      } else if(_selectedTimeType.toLowerCase() == 'afternoon'){
        context.read<SearchFilterCubit>().updateSearch(state.copyWith(startTime: TimeOfDay(hour: 12, minute: 0), endTime: TimeOfDay(hour: 17, minute: 0), date: _selectedDate, dateText: _selectedDateText, timeText: _selectedTimeType));
      } else if(_selectedTimeType.toLowerCase() == 'evening'){
        context.read<SearchFilterCubit>().updateSearch(state.copyWith(startTime: TimeOfDay(hour: 17, minute: 0), endTime: TimeOfDay(hour: 24, minute: 0), date: _selectedDate, dateText: _selectedDateText, timeText: _selectedTimeType));
      } else{
        if(_selectedTimeType == 'Anytime' && _selectedDateText == 'Any date' && _selectedDate == null){
          context.read<SearchFilterCubit>().clearDateTime(state.update(category: state.category, location: state.locationName, timeText: 'Anytime', dateText: 'Any date', startTime: null, endTime: null, date: null, address: state.address, lat: state.lat, lng: state.lng));
        } else{
          context.read<SearchFilterCubit>().updateSearch(state.copyWith(date: _selectedDate, dateText: _selectedDateText, timeText: _selectedTimeType));
        }
      }
      context.pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _focusedDate = widget.date ?? DateTime.now();
    _selectedDate = widget.date;
    _selectedCustomTimeStart = widget.startTime;
    _selectedCustomTimeEnd = widget.endTime;
    _selectedTimeType = widget.timeText ?? 'Anytime';
    _selectedDateText = widget.dateText ?? 'Any date';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchFilterCubit, SearchFilterState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                    onPressed: () => context.pop(),
                    icon: PhosphorIcon(PhosphorIcons.arrowLeft(), size: 25,)
                ),
                title: Text('Date and time',
                  style: GoogleFonts.quicksand(
                      fontSize: 19,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                        Text('Select day',
                          style: GoogleFonts.quicksand(
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDate = DateTime.now();
                                    _selectedDateText =
                                        DateFormat('MMM dd,yyyy').format(
                                            DateTime.now());
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 15),
                                  height: 95,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _selectedDate != null
                                            ? DateFormat('dd/MM/yyyy').format(
                                            _selectedDate!) ==
                                            DateFormat('dd/MM/yyyy').format(
                                                DateTime.now())
                                            ? Colors.deepPurpleAccent
                                            : Colors.black.withValues(
                                            alpha: 0.15)
                                            : Colors.black.withValues(
                                            alpha: 0.15),
                                      ),
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Today',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(DateFormat('MMM dd,yyyy').format(
                                          DateTime.now()),
                                        style: GoogleFonts.quicksand(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDate =
                                        DateTime.now().add(Duration(days: 1));
                                    DateFormat('MMM dd,yyyy').format(
                                        DateTime.now().add(Duration(days: 1)));
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 15),
                                  height: 95,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _selectedDate != null
                                            ? DateFormat('dd/MM/yyyy').format(
                                            _selectedDate!) ==
                                            DateFormat('dd/MM/yyyy').format(
                                                DateTime.now().add(
                                                    Duration(days: 1)))
                                            ? Colors.deepPurpleAccent
                                            : Colors.black.withValues(
                                            alpha: 0.15)
                                            : Colors.black.withValues(
                                            alpha: 0.15),
                                      ),
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Tomorrow',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(DateFormat('MMM dd,yyyy').format(
                                          DateTime.now().add(
                                              Duration(days: 1))),
                                        style: GoogleFonts.quicksand(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20,),
                        SizedBox(
                            height: 440,
                            child: TableCalendar(
                              focusedDay: _focusedDate,
                              firstDay: DateTime.now(),
                              lastDay: DateTime.now().add(Duration(days: 365)),
                              headerStyle: HeaderStyle(
                                titleCentered: true,
                                titleTextStyle: GoogleFonts.quicksand(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold
                                ),
                                formatButtonVisible: false,
                              ),
                              daysOfWeekHeight: 40,
                              rowHeight: 55,
                              daysOfWeekStyle: DaysOfWeekStyle(
                                weekdayStyle: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black54
                                ),
                                weekendStyle: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black54
                                ),
                              ),
                              calendarStyle: CalendarStyle(
                                outsideDaysVisible: false,
                                defaultTextStyle: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                                weekendTextStyle: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                                outsideTextStyle: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                                todayDecoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.grey, width: 1.2),
                                ),
                                todayTextStyle: GoogleFonts.quicksand(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                                selectedDecoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                selectedTextStyle: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                                disabledTextStyle: GoogleFonts.quicksand(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                              ),
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _selectedDate = selectedDay;
                                  _focusedDate = focusedDay;
                                  _selectedDateText =
                                      DateFormat('MMM dd,yyyy').format(
                                          selectedDay);
                                });
                              },
                              onPageChanged: (focusedDay) {
                                _focusedDate = focusedDay;
                              },
                              selectedDayPredicate: (day) {
                                return isSameDay(_selectedDate, day);
                              },
                            )
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          'Select time',
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                          ),
                        ),
                        const SizedBox(height: 15,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTimeType = 'Anytime';
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: _selectedTimeType
                                              .toLowerCase() == 'anytime'
                                              ? Colors.deepPurpleAccent
                                              : Colors.black.withValues(
                                              alpha: 0.15)
                                      )
                                  ),
                                  child: Text(
                                    'Anytime',
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTimeType = 'Morning';
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: _selectedTimeType
                                              .toLowerCase() == 'morning'
                                              ? Colors.deepPurpleAccent
                                              : Colors.black.withValues(
                                              alpha: 0.15)
                                      )
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Morning',
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16
                                        ),
                                      ),
                                      Text(
                                        '6:00 AM - 12:00 PM',
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Colors.black.withValues(
                                                alpha: 0.3)
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTimeType = 'Afternoon';
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: _selectedTimeType
                                              .toLowerCase() == 'afternoon'
                                              ? Colors.deepPurpleAccent
                                              : Colors.black.withValues(
                                              alpha: 0.15)
                                      )
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Afternoon',
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16
                                        ),
                                      ),
                                      Text(
                                        '12:00 PM - 5:00 PM',
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Colors.black.withValues(
                                                alpha: 0.3)
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTimeType = 'Evening';
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: _selectedTimeType
                                              .toLowerCase() == 'evening'
                                              ? Colors.deepPurpleAccent
                                              : Colors.black.withValues(
                                              alpha: 0.15)
                                      )
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Evening',
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16
                                        ),
                                      ),
                                      Text(
                                        '5:00 PM - 12:00 AM',
                                        style: GoogleFonts.quicksand(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Colors.black.withValues(
                                                alpha: 0.3)
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTimeType = 'Custom';
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: _selectedTimeType
                                              .toLowerCase() == 'custom'
                                              ? Colors.deepPurpleAccent
                                              : Colors.black.withValues(
                                              alpha: 0.15)
                                      )
                                  ),
                                  child: Text(
                                    'Custom',
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15,),
                        if(_selectedTimeType.toLowerCase() == 'custom')
                          Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    final result = await showTimePicker(
                                        context, 0, 'from');

                                    if (result != null) {
                                      setState(() {
                                        _selectedCustomTimeStart = result;
                                      });
                                      if (_selectedCustomTimeEnd == null ||
                                          (_selectedCustomTimeEnd != null &&
                                              _selectedCustomTimeEnd!.compareTo(
                                                  result) <= 0)) {
                                        _selectedCustomTimeEnd = TimeOfDay(
                                            hour: result.hour + 1, minute: 0);
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 45,
                                    padding: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.black.withValues(
                                                alpha: 0.3)
                                        )
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(
                                          _selectedCustomTimeStart == null
                                              ? 'From'
                                              : 'From ' + DateTimeHelper
                                              .transformTime24To12(
                                              _selectedCustomTimeStart!.hour, 0),
                                          style: GoogleFonts.quicksand(
                                              color: _selectedCustomTimeStart ==
                                                  null ? Colors.grey : Colors
                                                  .black,
                                              fontSize: 15
                                          ),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          size: 22,)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (_selectedCustomTimeStart != null) {
                                      final result = await showTimePicker(
                                          context,
                                          _selectedCustomTimeStart!.hour + 1,
                                          'to');
                                      if (result != null) {
                                        setState(() {
                                          _selectedCustomTimeEnd = result;
                                        });
                                      }
                                    } else {
                                      final result = await showTimePicker(
                                          context, 0, 'to');
                                      if (result != null) {
                                        setState(() {
                                          _selectedCustomTimeEnd = result;
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 45,
                                    padding: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.black.withValues(
                                                alpha: 0.3)
                                        )
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(
                                          _selectedCustomTimeEnd == null
                                              ? 'To'
                                              : 'To ' + DateTimeHelper
                                              .transformTime24To12(
                                              _selectedCustomTimeEnd!.hour, 0),
                                          style: GoogleFonts.quicksand(
                                              color: _selectedCustomTimeEnd ==
                                                  null ? Colors.grey : Colors
                                                  .black,
                                              fontSize: 15
                                          ),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          size: 22,)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
              bottomSheet: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    spacing: 10,
                    children: [
                      Flexible(
                          fit: FlexFit.tight,
                          child: OutlinedButton(
                              onPressed: _selectedTimeType.toLowerCase() ==
                                  'anytime'
                                  ? () => _onCancel()
                                  : () => _onClear(),
                              style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  minimumSize: Size(double.infinity, 50),
                                  side: BorderSide(
                                      color: Colors.black.withValues(
                                          alpha: 0.2),
                                      width: 1
                                  )
                              ),
                              child: _selectedTimeType.toLowerCase() ==
                                  'anytime'
                                  ? Text('Cancel', style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              ),)
                                  : Text('Clear', style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              ),)
                          )
                      ),
                      Flexible(
                          fit: FlexFit.tight,
                          child: FilledButton(
                              onPressed: () => _onConfirmed(state),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.black,
                                minimumSize: Size(double.infinity, 50),
                              ),
                              child: Text(
                                'Confirm', style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),)
                          )
                      )
                    ],
                  ),
                ),
              )
          );
        }
    );
  }

  Future<TimeOfDay?> showTimePicker(BuildContext context, int startTime, String type) {
    List<int> times = [];

    for (int i = startTime; i <= 23; i++){
      times.add(i);
    }

    final fromType = RelativeRect.fromLTRB(30, 85, 50, 0);
    final toType = RelativeRect.fromLTRB(50, 85, 30, 0);

    return showMenu<TimeOfDay>(
        useRootNavigator: true,
        context: context,
        color: Colors.white,
        constraints: const BoxConstraints(
          maxHeight: 700,
          minWidth: 150,
        ),
        position: type == 'from' ? fromType : toType,
        items: times.map(
                (time) => PopupMenuItem(
              value: TimeOfDay(hour: time, minute: 0),
              child: Text(DateTimeHelper.transformTime24To12(time, 0)),
            )
        ).toList()
    );
  }
}
