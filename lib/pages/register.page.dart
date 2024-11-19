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
  String _termsAndConditions = 'no';
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
        SnackBar(content: Text('Las contraseñas no son iguales.'), backgroundColor: Colors.red),
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
        SnackBar(content: Text('Usuario registrado con éxito.'), backgroundColor: Colors.greenAccent),
      );
      Navigator.pushNamed(context, '/login');
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor asegúrate de llenar todos los datos.'), backgroundColor: Colors.red),
      );
    } else if (response.statusCode == 409) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Este email ya está en uso.'), backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ha ocurrido un error al crear el usuario.'), backgroundColor: Colors.red),
      );
    }
  }

  void _showTermsAndConditionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Términos y Condiciones'),
          content: const SingleChildScrollView(
            child: Text(
              'Bienvenido a nuestra aplicación móvil de renta de automóviles (en adelante, la "Aplicación"). '
                  'Antes de utilizar nuestros servicios, es importante que lea detenidamente los presentes '
                  'Términos y Condiciones. Al descargar, acceder o utilizar la Aplicación, usted acepta estar sujeto a los '
                  'términos establecidos a continuación. Si no está de acuerdo con estos términos, no utilice la Aplicación. \n'
                  '1. La Aplicación está diseñada para facilitar el alquiler de vehículos entre arrendadores y arrendatarios, promoviendo la seguridad, confianza y transparencia en las transacciones.\n'
                  '2. Para utilizar la Aplicación, debe ser mayor de edad según la legislación de su país y contar con una licencia de conducir válida (en caso de arrendar un vehículo).\n'
                  '3. El usuario es responsable de proporcionar información veraz, completa y actualizada al registrarse y al utilizar los servicios de la Aplicación.\n',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8.0, // Más sombra
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    // Radio Buttons para seleccionar tipo de usuario
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
                    const SizedBox(height: 20),
                    _buildInputField(_nameController, 'Nombre'),
                    const SizedBox(height: 12),
                    _buildInputField(_lastnameController, 'Apellido'),
                    const SizedBox(height: 12),
                    // Campo de fecha de nacimiento con íconos
                    TextFormField(
                      controller: _birthDateController,
                      decoration: InputDecoration(
                        labelText: 'Fecha de Nacimiento',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(_phoneController, 'Número de Teléfono', keyboardType: TextInputType.phone),
                    const SizedBox(height: 12),
                    _buildInputField(_gmailController, 'Gmail', keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 12),
                    _buildInputField(_passwordController, 'Contraseña', obscureText: true),
                    _buildInputField(_confirmPasswordController, 'Repetir Contraseña', obscureText: true),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: (){
                          _showTermsAndConditionsDialog(context);
                        },
                        child: const Text(
                          'Leer Términos y Condiciones',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6F00),
                              decoration: TextDecoration.underline,
                              fontSize: 18
                          ),
                        ),
                      ),
                    ),
                    RadioListTile<String>(
                      title: const Text('Acepto los Términos y Condiciones'),
                      value: 'si',
                      groupValue: _termsAndConditions,
                      onChanged: (value) {
                        setState(() {
                          _termsAndConditions = value!;
                        });
                      },
                    ),
                    // Botón de registro
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Completar Registro', style: TextStyle(fontSize: 16.0)),
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

  // Método reutilizable para los campos de texto
  Widget _buildInputField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text, bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: Icon(keyboardType == TextInputType.phone ? Icons.phone : Icons.text_fields),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}
