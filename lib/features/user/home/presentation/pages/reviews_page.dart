import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/home/data/models/review_model.dart';
import 'package:healio_app/features/user/home/presentation/widgets/rating_line.dart';
import 'package:healio_app/l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({
    super.key,
    required this.allReviews,
    required this.store,
  });
  final List<ReviewModel> allReviews;
  final StoreModel store;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final Set<int> _selectedRatings = {};
  String _sortBy = 'Latest';

  Map<int, int> get _ratingCounts {
    Map<int, int> counts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var review in widget.allReviews) {
      if (counts.containsKey(review.rating.roundToDouble().toInt())) {
        counts[review.rating.roundToDouble().toInt()] = counts[review.rating.roundToDouble().toInt()]! + 1;
      }
    }
    return counts;
  }

  double get _averageRating {
    if (widget.allReviews.isEmpty) return 0.0;
    double total = widget.allReviews.fold(0, (sum, item) => sum + item.rating);
    return total / widget.allReviews.length;
  }

  List<ReviewModel> get _processedReviews {
    List<ReviewModel> filtered = widget.allReviews.where((review) {
      if (_selectedRatings.isEmpty) return true;
      return _selectedRatings.contains(review.rating.roundToDouble().toInt());
    }).toList();

    filtered.sort((a, b) {
      if (_sortBy == 'Latest') {
        return b.createdAt.compareTo(a.createdAt); // Mới nhất lên đầu
      } else if (_sortBy == 'Best') {
        return b.rating.compareTo(a.rating); // Điểm cao lên đầu
      } else if (_sortBy == 'Worst') {
        return a.rating.compareTo(b.rating); // Điểm thấp lên đầu
      }
      return 0;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final counts = _ratingCounts;
    final totalReviews = widget.allReviews.length;
    final processedList = _processedReviews;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const PhosphorIcon(
            PhosphorIconsRegular.arrowLeft,
            color: Colors.black,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.reviews1,
                    style: GoogleFonts.quicksand(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      RatingLine(rating: widget.store.rating, iconSize: 32),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_averageRating.toStringAsFixed(1)} ($totalReviews)',
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    AppLocalizations.of(context)!.filterBy,
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...[5, 4, 3, 2, 1].map((star) {
                    return _buildFilterRow(
                      star: star,
                      count: counts[star] ?? 0,
                      total: totalReviews,
                    );
                  }),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${processedList.length} ' + AppLocalizations.of(context)!.reviews2,
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.sortBy,
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 36,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _sortBy,
                                icon: const Padding(
                                  padding: EdgeInsets.only(left: 4.0),
                                  child: PhosphorIcon(
                                    PhosphorIconsRegular.caretDown,
                                    size: 16,
                                  ),
                                ),
                                style: GoogleFonts.quicksand(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                items: ['Latest', 'Best', 'Worst'].map((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _sortBy = newValue;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 10.0,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildReviewItem(processedList[index]);
              }, childCount: processedList.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow({
    required int star,
    required int count,
    required int total,
  }) {
    final bool isSelected = _selectedRatings.contains(star);
    final bool isDisabled = count == 0;
    final double percentage = total == 0 ? 0 : (count / total);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: isSelected,
              onChanged: isDisabled
                  ? null
                  : (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedRatings.add(star);
                        } else {
                          _selectedRatings.remove(star);
                        }
                      });
                    },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: BorderSide(
                color: isDisabled ? Colors.grey.shade300 : Colors.grey.shade400,
                width: 1.5,
              ),
              activeColor: Colors.black,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$star',
            style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: isDisabled ? Colors.grey.shade300 : Colors.black,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          SizedBox(
            width: 35,
            child: Text(
              '$count',
              textAlign: TextAlign.right,
              style: GoogleFonts.quicksand(
                fontSize: 15,
                color: isDisabled ? Colors.grey.shade400 : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(ReviewModel review) {
    String formattedDate = DateFormat(
      "EEE, MMM dd, yyyy 'at' h:mm a",
    ).format(review.createdAt);

    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  width: 60,
                  height: 60,
                  imageUrl: review.avatarUrl ?? 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small_2x/default-avatar-icon-of-social-media-user-vector.jpg',
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Shimmer(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Center(
                      child: Icon(Icons.error, color: Colors.white),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.customerName!,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          RatingLine(rating: review.rating, iconSize: 18),

          if (review.comment != null) const SizedBox(height: 12),
          if (review.comment != null)
            Text(
              review.comment!,
              style: GoogleFonts.quicksand(
                fontSize: 16,
                color: Colors.black87,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (review.comment != null && review.comment!.length > 50)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                AppLocalizations.of(context)!.readMore,
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  color: const Color(0xFF5B45FF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
