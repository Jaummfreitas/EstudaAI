import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
const SettingsPage({Key? key}) : super(key: key);

@override
State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
final TextEditingController nameController =
    TextEditingController(text: 'João Vítor');
final TextEditingController emailController =
    TextEditingController(text: 'jvitorfreitas2004@gmail.com');
final TextEditingController passwordController = TextEditingController();
File? _image;

Future<void> _pickImage(ImageSource source) async {
  try {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  } catch (e) {
    print(e); // Print the error for debugging
  } finally {
    Navigator.of(context).pop(); // Close the dialog
  }
}

@override
Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;

  return Scaffold(
    appBar: AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color(0xFF26A69A),
      title: const Text(
        'Editar Perfil',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    backgroundColor: Colors.white,
    body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.teal[700]!.withOpacity(.5),
                  width: 5.0,
                ),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.transparent,
                backgroundImage: _image != null ? FileImage(_image!) : null,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Icon(
                                Icons.image, size: 60, color: Colors.grey),
                            const SizedBox(height: 10),
                            const Text(
                              "Choose an image",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () =>
                                      _pickImage(ImageSource.gallery),
                                  child: const Text('Gallery'),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      _pickImage(ImageSource.camera),
                                  child: const Text('Camera'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text(
                'Alterar Foto',
                style: TextStyle(color: Colors.teal),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                hintText: 'Seu nome completo',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Seu email',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Senha',
                hintText: 'Nova senha',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF26A69A),
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Salvar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}