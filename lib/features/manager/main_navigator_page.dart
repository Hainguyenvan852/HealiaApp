import 'package:flutter/material.dart';
import 'package:healio_app/features/manager/calendar/presentation/pages/calendar_page.dart';
import 'package:healio_app/features/manager/calendar/presentation/pages/add_appointment_page.dart';
import 'package:healio_app/features/manager/client/presentation/pages/client_menu_page.dart';
import 'package:healio_app/features/manager/request/presentation/pages/appointment_request_page.dart';
import 'package:healio_app/features/user/profile/data/models/user_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'options/presentation/pages/grid_menu_page.dart';

class MainNavigatorPage extends StatefulWidget {
  const MainNavigatorPage({super.key, required this.currentUser});
  final UserModel currentUser;

  @override
  State<MainNavigatorPage> createState() => _MainNavigatorPageState();
}

class _MainNavigatorPageState extends State<MainNavigatorPage> {
  int _selectedIndex = 0;
  final List<bool> _initialized = [true, false, false, false, false];

  late final List<Widget> _pages;

  void _onItemTapped(int index) {
    if (index == 2) return; // Add button index
    setState(() {
      _selectedIndex = index;
      _initialized[index] = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      CalendarPage(currentUser: widget.currentUser),
      ClientMenuPage(),
      SizedBox(),
      AppointmentRequestPage(currentUser: widget.currentUser),
      GridMenuPage(currentUser: widget.currentUser),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: List.generate(_pages.length, (index) {
          if (_initialized[index]) {
            return _pages[index];
          }
          return const SizedBox.shrink();
        }),
      ),
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(PhosphorIcons.calendarBlank(), 0),
              _buildNavItem(PhosphorIcons.smiley(), 1),
              _buildAddButton(2),
              _buildNavItem(PhosphorIcons.clipboardText(), 3),
              _buildNavItem(PhosphorIcons.squaresFour(), 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(PhosphorIconData icon, int index) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? const Color(0xFF6B4EFF) : Colors.black87;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Icon(icon, size: 28, color: color),
      ),
    );
  }

  Widget _buildAddButton(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddAppointmentPage(
              managerId: widget.currentUser.id.toString(),
              selectedDate: null,
            ),
          ),
        );
      },
      child: Container(
        width: 56,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Color(0xFF6B4EFF),
          shape: BoxShape.rectangle,
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}
