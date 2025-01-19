import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'results_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FaceProfilePhotosPage extends StatefulWidget {
  final double userHeight;

  const FaceProfilePhotosPage({
    super.key,
    required this.userHeight,
  });

  @override
  FaceProfilePhotosPageState createState() => FaceProfilePhotosPageState();
}

class FaceProfilePhotosPageState extends State<FaceProfilePhotosPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _frontImage;
  XFile? _sideImage;
  

  Future<void> sendImagesToApi(BuildContext context) async {
    if (_frontImage == null || _sideImage == null) {
      _showErrorDialog(context, message: 'Please upload both images.');
      return;
    }

    // Afficher un indicateur de chargement personnalisé
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Processing...",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Please wait while we process your images.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );


    try {
      //final uri = Uri.parse('http://192.168.1.22:5000/calculate-bri'); //
      final uri = Uri.parse('https://circumfit.onrender.com/calculate-bri'); //URL publique de l'API
      final request = http.MultipartRequest('POST', uri);

      // Ajouter les images et la taille
      request.fields['user_height_cm'] = widget.userHeight.toString();
      request.files.add(await http.MultipartFile.fromPath('image_side', _sideImage!.path));
      request.files.add(await http.MultipartFile.fromPath('image_front', _frontImage!.path));

      // Envoyer la requête
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final result = jsonDecode(responseData);

        // Naviguer vers la page des résultats
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPage(
              waistCircumference: result['waist_circumference'], // Valeur reçue de l'API
              bri: result['BRI'], // Valeur reçue de l'API
            ),
          ),
        );
      } else {
        _showErrorDialog(context, message: 'API Error: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog(context, message: 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Face & Profile Photos',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildPhotoSection(
                label: "Front Photo",
                image: _frontImage,
                onPickImage: () => _pickImage(ImageType.front),
              ),
              const SizedBox(height: 30),
              _buildPhotoSection(
                label: "Side Photo",
                image: _sideImage,
                onPickImage: () => _pickImage(ImageType.side),
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 186, 186, 186), Color.fromARGB(136, 78, 78, 78)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha((0.3 * 255).toInt()),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_frontImage != null && _sideImage != null) {
                        sendImagesToApi(context); // Appelle l'API
                      } else {
                        _showErrorDialog(context, message: 'Please upload both images.');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection({
    required String label,
    required XFile? image,
    required VoidCallback onPickImage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onPickImage,
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(51),
                  spreadRadius: 4,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      File(image.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                : const Center(
                    child: Text(
                      "Tap to upload photo",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _pickImage(ImageType type) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Choose an option",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.grey, thickness: 1),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildOptionButton(
                      icon: Icons.camera_alt,
                      label: "Camera",
                      onTap: () async {
                        final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          setState(() {
                            if (type == ImageType.front) {
                              _frontImage = image;
                            } else {
                              _sideImage = image;
                            }
                          });
                        }
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    _buildOptionButton(
                      icon: Icons.photo_library,
                      label: "Gallery",
                      onTap: () async {
                        final XFile? image = await _picker.pickImage(source: ImageSource.gallery); // Utiliser gallery ici
                        if (image != null) {
                          setState(() {
                            if (type == ImageType.front) {
                              _frontImage = image;
                            } else {
                              _sideImage = image;
                            }
                          });
                        }
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),

                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha((0.1 * 255).toInt()),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, {required String message}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 40),
                const SizedBox(height: 10),
                const Text(
                  "Error",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message, // Utilisation du message passé en paramètre
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum ImageType { front, side }


