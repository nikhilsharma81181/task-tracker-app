import 'package:flutter/material.dart';

class AddTasks extends StatefulWidget {
  const AddTasks({super.key});

  @override
  State<AddTasks> createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  double _bottomSheetHeight = 350.0;

  @override
  void initState() {
    super.initState();
    // Add a listener to the description controller to detect keyboard appearance
    _descriptionController.addListener(() {
      if (_descriptionController.text.isNotEmpty) {
        setState(() {
          // When the keyboard appears, move the bottom sheet above it
          _bottomSheetHeight = MediaQuery.of(context).viewInsets.bottom + 300.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _bottomSheetHeight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _bottomSheetHeight =
                        MediaQuery.of(context).viewInsets.bottom + 350.0;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Description',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Enter description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    // When the keyboard appears, move the bottom sheet above it
                    _bottomSheetHeight =
                        MediaQuery.of(context).viewInsets.bottom + 350.0;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Submit the form and close the bottom sheet
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
