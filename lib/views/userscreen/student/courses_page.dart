import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Dio _dio = Dio();

  // 🔹 Exemple de séparation entre cours avec quiz et sans quiz
  final Map<String, Map<String, List<Map<String, String>>>> _coursesByCategory = {
    "Maths": {
      "Avec Quiz": [
        {"title": "Algèbre linéaire", "pdfUrl": "https://example.com/algebre.pdf"},
      ],
      "Sans Quiz": [
        {"title": "Analyse", "pdfUrl": "https://example.com/analyse.pdf"},
      ],
    },
    "Physique": {
      "Avec Quiz": [
        {"title": "Mécanique classique", "pdfUrl": "https://example.com/mecanique.pdf"},
      ],
      "Sans Quiz": [
        {"title": "Optique", "pdfUrl": "https://example.com/optique.pdf"},
      ],
    },
    "Informatique": {
      "Avec Quiz": [
        {"title": "Programmation Dart", "pdfUrl": "https://example.com/dart.pdf"},
      ],
      "Sans Quiz": [
        {"title": "Bases de données", "pdfUrl": "https://example.com/bdd.pdf"},
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _coursesByCategory.keys.length,
      vsync: this,
    );
  }

  Future<void> _downloadAndOpenPdf(String url, String fileName) async {
    try {
      if (await Permission.storage.request().isGranted) {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = "${dir.path}/$fileName.pdf";

        await _dio.download(url, filePath);

        OpenFile.open(filePath);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission refusée")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur téléchargement : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color blueColor = const Color(0xFF365DA8);

    return DefaultTabController(
      length: _coursesByCategory.keys.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cours"),
          backgroundColor: blueColor,
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: _coursesByCategory.keys
                .map((category) => Tab(text: category))
                .toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: _coursesByCategory.keys.map((category) {
            final categoryData = _coursesByCategory[category]!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: categoryData.keys.map((rubrique) {
                  final courses = categoryData[rubrique]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rubrique,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: blueColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: courses.map((course) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.picture_as_pdf,
                                      color: blueColor, size: 40),
                                  const SizedBox(height: 12),
                                  Text(
                                    course["title"]!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: blueColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: blueColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      _downloadAndOpenPdf(
                                        course["pdfUrl"]!,
                                        course["title"]!,
                                      );
                                    },
                                    icon: const Icon(Icons.download),
                                    label: const Text("Ouvrir"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
