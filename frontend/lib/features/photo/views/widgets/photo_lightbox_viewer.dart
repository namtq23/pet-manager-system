import 'package:flutter/material.dart';
import '../../models/medical_photo.dart';

class PhotoLightboxViewer extends StatelessWidget {
  final List<MedicalPhoto> photos;
  final int initialIndex;

  const PhotoLightboxViewer({
    super.key,
    required this.photos,
    this.initialIndex = 0,
  });

  static void show(BuildContext context, List<MedicalPhoto> photos, int initialIndex) {
    showDialog(
      context: context,
      builder: (_) => PhotoLightboxViewer(photos: photos, initialIndex: initialIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(initialPage: initialIndex);

    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: PageView.builder(
          controller: controller,
          itemCount: photos.length,
          itemBuilder: (context, index) {
            final photo = photos[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InteractiveViewer(
                    child: Image.network(
                      photo.publicUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                if (photo.caption != null && photo.caption!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.black54,
                    width: double.infinity,
                    child: Text(
                      photo.caption!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
