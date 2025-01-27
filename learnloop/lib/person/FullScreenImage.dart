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

import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imagePath;
  final bool isNetworkImage;

  const FullScreenImage({
    Key? key,
    required this.imagePath,
    required this.isNetworkImage, required String filePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Picture"),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Close the zoom screen on tap
          },
          child: InteractiveViewer(
            child: isNetworkImage
                ? Image.network(
              imagePath,
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
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}