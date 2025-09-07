import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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

  final Map<String, List<Map<String, String>>> _coursesByCategory = {
    "Maths": [
      {
        "title": "Algèbre linéaire",
        "pdfUrl":
        "https://example.com/algebre.pdf"
      },
      {
        "title": "Analyse",
        "pdfUrl":
        "https://example.com/analyse.pdf"
      },
    ],
    "Physique": [
      {
        "title": "Mécanique classique",
        "pdfUrl":
        "https://example.com/mecanique.pdf"
      },
      {
        "title": "Optique",
        "pdfUrl":
        "https://example.com/optique.pdf"
      },
    ],
    "Informatique": [
      {
        "title": "Programmation Dart",
        "pdfUrl":
        "https://example.com/dart.pdf"
      },
      {
        "title": "Bases de données",
        "pdfUrl":
        "https://example.com/bdd.pdf"
      },
    ],
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
      // Demande de permission
      if (await Permission.storage.request().isGranted) {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = "${dir.path}/$fileName.pdf";

        // Téléchargement
        await _dio.download(url, filePath);

        // Ouvrir le fichier
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
    final Color blueColor = const Color(0xFF3B82F6);

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
            final courses = _coursesByCategory[category]!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: blueColor.withOpacity(0.1),
                      child: Icon(Icons.picture_as_pdf, color: blueColor),
                    ),
                    title: Text(course["title"]!),
                    subtitle: Text("Télécharger le cours"),
                    trailing: IconButton(
                      icon: const Icon(Icons.download),
                      color: blueColor,
                      onPressed: () {
                        _downloadAndOpenPdf(
                          course["pdfUrl"]!,
                          course["title"]!,
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
