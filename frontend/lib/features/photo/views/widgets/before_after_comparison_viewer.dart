// EARS[Ubiquitous]: THE system SHALL render before and after photos side-by-side or with interactive slider.

import 'package:flutter/material.dart';
import '../../models/medical_photo.dart';

enum ComparisonMode { sideBySide, slider }

class BeforeAfterComparisonViewer extends StatefulWidget {
  final MedicalPhoto beforePhoto;
  final MedicalPhoto afterPhoto;

  const BeforeAfterComparisonViewer({
    super.key,
    required this.beforePhoto,
    required this.afterPhoto,
  });

  @override
  State<BeforeAfterComparisonViewer> createState() => _BeforeAfterComparisonViewerState();
}

class _BeforeAfterComparisonViewerState extends State<BeforeAfterComparisonViewer> {
  ComparisonMode _mode = ComparisonMode.slider;
  double _sliderPosition = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('So sánh Trước / Sau'),
        actions: [
          IconButton(
            icon: Icon(_mode == ComparisonMode.slider ? Icons.view_column : Icons.tune),
            tooltip: _mode == ComparisonMode.slider ? 'Chế độ Song Song' : 'Chế độ Thanh Trượt',
            onPressed: _toggleMode,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _mode == ComparisonMode.slider
                      ? _buildSliderOverlay(constraints)
                      : _buildSideBySideView(isMobile),
                ),
              ),
              _buildPhotoLabels(),
            ],
          );
        },
      ),
    );
  }

  // EARS[Event]: WHEN user toggles comparison mode
  void _toggleMode() {
    setState(() {
      _mode = _mode == ComparisonMode.slider ? ComparisonMode.sideBySide : ComparisonMode.slider;
    });
  }

  Widget _buildSideBySideView(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          Expanded(child: _buildImageTile(widget.beforePhoto, 'Trước (Before)')),
          const SizedBox(height: 8),
          Expanded(child: _buildImageTile(widget.afterPhoto, 'Sau (After)')),
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: _buildImageTile(widget.beforePhoto, 'Trước (Before)')),
        const SizedBox(width: 8),
        Expanded(child: _buildImageTile(widget.afterPhoto, 'Sau (After)')),
      ],
    );
  }

  Widget _buildSliderOverlay(BoxConstraints constraints) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _sliderPosition += details.delta.dx / constraints.maxWidth;
          _sliderPosition = _sliderPosition.clamp(0.0, 1.0);
        });
      },
      child: Stack(
        children: [
          Positioned.fill(child: Image.network(widget.afterPhoto.publicUrl, fit: BoxFit.cover)),
          Positioned.fill(
            child: ClipRect(
              clipper: _SliderClipper(_sliderPosition),
              child: Image.network(widget.beforePhoto.publicUrl, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            left: constraints.maxWidth * _sliderPosition - 1,
            top: 0,
            bottom: 0,
            child: Container(width: 2, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildImageTile(MedicalPhoto photo, String label) {
    return Stack(
      children: [
        Positioned.fill(child: Image.network(photo.publicUrl, fit: BoxFit.cover)),
        Positioned(
          left: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.black54,
            child: Text(label, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoLabels() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Trước: ${widget.beforePhoto.caption ?? "Không có mô tả"}',
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Sau: ${widget.afterPhoto.caption ?? "Không có mô tả"}',
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderClipper extends CustomClipper<Rect> {
  final double position;
  _SliderClipper(this.position);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * position, size.height);
  }

  @override
  bool shouldReclip(_SliderClipper oldClipper) => oldClipper.position != position;
}
