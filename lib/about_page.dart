import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Modern Header
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Color.fromARGB(255, 127, 210, 248)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha((0.3 * 255).toInt()),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "About CircumFit",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your innovative waist measurement app.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionCard(
                    title: 'Overview',
                    content: RichText(
                      textAlign: TextAlign.justify,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                        children: [
                          TextSpan(text: 'This application was developed as part of the final-year engineering project at '),
                          TextSpan(
                            text: 'Polytech Marseille',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ', in collaboration with the '),
                          TextSpan(
                            text: 'Laboratory of Applied Biomechanics (LBA)',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ', under the supervision of '),
                          TextSpan(
                            text: 'Dr. Thierry Bège',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '. The goal is to propose an '),
                          TextSpan(
                            text: 'innovative methodology',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' for measuring abdominal and waist circumferences using a smartphone.'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionCard(
                    title: 'Contributors',
                    content: RichText(
                      textAlign: TextAlign.justify,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                        children: [
                          TextSpan(text: 'This project was carried out by two final-year biomedical engineering students:\n\n'),
                          TextSpan(
                            text: '- Germine Elias ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '(eliasgermine@gmail.com) \nfor mobile interface development\n',
                          ),
                          TextSpan(
                            text: '- Nouhaila Chabchi \n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '(chabchi.nouhaila@gmail.com) and ',
                          ),
                          TextSpan(
                            text: 'Germine Elias ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'for implementation of the measurement algorithm\n\n',
                          ),
                          TextSpan(
                            text: 'Both students are in their ',
                          ),
                          TextSpan(
                            text: '5th year',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' at Polytech Marseille and were involved in every step of the project, from ',
                          ),
                          TextSpan(
                            text: 'research',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' to '),
                          TextSpan(
                            text: 'development',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionCard(
                    title: 'Purpose',
                    content: RichText(
                      textAlign: TextAlign.justify,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                        children: [
                          TextSpan(text: 'CircumFit aims to provide '),
                          TextSpan(
                            text: 'healthcare professionals',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'patients',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' with an ',
                          ),
                          TextSpan(
                            text: 'accessible',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ', ',
                          ),
                          TextSpan(
                            text: 'quick',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ', and ',
                          ),
                          TextSpan(
                            text: 'reliable',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' tool for measuring body circumferences. The app is envisioned as a ',
                          ),
                          TextSpan(
                            text: 'free-to-use platform',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' offering advanced body measurement capabilities through smartphones.',
                          ),
                        ],
                      ),
                    ),
                    
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLogo('assets/logo_polytech.png'),
                        const SizedBox(width: 20), // Espace entre les logos
                        _buildLogo('assets/logo_lba.png'),
                      ],
                    ),
                  ),
                ],
              
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required RichText content}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.3 * 255).toInt()),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }

  Widget _buildLogo(String assetPath) {
  return Container(
    width: 150,
    height: 100,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(assetPath),
        fit: BoxFit.contain,
      ),
    ),
  );
}

}
