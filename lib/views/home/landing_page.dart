import 'package:edupasss/views/auth/login_page.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageScreenState createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/learn.png",
      "title": "E-Learning",
      "subtitle": "Apprenez à tout moment et en tout lieu"
    },
    {
      "image": "assets/images/etudiant.png",
      "title": "Apprenants",
      "subtitle": "Développez vos compétences efficacement"
    },
    {
      "image": "assets/images/encadrant.png",
      "title": "Formateurs",
      "subtitle": "Partagez vos connaissances simplement"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // --- AppBar avec EDUPASS centré + bouton Passer ---
      appBar: AppBar(
        backgroundColor: Color(0xFF3B82F6),
        elevation: 4,
        centerTitle: true,
        title: const Text(
          "EDUPASS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
        actions: [
          if (currentIndex < onboardingData.length - 1)
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                "Passer",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        onboardingData[index]['image']!,
                        height: 250,
                      ),
                      SizedBox(height: 40),
                      Text(
                        onboardingData[index]['title']!,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        onboardingData[index]['subtitle']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // --- Indicateurs de page ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(onboardingData.length, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: currentIndex == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? Colors.blue[700]
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            SizedBox(height: 40),

            // --- Bouton COMMENCER / SUIVANT ---
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 58.0, vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  if (currentIndex == onboardingData.length - 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  } else {
                    _controller.nextPage(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 56),
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 6,
                ),
                child: Text(
                  currentIndex == onboardingData.length - 1
                      ? 'COMMENCER'
                      : 'SUIVANT',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
