import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/manager/widgets/step_progress_bar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/utils/snackbar_helper.dart';
import '../../../../../l10n/app_localizations.dart';
import '../cubit/marketplace_setup_cubit.dart';
import '../cubit/marketplace_setup_state.dart';

class MarketplacePaymentScreen extends StatefulWidget {
  const MarketplacePaymentScreen({super.key});

  @override
  State<MarketplacePaymentScreen> createState() =>
      _MarketplacePaymentScreenState();
}

class _MarketplacePaymentScreenState extends State<MarketplacePaymentScreen> {
  String _paymentMethod = 'stripe';
  bool _isLoading = false;
  final double _feeAmount = 5499000;

  String _formatCurrency(double amount) {
    final format = NumberFormat("#,##0", "vi_VN");
    return format.format(amount);
  }

  void _showPaymentMethodBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Select Payment Method',
                  style: GoogleFonts.quicksand(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: Image.asset(
                  'assets/images/stripe-icon-logo.png',
                  width: 28,
                  height: 28,
                ),
                title: Text(
                  AppLocalizations.of(context)!.payWithStripe,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: _paymentMethod == 'stripe'
                    ? const PhosphorIcon(
                        PhosphorIconsFill.checkCircle,
                        color: Colors.green,
                        size: 24,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    _paymentMethod = 'stripe';
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _processPayment() async {
    if (_paymentMethod == 'stripe') {
      try {
        setState(() {
          _isLoading = true;
        });

        Stripe.publishableKey = dotenv.env['STRIPE_PUBLISH']!;
        final secret = dotenv.env['STRIPE_SECRET'];

        if (secret == null) throw Exception('Stripe secret missing');

        int stripeAmount = _feeAmount.round();

        final response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          headers: {
            'Authorization': 'Bearer $secret',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {'amount': stripeAmount.toString(), 'currency': 'vnd'},
        );

        final jsonResponse = jsonDecode(response.body);
        if (response.statusCode != 200) {
          throw Exception(
            'Failed to create payment intent: ${jsonResponse['error']['message']}',
          );
        }

        final clientSecret = jsonResponse['client_secret'];

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'Healio Marketplace Registration',
          ),
        );

        await Stripe.instance.presentPaymentSheet();

        final managerId = Supabase.instance.client.auth.currentUser?.id;

        if (managerId != null) {
          await Supabase.instance.client.from('market_transactions').insert({
            'manager_id': managerId,
            'amount': _feeAmount,
            'payment_method': _paymentMethod,
            'status': 'paid',
            'transaction_date': DateTime.now().toUtc().toIso8601String(),
          });
        }

        if (mounted) {
          context.read<MarketplaceSetupCubit>().submitStoreData();
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (e.toString().contains('The payment flow has been canceled')) {
          SnackBarHelper.showError(
            AppLocalizations.of(context)!.paymentCanceled,
          );
          return;
        }
        SnackBarHelper.showError(
          '${AppLocalizations.of(context)!.paymentFailed}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MarketplaceSetupCubit, MarketplaceSetupState>(
      listenWhen: (previous, current) {
        if (previous.isLoading && !current.isLoading && current.error == null) {
          return true;
        }
        if (current.error != null && previous.error != current.error) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state.error != null) {
          setState(() {
            _isLoading = false;
          });
          SnackBarHelper.showError(state.error!);
        } else if (!state.isLoading) {
          setState(() {
            _isLoading = false;
          });
          SnackBarHelper.showSuccess(
            AppLocalizations.of(context)!.storePublishedSuccessfully,
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Expanded(
                      child: StepProgressBar(currentStep: 3, totalSteps: 3),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Image.asset(
                          'assets/images/payment_illustration.png',
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.marketplaceRegistrationFee,
                        style: GoogleFonts.quicksand(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.registrationFeeDescription,
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.registrationFee,
                            style: GoogleFonts.quicksand(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            '₫${_formatCurrency(_feeAmount)}',
                            style: GoogleFonts.quicksand(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        AppLocalizations.of(context)!.paymentMethod,
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _showPaymentMethodBottomSheet,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Image.asset(
                                  'assets/images/stripe-icon-logo.png',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Pay with Stripe',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.change,
                                style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const PhosphorIcon(
                                PhosphorIconsRegular.caretRight,
                                size: 16,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Bottom Button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? LoadingAnimationWidget.progressiveDots(
                            color: Colors.white,
                            size: 30,
                          )
                        : Text(
                            AppLocalizations.of(context)!.payAndPublishStore,
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
