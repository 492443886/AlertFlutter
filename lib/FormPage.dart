import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();
  final TextEditingController _otherInfoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _nameController = TextEditingController();
    // _birthdayController = TextEditingController();
    // _addressController = TextEditingController();
    // _emergencyContactController = TextEditingController();
    // _otherInfoController = TextEditingController();
    loadFormValues();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdayController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    _otherInfoController.dispose();
    super.dispose();
  }

  void loadFormValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _birthdayController.text = prefs.getString('birthday') ?? '';
      _addressController.text = prefs.getString('address') ?? '';
      _emergencyContactController.text =
          prefs.getString('emergency_contact') ?? '';
      _otherInfoController.text = prefs.getString('other_info') ?? '';
    });
  }

  void saveFormValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _nameController.text);
    prefs.setString('birthday', _birthdayController.text);
    prefs.setString('address', _addressController.text);
    prefs.setString('emergency_contact', _emergencyContactController.text);
    prefs.setString('other_info', _otherInfoController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _birthdayController,
                  decoration: InputDecoration(labelText: 'Birthday'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your birthday';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emergencyContactController,
                  decoration: InputDecoration(labelText: 'Emergency Contact'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter emergency contact';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _otherInfoController,
                  decoration: InputDecoration(labelText: 'Other Information'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      saveFormValues();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Form saved successfully!'),
                        ),
                      );
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    }
                    ;
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
