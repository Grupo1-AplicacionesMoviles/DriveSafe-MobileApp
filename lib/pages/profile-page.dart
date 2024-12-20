import 'dart:convert';
import 'package:drivesafe_mobile_application/pages/login.page.dart';
import 'package:flutter/material.dart';
import 'package:drivesafe_mobile_application/services/user.service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/UserModel.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  final UserService userService = UserService();
  UserModel? user;
  TextEditingController editController = TextEditingController();
  String? editingField;
  DateTime? _selectedDate;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int userId = int.parse(decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid']);

    try {
      final response = await userService.getByUserId(id: userId);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          user = UserModel.fromJson(data);
        });
      } else {
        print("Error al cargar los datos del usuario: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en la carga de datos: $e");
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('password');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void showEditDialog(String field, String currentValue) {
    editController.text = currentValue;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar $field'),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(labelText: 'Nuevo valor'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                saveField(field);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showEditDialogName(String field, String currentName, String currentLastName) {
    TextEditingController nameController = TextEditingController(text: currentName);
    TextEditingController lastNameController = TextEditingController(text: currentLastName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Nombre Completo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nuevo Nombre'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Nuevo Apellido'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                saveFullName(nameController.text, lastNameController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void saveField(String field) {
    if (field == 'Número de Teléfono') {
      print('Guardar nuevo número de teléfono: ${editController.text}');
      setState(() {
        user!.cellphone = int.tryParse(editController.text) ?? user!.cellphone;
      });
    }
    editController.clear();
  }

  void saveFullName(String newName, String newLastName) {
    print('Guardar nuevo nombre: $newName y nuevo apellido: $newLastName');
    setState(() {
      user!.name = newName;
      user!.lastName = newLastName;
    });
    editController.clear();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      saveBirthDate(picked);
    }
  }

  void saveBirthDate(DateTime newDate) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(newDate);
    
    print('Guardar nueva fecha de nacimiento: $formattedDate');
    setState(() {
      user!.birthDate = formattedDate;
    });
  }

  Future<bool> updateUser(BuildContext context) async {
    if (user == null) return false;

    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int userId = int.parse(decodedToken[
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid']);
    String? password = prefs.getString('password');

    user!.password = password ?? user!.password;

    try {
      final response = await userService.updateUser(id: userId, user: user!);
      if (response.statusCode == 200) {
        print("Usuario actualizado correctamente.");
        
        showSnackBar(context, "Usuario actualizado correctamente.");
        return true;
      } else {
        print("Error al actualizar el usuario: ${response.statusCode}");
        
        showSnackBar(
            context, "Error al actualizar el usuario: ${response.statusCode}");
        return false;
      }
    } catch(e) {
      print("Error en la actualización del usuario: $e");
      
      showSnackBar(context, "Error en la actualización del usuario.");
      return false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : user == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.orange,
                  child: Text(
                    user!.name[0] + user!.lastName[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              buildEditableRow('Nombre Completo:', '${user!.name} ${user!.lastName}', () {
                showEditDialogName('Nombre Completo', '${user!.name}', '${user!.lastName}');
              }),
              const SizedBox(height: 10),
              buildEditableRow('Correo:', user!.gmail, null),
              const SizedBox(height: 10),
              buildEditableRow('Fecha de Nacimiento:', user!.birthDate, () {
                selectDate(context);
              }),
              const SizedBox(height: 10),
              buildEditableRow('Número de Teléfono:', user!.cellphone.toString(), () {
                showEditDialog('Número de Teléfono', user!.cellphone.toString());
              }),
              const SizedBox(height: 10),
              Text(
                'Tipo de Usuario:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                user!.type == 'tenant' ? 'Arrendatario' : 'Arrendador',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                            updateUser(context);
                          },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:BorderRadius.circular(8),
                            ),
                            padding:
                              const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text("Guardar cambios"),
                      ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Cerrar sesión"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

  Widget buildEditableRow(String label, String value, VoidCallback? onEdit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
      ],
    );
  }
}
