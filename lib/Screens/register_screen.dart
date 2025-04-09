import 'package:flutter/material.dart';
import 'package:prueba_tecnica/Widgets/custom_button.dart';
import 'package:prueba_tecnica/Widgets/custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prueba_tecnica/Services/auth_service.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String password = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register"),),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
              label: 'Username', 
              obscureText: false, 
              onSaved: (value) {
                username = value ?? '';
              },
              ),
              SizedBox(
                height: 16,
              ),
              CustomTextField(
                label: "Email",
                obscureText: false,
                onSaved: (value)  {
                  email = (value) ?? '';
                },
                ),
              SizedBox(
                height: 16,
              ),
              CustomTextField(
                label: "Password",
                obscureText: true,
                onSaved: (value) {
                  password = value  ?? '';
                },
                ),
              SizedBox(
                height: 16,
              ),
              CustomButton(
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                    saveRegister();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Registro exitoso"))
                    );
                  }
                },
                customText: "Registrate"
                ),
                SizedBox(height: 16,),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "¿Ya tienes cuenta? ",
                      children: [
                        TextSpan(
                          text: "Inicia Sesion",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          )
                        ),
                      ]
                    )
                  ),
                )
            ],
          ),
        )
        ),
    );
  }

  void saveRegister() async  {

    final auth = AuthService();
    try {
      final success = await  auth.register(
        name: username, 
        email: email, 
        password: password
        );
        if(success){
          print("Registro exitoso");
          if(mounted){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registro exitoso"))
            );
          }else{
            print("Error en el registro");
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Ocurrió un error al registrarse"))
              );
            }
          }
        }
      }catch(error){
      print("Error al hacer el registro: $error");
    }
  
  }
}