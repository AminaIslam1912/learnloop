// import 'package:flutter/material.dart';
//
// class FullScreenImage extends StatelessWidget {
//   final String imagePath;
//
//   const FullScreenImage({super.key, required this.imagePath});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile Picture"),
//       ),
//       body: Center(
//         child: GestureDetector(
//           onTap: () {
//             Navigator.pop(context); // Close the zoom screen on tap
//           },
//           child: InteractiveViewer(
//             child: Image.asset(
//               imagePath,
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
//
// class FullScreenImage extends StatelessWidget {
//   final String imagePath;
//   final bool isNetworkImage;
//
//   const FullScreenImage({
//     Key? key,
//     required this.imagePath,
//     required this.isNetworkImage,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Profile Picture"),
//       ),
//       body: Center(
//         child: GestureDetector(
//           onTap: () {
//             Navigator.pop(context); // Close the zoom screen on tap
//           },
//           child: InteractiveViewer(
//             child: isNetworkImage
//                 ? Image.network(
//               imagePath,
//               fit: BoxFit.contain,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return const Center(
//                   child: Icon(
//                     Icons.broken_image,
//                     size: 50,
//                   ),
//                 );
//               },
//             )
//                 : Image.asset(
//               imagePath,
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class FullScreenImage extends StatelessWidget {
  final String filePath;
  final bool isNetworkImage;
  final bool isCV;

  const FullScreenImage({
    Key? key,
    required this.filePath,
    required this.isNetworkImage,
    this.isCV = false, required String imagePath, // Add a flag to check if it's a CV or not
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Full Screen View"),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Close the full-screen view on tap
          },
          child: isCV ? _buildCVView() : _buildImageView(),
        ),
      ),
    );
  }

  // Function to display the CV (either image or PDF)
  Widget _buildCVView() {
    if (filePath.endsWith(".pdf")) {
      return PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: true,
        pageFling: true,
        pageSnap: true,
        onPageChanged: (int? page, int? total) {
          // You can add any page change actions here
        },
      );
    } else {
      return Image.network(
        filePath,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.broken_image,
              size: 50,
            ),
          );
        },
      );
    }
  }

  // Function to display an image view
  Widget _buildImageView() {
    return InteractiveViewer(
      child: isNetworkImage
          ? Image.network(
        filePath,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.broken_image,
              size: 50,
            ),
          );
        },
      )
          : Image.asset(
        filePath,
        fit: BoxFit.contain,
      ),
    );
  }
}

