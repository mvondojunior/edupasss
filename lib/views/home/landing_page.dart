import 'package:edupasss/views/auth/login_page.dart';
import 'package:edupasss/views/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageScreenState createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPage> {
  PageController _controller = PageController();
  int currentIndex = 0;

  List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/learn.png",
      "title": "E-Learning",
    },
    {
      "image": "assets/images/etudiant.png",
      "title": "Apprenants",
    },
    {
      "image": "assets/images/encadrant.png",
      "title": "Professeurs",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3B82F6),
        centerTitle: true,
        title: const Text(
          'EDUPASS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
        elevation: 4,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        onboardingData[index]['image']!,
                        height: 300,
                      ),
                      SizedBox(height: 30),
                      Text(
                        onboardingData[index]['title']!,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(onboardingData.length, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: currentIndex == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: currentIndex == index ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            SizedBox(height: 40),

            // Get Started Button
            currentIndex == onboardingData.length - 1
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 58.0, vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  LoginPage()
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 56),
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Plus arrondi
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'COMMENCER',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            )
             : SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}