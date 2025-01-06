//
//
//
//
//
//
// //add this
// void showFeedbackForm(BuildContext context) {
//   double _rating = 0; // Declare _rating outside of StatefulBuilder
//   TextEditingController _feedbackController = TextEditingController();
//
//   showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     "Feedback Our App",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     "Rate Us",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(5, (index) {
//                       return IconButton(
//                         icon: Icon(
//                           index < _rating ? Icons.star : Icons.star_border,
//                           color: Colors.amber,
//                           size: 30,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _rating = index + 1.0; // Update rating on click
//                           });
//                         },
//                       );
//                     }),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _feedbackController,
//                     maxLines: 3,
//                     decoration: InputDecoration(
//                       hintText: "Write your feedback here...",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                     ),
//                     onPressed: () {
//                       String feedback = _feedbackController.text.trim();
//                       print("Rating: $_rating");
//                       print("Feedback: $feedback");
//
//                       Navigator.pop(context); // Close the dialog
//                     },
//                     child: const Text("Submit"),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }
// //end
//
//



import 'package:flutter/material.dart';

class FeedbackFormDialog {
  static void showFeedbackForm(BuildContext context) {
    double _rating = 0; // Declare _rating outside of StatefulBuilder
    TextEditingController _feedbackController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Feedback Our App",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Rate Us",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1.0; // Update rating on click
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _feedbackController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Write your feedback here...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        String feedback = _feedbackController.text.trim();
                        print("Rating: $_rating");
                        print("Feedback: $feedback");

                        Navigator.pop(context); // Close the dialog
                      },
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

