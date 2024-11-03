import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:drivesafe_mobile_application/services/user.service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/UserModel.dart';

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
    print('Guardar nuevo valor para $field: ${editController.text}');
    editController.clear();
  }

  void saveFullName(String newName, String newLastName) {
    print('Guardar nuevo nombre: $newName y nuevo apellido: $newLastName');
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
        child: user == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.cyan,
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
