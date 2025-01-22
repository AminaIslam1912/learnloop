import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SwapFeedback extends StatefulWidget {

  final int loggedInUserId; // Authenticated user's ID
  final int profileUserId;


  const SwapFeedback({super.key, required this.loggedInUserId,
    required this.profileUserId,});

  @override
  State<SwapFeedback> createState() => _SwapFeedback();
}

class _SwapFeedback extends State<SwapFeedback> {
  double _rating = 0.0;
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  bool _isSubmitting = false;


  Future<void> _submitFeedback() async {
    String feedback = _feedbackController.text.trim();
    String topic = _topicController.text.trim();

    if (_rating == 0 || feedback.isEmpty || topic.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and select a rating.")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final newFeedback = {
      "id": widget.loggedInUserId,
      "rating": _rating,
      "topic": topic,
      "description": feedback,
    };

    try {
      // Fetch existing feedback
      final response = await Supabase.instance.client
          .from('users')
          .select('userFeedback')
          .eq('id', widget.profileUserId)
          .maybeSingle(); // Use maybeSingle() for a single record or null.

      List<dynamic> userFeedback = response != null && response['userFeedback'] != null
          ? List<dynamic>.from(response['userFeedback'])
          : [];

      // Add the new feedback
      userFeedback.add(newFeedback);

      // Update the userFeedback column
      await Supabase.instance.client
          .from('users')
          .update({'userFeedback': userFeedback})
          .eq('id', widget.profileUserId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback submitted successfully!")),
      );
      Navigator.pop(context); // Close the dialog
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }








  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Feedback Mentor",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                "Rating",
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
                controller: _topicController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Which topic you swap or learn from mentor?",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.green,
              //   ),
              //
              //   onPressed: () {
              //     String feedback = _feedbackController.text.trim();
              //     print("Rating: $_rating");
              //     print("Feedback: $feedback");
              //
              //
              //     Navigator.pop(context); // Close the dialog
              //   },
              //   child: const Text("Submit"),
              // ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: _isSubmitting ? null : _submitFeedback,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text("Submit"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

