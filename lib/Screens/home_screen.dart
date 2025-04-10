import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prueba_tecnica/Services/auth_service.dart';
import 'package:prueba_tecnica/Services/category_service.dart';
import 'package:prueba_tecnica/Widgets/custom_button.dart';
import 'package:prueba_tecnica/Widgets/custom_text_field.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<dynamic> _categories = [];
  final _formKey = GlobalKey<FormState>();
  String code = '';
  String name = '';
  String description = '';
  File? photo;
  int parent_id = 0;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  static const TextStyle optionStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) getAllCategories();
  }

  void getAllCategories() async {
    final categoryService = CategoryService();
    try {
      final categories = await categoryService.getAll();
      setState(() {
        _categories = categories;
      });
      print(_categories);
    } catch (e) {
      print("Error al obtener categorías: $e");
    }
  }

  Future<void> _pickImage() async  {
    final PickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (PickedFile  !=  null){
      setState(() {
        _imageFile = File(PickedFile.path);
      });
    }
  }

  List<DropdownMenuItem<int>> _buildCategoryDropdownItems(List<dynamic> categories) {
  List<DropdownMenuItem<int>> items = [];

  for (var parent in categories) {
    items.add(
      DropdownMenuItem(
        value: parent['id'],
        child: Text(parent['name']),
      ),
    );

    final children = parent['children'] as List<dynamic>?;
    if (children != null && children.isNotEmpty) {
      for (var child in children) {
        items.add(
          DropdownMenuItem(
            value: child['id'],
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('↳ ${child['name']}'),
            ),
          ),
        );
      }
    }
  }

  return items;
}


  void _showAddCategoryDialog(){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Categoria'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                SizedBox(height: 16,),

                CustomTextField(
                label: "code",
                obscureText: false,
                onSaved: (value){
                  code = value ?? '';
                  },
                ),
                SizedBox(height: 16,),
                CustomTextField(
                  label: "name",
                  obscureText: false,
                  onSaved: (value){
                    name = value ?? '';
                    },  
                  ),
                SizedBox(height: 16,),
                CustomTextField(
                  label: "description",
                  obscureText: false,
                  onSaved: (value){
                    description = value ?? '';
                    },
                  ),                
                  SizedBox(height: 16,),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: "Categoria padre",
                      border: OutlineInputBorder(),
                    ),
                    items: _buildCategoryDropdownItems(_categories),
                    onChanged: (value) {
                      parent_id = value ?? 0;
                    }
                    ),

                  SizedBox(height: 16,),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text("Agregar imagen a la categoria"),
                  ),
                  if (_imageFile != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Image.file(_imageFile!, height: 100),
                    ),
                  SizedBox(height: 16,),
                  CustomButton(
                    customText: "Guardar",
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                      saveCategory();  
                      }
                    },
                    ),
                  SizedBox(height: 16,),
                  CustomButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    customText: "Cerrar"
                    )

              ] 
            ),
            ),
            
            ),
        );
      },
    );
  }

  void logout() async {
    final auth = AuthService();
    final success = await auth.logout();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sesión cerrada")),
      );
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Widget _buildCategoriesList() {
    if (_categories.isEmpty) {
      return const Text('No hay categorías disponibles', style: optionStyle);
    }

    return Column(
      children: [
        Expanded(
    child:ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final parent = _categories[index];
        final children = parent['children'] as List<dynamic>?;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                  leading: const Icon(Icons.category),
                  title: Text(
                    parent['name'] ?? 'Sin nombre',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if(parent['photo'] != null)
                  Image.network(
                  parent['photo'],
                  fit: BoxFit.cover,
                  ),
                ],   
              ),
             
            ),
            
            if (children != null && children.isNotEmpty)
              ...children.map((child){
                return Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.subdirectory_arrow_right),
                      title: Text(child['name'] ?? 'Sin nombre'),
                    ),
                  ),
                );
              }).toList(),
          ],
        );
      },
    ),
  ),
        FloatingActionButton(
          onPressed: _showAddCategoryDialog,
          child: Icon(Icons.add),
          ),
      ],
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const Center(child: Text('Inicio', style: optionStyle));
      case 1:
        return _buildCategoriesList();
      case 2:
        return const Center(child: Text('Información de la app', style: optionStyle));
      default:
        return const Center(child: Text('Página no encontrada', style: optionStyle));
    }
  }

  void saveCategory() async{
    final category = CategoryService();
    try {
      final success = await category.createCategory(
        code: code,
        name: name,
        description: description,
        photo: _imageFile,
        parent_id: parent_id
      );
    if(success){
      print("Categoria registrada");

    }
    }catch(error){
      print("Error al guardar una categoria: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menú Principal',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categorías'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.pop(context);
                logout();
              },
            ),
          ],
        ),
      ),
      body: _buildContent(),
    );
  }
}