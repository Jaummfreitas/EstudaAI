import 'dart:io';
import 'package:estudeai/Views/Service/SessionManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:estudeai/Views/Service/UsuarioService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:estudeai/Views/Perfil/perfil.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int idUsuario = SessionManager().userId!;
  final usuarioService = UsuarioService.instance;
  late TextEditingController nameController;
  late TextEditingController emailController;
  final TextEditingController passwordController = TextEditingController();
  File? _image;
  File? _image2;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> uploadImageToFirebase(File? imageFile) async {
    if (imageFile == null) {
      print("No image selected");
      return;
    }

    try {
      // Referência ao bucket
      String idUsuarioString = idUsuario.toString();
      final storageRef =
          FirebaseStorage.instance.ref().child("images/$idUsuarioString.png");

      // Upload do arquivo
      await storageRef.putFile(imageFile);

      // Recupera a URL do arquivo
      String downloadUrl = await storageRef.getDownloadURL();
      print("Image uploaded successfully. URL: $downloadUrl");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<void> loadImageFromAssetsAndUpload() async {
    try {
      // Nome do arquivo
      final fileName = "-1.png";

      // Carrega o arquivo dos assets
      final byteData = await rootBundle.load('imagem/$fileName');

      // Define o caminho da pasta personalizada (temp)
      final filePath = p.join('temp', fileName);

      // Cria a pasta 'temp' se ela não existir
      final tempDir = Directory('temp');
      if (!tempDir.existsSync()) {
        tempDir.createSync();
      }

      // Salva o arquivo na pasta 'temp'
      final file = File(filePath);
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // Atribui à variável _image2
      _image2 = file;

      // Faz o upload para o Firebase
    } catch (e) {
      print("Error loading image from assets: $e");
    }
  }

  Future<void> _fetchUserData() async {
    final userId = SessionManager().userId as int;
    try {
      final String name = await usuarioService.obterNomePorId(userId);
      final String email = await usuarioService.obterEmailPorId(userId);
      setState(() {
        nameController = TextEditingController(text: name);
        emailController = TextEditingController(text: email);
      });
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
      setState(() {
        nameController = TextEditingController(text: "Erro ao carregar nome");
        emailController = TextEditingController(text: "Erro ao carregar email");
      });
    }
  }

  Future<void> _updateUserData() async {
    final userId = SessionManager().userId as int;
    try {
      // Atualiza o nome se foi modificado
      if (nameController.text.isNotEmpty) {
        await usuarioService.atualizarNome(userId, nameController.text);
      }

      // Atualiza o email se foi modificado
      if (emailController.text.isNotEmpty) {
        await usuarioService.atualizarEmail(userId, emailController.text);
      }

      // Atualiza a senha se foi modificada
      if (passwordController.text.isNotEmpty) {
        await usuarioService.atualizarSenha(userId, passwordController.text);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados atualizados com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
    } catch (e) {
      print("Erro ao atualizar dados do usuário: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao atualizar dados. Tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print(e);
    } finally {
      Navigator.of(context).pop();
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
                              const Icon(Icons.image,
                                  size: 60, color: Colors.grey),
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
                onPressed: () async {
                  // Certifique-se de que _image2 não é nulo antes de chamar uploadImageToFirebase
                  if (_image != null) {
                    await uploadImageToFirebase(_image);
                  } else {
                    print("No image selected to upload");
                  }

                  // Chame a função _updateUserData com os parênteses para executá-la
                  _updateUserData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF26A69A),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
