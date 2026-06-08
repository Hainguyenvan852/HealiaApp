import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import 'package:healio_app/features/user/appointment/domain/usecases/get_user_appointment_usecase.dart';
import 'package:healio_app/features/user/appointment/presentation/widgets/authenticated_body.dart';
import 'package:healio_app/features/user/appointment/presentation/widgets/empty_appointment_body.dart';
import 'package:healio_app/features/user/appointment/presentation/widgets/unauthenticated_body.dart';
import 'package:healio_app/features/user/auth/presentation/bloc/auth_bloc.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/injector/dependency_injector.dart';
import 'package:healio_app/features/user/appointment/data/models/appointment_model.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  RealtimeChannel? _appointmentSubscription;
  String? _currentUserId;
  Future<List<AppointmentModel>>? _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      _currentUserId = authState.user.id;
      _appointmentsFuture = inj<GetUserAppointmentUsecase>().call(
        _currentUserId!,
      );
      _setupRealtimeSubscription(_currentUserId!);
    }
  }

  void _fetchAppointments() {
    if (_currentUserId != null && mounted) {
      setState(() {
        _appointmentsFuture = inj<GetUserAppointmentUsecase>().call(
          _currentUserId!,
        );
      });
    }
  }

  void _setupRealtimeSubscription(String userId) {
    if (_appointmentSubscription != null) return;

    _appointmentSubscription = Supabase.instance.client
        .channel('public:appointments_user_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'appointments',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'customer_id',
            value: userId,
          ),
          callback: (payload) {
            if (mounted) {
              _fetchAppointments();
            }
          },
        )
        .subscribe();
  }

  void _removeRealtimeSubscription() {
    if (_appointmentSubscription != null) {
      Supabase.instance.client.removeChannel(_appointmentSubscription!);
      _appointmentSubscription = null;
    }
  }

  @override
  void dispose() {
    _removeRealtimeSubscription();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, OAuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          if (_currentUserId != state.user.id) {
            _currentUserId = state.user.id;
            _removeRealtimeSubscription();
            _setupRealtimeSubscription(_currentUserId!);
            _fetchAppointments();
          }
        } else {
          _removeRealtimeSubscription();
          _currentUserId = null;
          if (mounted) {
            setState(() {
              _appointmentsFuture = null;
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Text(
                  AppLocalizations.of(context)!.appointments,
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 30),
                BlocBuilder<AuthBloc, OAuthState>(
                  builder: (context, state) {
                    if (state is AuthInitial) {
                      return Expanded(
                        child: Center(
                          child: LoadingAnimationWidget.fourRotatingDots(
                            color: ColorTheme.mainAppColor(),
                            size: 50,
                          ),
                        ),
                      );
                    } else if (state is AuthSuccess) {
                      return FutureBuilder<List<AppointmentModel>>(
                        future: _appointmentsFuture,
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.waiting &&
                              !snap.hasData) {
                            return Expanded(
                              child: Center(
                                child: LoadingAnimationWidget.fourRotatingDots(
                                  color: ColorTheme.mainAppColor(),
                                  size: 50,
                                ),
                              ),
                            );
                          }

                          if (snap.hasError && !snap.hasData) {
                            return Expanded(
                              child: Center(
                                child: Text(
                                  'An error occurred when loading!',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          }

                          final appointments = snap.data!;

                          if (appointments.isNotEmpty) {
                            return AuthenticatedBody(
                              appointments: appointments,
                              reset: () {
                                _fetchAppointments();
                              },
                            );
                          } else {
                            return const EmptyAppointmentBody();
                          }
                        },
                      );
                    }
                    return const UnauthenticatedBody();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
