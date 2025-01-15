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



// import 'package:flutter/material.dart';
//
// class FeedbackFormDialog {
//   static void showFeedbackForm(BuildContext context) {
//     double _rating = 0; // Declare _rating outside of StatefulBuilder
//     TextEditingController _feedbackController = TextEditingController();
//
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       "Feedback Our App",
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       "Rate Us",
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: List.generate(5, (index) {
//                         return IconButton(
//                           icon: Icon(
//                             index < _rating ? Icons.star : Icons.star_border,
//                             color: Colors.amber,
//                             size: 30,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _rating = index + 1.0; // Update rating on click
//                             });
//                           },
//                         );
//                       }),
//                     ),
//                     const SizedBox(height: 20),
//                     TextField(
//                       controller: _feedbackController,
//                       maxLines: 3,
//                       decoration: InputDecoration(
//                         hintText: "Write your feedback here...",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                       ),
//                       onPressed: () {
//                         String feedback = _feedbackController.text.trim();
//                         print("Rating: $_rating");
//                         print("Feedback: $feedback");
//
//                         Navigator.pop(context); // Close the dialog
//                       },
//                       child: const Text("Submit"),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
//


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedbackFormDialog {
  static void showFeedbackForm(BuildContext context) {
    double _rating = 0; // User's rating
    TextEditingController _feedbackController = TextEditingController();
    double _averageRating = 0; // Average rating fetched from Supabase
    int _totalFeedbacks = 0;

    Future<void> fetchAverageRating() async {
      try {
        final response = await Supabase.instance.client
            .from('app_feedback')
            .select('rating');

        if (response != null && response.isNotEmpty) {
          final List data = response as List;

          if (data.isNotEmpty) {
            _totalFeedbacks = data.length;

            // Convert ratings to double safely
            _averageRating = data
                .map((item) => (item['rating'] as num).toDouble()) // Ensure 'rating' is converted to double
                .reduce((a, b) => a + b) / // Sum ratings
                _totalFeedbacks;
          } else {
            // Reset values if there's no feedback
            _totalFeedbacks = 0;
            _averageRating = 0;
          }
        } else {
          // Handle empty or null response
          _totalFeedbacks = 0;
          _averageRating = 0;
          print('No data found in app_feedback table.');
        }
      } catch (e) {
        print('Exception occurred while fetching average rating: $e');
      }
    }


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
                child: FutureBuilder(
                  future: fetchAverageRating(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Column(
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
                                  _rating = index + 1.0; // Update rating
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
                          onPressed: () async {
                            await fetchAverageRating();

                            String feedback = _feedbackController.text.trim();
                            final user = Supabase.instance.client.auth.currentUser;

                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('User not logged in')),
                              );
                              return;
                            }

                            try {
                              // Insert feedback into Supabase
                              await Supabase.instance.client
                                  .from('app_feedback')
                                  .insert({
                                'id': user.id,
                                'rating': _rating,
                                'feedback_txt': feedback,
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Feedback submitted successfully!')),
                              );

                              // Close the dialog
                              Navigator.pop(context);

                              // Refresh the average rating (optional, as the dialog is already closed)

                            } catch (e) {
                              print('Error saving feedback: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Failed to submit feedback')),
                              );
                            }
                          },
                          child: const Text("Submit"),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const Text(
                          "Current Average Rating",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _averageRating > 0
                              ? "${_averageRating.toStringAsFixed(1)} / 5.0 (${_totalFeedbacks} feedbacks)"
                              : "No feedback yet",
                          style: const TextStyle(fontSize: 16, color: Colors.amber),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

extension on PostgrestFilterBuilder<PostgrestList> {


  execute() {}
}


