import 'package:flutter/material.dart';


class UserFeedback extends StatefulWidget {
  const UserFeedback({super.key});

  @override
  State<UserFeedback> createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  TextEditingController searchController = TextEditingController();

  // Sample feedback data
  final List<Map<String, dynamic>> feedbackData = [
    {
      "profilePicture": "https://via.placeholder.com/150", // Replace with actual image URLs
      "name": "John Doe",
      "rating": 4.5,
      "topic": "Customer Service",
      "description": "Great service, very helpful!"
    },
    {
      "profilePicture": "https://via.placeholder.com/150",
      "name": "Jane Smith",
      "rating": 5.0,
      "topic": "Delivery Experience",
      "description": "Fast delivery and excellent packaging!"
    },
    {
      "profilePicture": "https://via.placeholder.com/150",
      "name": "Mike Johnson",
      "rating": 3.0,
      "topic": "Product Quality",
      "description": "The product was okay, but could be better."
    },
  ];

  List<Map<String, dynamic>> filteredFeedback = [];

  @override
  void initState() {
    super.initState();
    filteredFeedback = List.from(feedbackData); // Initialize with all feedback
  }



  void _filterFeedback(String query) {
    setState(() {
      filteredFeedback = feedbackData
          .where((feedback) =>
          feedback['topic'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList(); // Convert the result to a list after filtering
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Search Feedback on Topics",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterFeedback,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredFeedback.length,
              itemBuilder: (context, index) {
                final feedback = filteredFeedback[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(feedback['profilePicture'] as String),
                          radius: 30,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feedback['name'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    feedback['rating'].toString(),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.star, color: Colors.yellow, size: 16),
                                ],
                              ),
                              Text(
                                feedback['topic'] as String,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(feedback['description'] as String),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ]

      ),
    );
  }
}



