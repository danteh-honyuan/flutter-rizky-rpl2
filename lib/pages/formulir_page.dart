import 'package:flutter/material.dart';

void main() {
  runApp(const FormulirPage());
}

class FormulirPage extends StatefulWidget {
  const FormulirPage({super.key});

  @override
  State<FormulirPage> createState() => _FormulirPageState();
}

class _FormulirPageState extends State<FormulirPage> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  String _outputName ='';
  @override
  void dispose() {
    // Setelah di submit nilai dari Textfield akan Terhapus 
    _nameController.dispose();   // TODO: implement dispose
    super.dispose();
  }

  void _submitForm() {
    print ('Nama Lengkap: ${_nameController.text}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Nama Lengkap ${_nameController.text}")),
    );
    setState(() {
      _outputName = _nameController.text;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My Form App')),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                    'Nama: ${_outputName.isEmpty ? "-" : _outputName}',
                    style: const TextStyle(fontSize: 16),
                  ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Enter your name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      print('Name: ${_nameController.text}');
                    },
                    child: const Text("Get Name"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _submitForm();
                    },
                    child: const Text("Submit"),
                  ),
                  
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}