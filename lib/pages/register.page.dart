import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth.service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService authService = AuthService();
  String _userType = '';
  DateTime? _selectedDate;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _gmailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _register() async {
    String name = _nameController.text;
    String lastname = _lastnameController.text;
    String password = _passwordController.text;
    String phone = _phoneController.text;
    String gmail = _gmailController.text;
    String birthDate = _birthDateController.text;

    int phoneInt = int.parse(phone);

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Las contraseñas no son iguales.'),
          backgroundColor: Colors.red,),
      );
      return;
    }

    var response = await authService.register(
      name: name,
      lastname: lastname,
      birthDate: birthDate,
      phone: phoneInt,
      gmail: gmail,
      password: password,
      userType: _userType,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario registrado con éxito.'),
            backgroundColor: Colors.greenAccent,));
      Navigator.pushNamed(context, '/login');
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor asegúrate de llenar todos los datos.'),
        backgroundColor: Colors.red,));
    } else if (response.statusCode == 409) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Este email ya está en uso.'),
            backgroundColor: Colors.red));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ha ocurrido un error al crear el usuario.'),
            backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    RadioListTile<String>(
                      title: const Text('Arrendatario'),
                      value: 'tenant',
                      groupValue: _userType,
                      onChanged: (value) {
                        setState(() {
                          _userType = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Arrendador'),
                      value: 'owner',
                      groupValue: _userType,
                      onChanged: (value) {
                        setState(() {
                          _userType = value!;
                        });
                      },
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _lastnameController,
                      decoration: const InputDecoration(
                        labelText: 'Apellido',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _birthDateController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de Nacimiento',
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Número de Teléfono',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _gmailController,
                      decoration: const InputDecoration(
                        labelText: 'Gmail',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      obscureText: true,
                    ),
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Repetir Contraseña',
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _register,
                        child: const Text('Completar Registro'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}