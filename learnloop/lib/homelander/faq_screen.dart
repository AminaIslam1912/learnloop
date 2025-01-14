// import 'package:flutter/material.dart';
// import 'package:learnloop/supabase_config.dart';
//
// class FAQScreen extends StatefulWidget {
//   const FAQScreen({super.key});
//
//   @override
//   State<FAQScreen> createState() => _FAQScreenState();
// }
//
// class _FAQScreenState extends State<FAQScreen> {
//   Future<List<Map<String, String>>> fetchFAQs() async {
//     final response = await SupabaseConfig.client
//         .from('faq')
//         .select();
//
//     final List<Map<String, String>> faqs = [];
//     for (var item in response) {
//       faqs.add({
//         'question': item['question'],
//         'answer': item['answer'],
//       });
//     }
//     return faqs;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('FAQ'),
//         centerTitle: true,
//         elevation: 4,
//         backgroundColor: Colors.blueAccent, // Keep the default color scheme
//       ),
//       body: FutureBuilder<List<Map<String, String>>>(
//         future: fetchFAQs(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No FAQs available.'));
//           } else {
//             final faqs = snapshot.data!;
//             return ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
//               itemCount: faqs.length,
//
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 12.0),
//                   child: Card(
//                     elevation: 6,
//                     shadowColor: Colors.grey.withOpacity(0.3),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: ExpansionTile(
//                       tilePadding: const EdgeInsets.all(16.0),
//                       title: Text(
//                         faqs[index]['question'] ?? 'No question',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       // subtitle: const Text(
//                       //   'Tap to expand',
//                       //   style: TextStyle(fontSize: 14, color: Colors.white),
//                       // ),
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Text(
//                             faqs[index]['answer'] ?? 'No answer available',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
//
// }
//
//
//
//

import 'package:flutter/material.dart';
import 'package:learnloop/supabase_config.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _faqs = [];
  List<Map<String, String>> _filteredFaqs = [];

  Future<void> fetchFAQs() async {
    final response = await SupabaseConfig.client.from('faq').select();

    final List<Map<String, String>> faqs = [];
    for (var item in response) {
      faqs.add({
        'question': item['question'],
        'answer': item['answer'],
      });
    }
    setState(() {
      _faqs = faqs;
      _filteredFaqs = faqs; // Initialize filteredFaqs with all data
    });
  }

  void _filterFAQs(String query) {
    setState(() {
      _filteredFaqs = _faqs
          .where((faq) => faq['question']!.toLowerCase().contains(query.toLowerCase()) ||
          faq['answer']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFAQs(); // Fetch FAQs on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.green,
      ),
      body: _faqs.isEmpty // Check if the FAQs have been fetched
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterFAQs,
                    decoration: const InputDecoration(
                      labelText: 'Search FAQs...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _filterFAQs(_searchController.text);
                  },
                ),
              ],
            ),
          ),
          // FAQ list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              itemCount: _filteredFaqs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Card(
                    elevation: 6,
                    //shadowColor: Colors.grey.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.all(16.0),
                      title: Text(
                        _filteredFaqs[index]['question'] ?? 'No question',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _filteredFaqs[index]['answer'] ?? 'No answer available',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
