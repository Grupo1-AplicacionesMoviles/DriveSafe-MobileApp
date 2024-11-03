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
  final UserService _userService = UserService();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    int UserId = int.parse(decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid']);

    try {
      final response = await _userService.getByUserId(id: UserId);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _user = UserModel.fromJson(data);
        });
      } else {
        print("Error al cargar los datos del usuario: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en la carga de datos: $e");
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
        child: _user == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.cyan,
                child: Text(
                  _user!.name[0] + _user!.lastName[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildEditableRow('Nombre Completo:', '${_user!.name} ${_user!.lastName}', () {
              // Lógica para editar el nombre
            }),
            const SizedBox(height: 10),
            _buildEditableRow('Correo:', _user!.gmail, null), // Sin ícono
            const SizedBox(height: 10),
            _buildEditableRow('Fecha de Nacimiento:', _user!.birthDate, () {
              // Lógica para editar la fecha de nacimiento
            }),
            const SizedBox(height: 10),
            _buildEditableRow('Número de Teléfono:', _user!.cellphone.toString(), () {
              // Lógica para editar el número de teléfono
            }),
            const SizedBox(height: 10),
            Text(
              'Tipo de Usuario:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              _user!.type == 'tenant' ? 'Arrendatario' : 'Arrendador', // Tipo de usuario
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableRow(String label, String value, VoidCallback? onEdit) {
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
