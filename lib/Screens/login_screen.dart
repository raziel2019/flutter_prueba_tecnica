import 'package:flutter/material.dart';
import 'package:prueba_tecnica/Widgets/custom_button.dart';
import 'package:prueba_tecnica/Widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar( title: const Text("Login")),
      body:Form(
        key: _formKey,
        child:Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              label: 'Email', 
              obscureText: false, 
              onSaved: (value) {
                email = value ??  '';
            }, ),
            const SizedBox(height: 16,),
            CustomTextField(
              label: "Password", 
              obscureText: true, 
              onSaved: (value){
                password = value ??  '';
              } ,),
            const SizedBox(height: 16,),
            CustomButton(
            onPressed: (){
              if(_formKey.currentState!.validate()){
                _formKey.currentState!.save();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sesion Iniciada"))
                );
              }
            } , 
            customText: "Iniciar Sesion"
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text.rich(
              TextSpan(
                text:"¿Todavia no tienes una cuenta creada? ",
                children: [
                  TextSpan(text: 'Registrate', 
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
        )
      ) 
        ),
      
    );
  }
}

