import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/shared/datasource/client_datasource.dart';
import 'package:healio_app/shared/models/client_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:healio_app/core/utils/color_theme.dart';
import '../../../../../l10n/app_localizations.dart';

class ClientReviewsPage extends StatefulWidget {
  final ClientModel client;
  const ClientReviewsPage({super.key, required this.client});

  @override
  State<ClientReviewsPage> createState() => _ClientReviewsPageState();
}

class _ClientReviewsPageState extends State<ClientReviewsPage> {
  late Future<List<Map<String, dynamic>>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = inj<ClientDatasource>().getClientReviews(
      widget.client.profileId,
      widget.client.storeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientName = widget.client.fullName;
    final initial = clientName.isNotEmpty ? clientName[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFFE8EAF6),
              child: Text(
                initial,
                style: GoogleFonts.quicksand(
                  color: const Color(0xFF6B4EFF),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              clientName,
              style: GoogleFonts.quicksand(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context)!.reviews1,
              style: GoogleFonts.quicksand(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _reviewsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: ColorTheme.mainAppColor(),
                      size: 50,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: GoogleFonts.quicksand(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                final reviewsList = snapshot.data!;
                return ListView.separated(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 40,
                  ),
                  itemCount: reviewsList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final review = reviewsList[index];
                    return _buildReviewCard(context, review);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade200, const Color(0xFF6B4EFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6B4EFF).withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.noReviewsYet,
            style: GoogleFonts.quicksand(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.noCustomerReviewsDesc,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Map<String, dynamic> review) {
    DateTime createdAt = review['created_at'] != null
        ? DateTime.parse(review['created_at']).toLocal()
        : DateTime.now();
    String dateStr = DateFormat('dd Thg MM yyyy', 'vi').format(createdAt);

    double rating = (review['rating'] as num?)?.toDouble() ?? 0.0;
    String comment =
        review['comment'] ?? AppLocalizations.of(context)!.noComment;

    String serviceName = AppLocalizations.of(context)!.service;
    if (review['appointments'] != null) {
      var apt = review['appointments'];
      if (apt['appointment_services'] != null) {
        List servicesList = apt['appointment_services'];
        if (servicesList.isNotEmpty) {
          serviceName =
              servicesList[0]['services']['name'] ??
              AppLocalizations.of(context)!.service;
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  serviceName,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                dateStr,
                style: GoogleFonts.quicksand(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating.floor()
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: Colors.amber,
                size: 20,
              );
            }),
          ),
          const SizedBox(height: 12),

          Text(
            comment,
            style: GoogleFonts.quicksand(
              fontSize: 15,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
