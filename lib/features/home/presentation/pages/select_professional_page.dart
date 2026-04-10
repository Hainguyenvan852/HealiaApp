import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/bottom_sheet_helper.dart';
import 'package:healio_app/features/home/data/models/team_member_model.dart';
import 'package:healio_app/features/home/presentation/bloc/booking_cubit.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SelectProfessionalPage extends StatefulWidget {
  const SelectProfessionalPage({super.key, required this.professionals});
  final List<TeamMemberModel> professionals;

  @override
  State<SelectProfessionalPage> createState() => _SelectProfessionalPageState();
}

class _SelectProfessionalPageState extends State<SelectProfessionalPage> {
  int _selectedId = 0;

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
                      GestureDetector(
                        onTap: () {
                          context.read<BookingCubit>().clearServices();
                          context.pop();
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

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: ElevatedButton(
                onPressed: () {
                  context.read<BookingCubit>().selectProfessional(
                    _selectedId == 0
                        ? TeamMemberModel(
                            id: 0,
                            fullName: 'Any professional',
                            email: '',
                            phoneNumber: '',
                            jobTitle: '',
                            birthDay: DateTime(2026),
                            startDate: DateTime(2026),
                          )
                        : widget.professionals[_selectedId],
                  );
                  context.push(
                    '/home/store-detail/select-datetime',
                    extra: {
                      'professionals': widget.professionals,
                      'selected': _selectedId == 0
                          ? TeamMemberModel(
                              id: 0,
                              fullName: 'Any professional',
                              email: '',
                              phoneNumber: '',
                              jobTitle: '',
                              birthDay: DateTime(2026),
                              startDate: DateTime(2026),
                            )
                          : widget.professionals.singleWhere(
                              (item) => item.id == _selectedId,
                            ),
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Continue',
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
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
        setState(() {
          _selectedId = item.id;
        });
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
