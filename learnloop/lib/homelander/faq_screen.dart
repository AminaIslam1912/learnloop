
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
      _filteredFaqs = faqs;
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
    fetchFAQs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ', style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 20,
            color: Colors.white
        ),),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.black,
      ),
      body: _faqs.isEmpty
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
                    cursorColor: Colors.green,

                    onChanged: _filterFAQs,
                    decoration: InputDecoration(
                      labelText: 'Search FAQs...',
                      labelStyle: const TextStyle(
                        color: Colors.green,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              itemCount: _filteredFaqs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.all(16.0),
                      title: Text(
                        _filteredFaqs[index]['question'] ?? 'No question',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Icon( Icons.expand_more, color: Colors.green),

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
