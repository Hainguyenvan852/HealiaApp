import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:healio_app/core/injector/dependency_injector.dart';
import 'package:healio_app/features/user/explore/data/datasources/store_datasource.dart';
import 'package:healio_app/features/user/explore/data/models/store_model.dart';
import 'package:healio_app/features/user/home/data/models/image_model.dart';
import 'package:healio_app/features/manager/options/presentation/pages/edit_store_pictures_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../../../core/utils/color_theme.dart';
import '../../../../../../l10n/app_localizations.dart';

class StorePicturesPage extends StatefulWidget {
  const StorePicturesPage({Key? key}) : super(key: key);

  @override
  State<StorePicturesPage> createState() => _StorePicturesPageState();
}

class _StorePicturesPageState extends State<StorePicturesPage> {
  StoreModel? _store;
  List<ImageModel> _images = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final store = await inj<StoreDatasource>().getStoreByMangerId(user.id);
      final images = await inj<StoreDatasource>().fetchStoreImages(store.id);

      if (mounted) {
        setState(() {
          _store = store;
          _images = images;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.errorPrefix}${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_store != null) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditStorePicturesPage(
                        store: _store!,
                        existingImages: _images,
                      ),
                    ),
                  );
                  if (result == true) {
                    setState(() => _isLoading = true);
                    _fetchData();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: Text(
                AppLocalizations.of(context)!.edit,
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: ColorTheme.mainAppColor(),
                size: 40,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.locationImages,
                    style: GoogleFonts.quicksand(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text:
                              AppLocalizations.of(context)!.storePicturesTip,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildCoverImageSection(),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.storePicturesRequirements,
                    style: GoogleFonts.quicksand(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildImagesGrid(),
                ],
              ),
            ),
    );
  }

  Widget _buildCoverImageSection() {
    final hasCover = _store?.primaryImageUrl.isNotEmpty ?? false;

    return Stack(
      children: [
        DottedBorder(
          options: RoundedRectDottedBorderOptions(
            color: Colors.grey.shade300,
            strokeWidth: 1.5,
            dashPattern: const [6, 4],
            radius: const Radius.circular(12),
          ),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: hasCover
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: _store!.primaryImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: ColorTheme.mainAppColor(),
                          size: 24,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.error_outline, color: Colors.red),
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.addYourImage,
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          // Select file
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.selectAFile,
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F0FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5DFFF)),
            ),
            child: Text(
              AppLocalizations.of(context)!.coverPhoto,
              style: GoogleFonts.quicksand(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B4EFF),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: _images.length,
      itemBuilder: (context, index) {
        final image = _images[index];
        return _buildImageCard(image);
      },
    );
  }

  Widget _buildImageCard(ImageModel image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: image.imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade100,
          child: Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: ColorTheme.mainAppColor(),
              size: 20,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade100,
          child: const Center(
            child: Icon(Icons.error_outline, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
