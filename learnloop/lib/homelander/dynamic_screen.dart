
import 'package:flutter/material.dart';
import 'package:learnloop/homelander/webview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DynamicScreen extends StatefulWidget {
  final int courseId;

  const DynamicScreen({super.key, required this.courseId});

  @override
  State<DynamicScreen> createState() => _DynamicScreenState();
}

class _DynamicScreenState extends State<DynamicScreen>
    with SingleTickerProviderStateMixin {
  String? articles;
  String? tutorials;
  String? thumbnailImage;
  String? courseTitle;
  String? courseDescription;
  String? articleDescription;
  bool isLoading = true;
  late TabController _tabController;

  bool get hasValidArticleLink =>
      articles != null &&
          articles!.startsWith('http') &&
          articles != 'No articles available at this moment.';

  bool get hasValidTutorialLink =>
      tutorials != null &&
          tutorials!.startsWith('http') &&
          tutorials != 'No tutorials available at this moment.';

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('course')
          .select(
          'articles, tutorials, thumbnail_image, description, article_description')
          .eq('id', widget.courseId)
          .single();

      setState(() {
        articles = response['articles'] as String?;
        tutorials = response['tutorials'] as String?;
        thumbnailImage = response['thumbnail_image'] as String?;
        courseDescription = response['description'] as String?;
        articleDescription = response['article_description'] as String?;

        articles ??= 'No articles available at this moment.';
        tutorials ??= 'No tutorials available at this moment.';
        courseDescription ??= 'Course description not available at the moment.';
        articleDescription ??=
        'Article description not available at this moment.';
      });
    } catch (error) {
      setState(() {
        articles = 'Failed to load articles.';
        tutorials = 'Failed to load tutorials.';
        thumbnailImage = null;
        courseDescription = 'Failed to load course description.';
        articleDescription = 'Failed to load article description.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching resources: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildContentSection(
      {required String? content,
        required String? description,
        required String buttonText,
        required String buttonLabel,
        required bool hasValidLink}) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green.withOpacity(0.2),
                Colors.black.withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.green.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (thumbnailImage != null) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Image.network(
                        thumbnailImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.broken_image,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                  Text(
                    description ?? "Description not available.",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (hasValidLink) ...[
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                url: content!,
                                title: buttonLabel,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              buttonText == "Read Article"
                                  ? Icons.article
                                  : Icons.play_arrow,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              buttonText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    const Text(
                      'No content available at this moment.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Resources",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Articles'),
            Tab(text: 'Tutorials'),
          ],
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.green,
          strokeWidth: 3,
        ),
      )
          : TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: _buildContentSection(
              content: articles,
              description: articleDescription,
              buttonText: "Read Article",
              buttonLabel: "Article",
              hasValidLink: hasValidArticleLink,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: _buildContentSection(
              content: tutorials,
              description: courseDescription,
              buttonText: "Watch Video",
              buttonLabel: "Tutorial Video",
              hasValidLink: hasValidTutorialLink,
            ),
          ),
        ],
      ),
    );
  }
}