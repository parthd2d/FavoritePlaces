import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  PlaceLocation? _selectedLocation;
  String? _locationTitle;

  bool _isSaving = false;

  void _savePlace() async {
    if (!_formKey.currentState!.validate() ||
        _selectedImage == null ||
        _selectedLocation == null) {
      ScaffoldMessenger.of(context).clearSnackBars();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Add Location and/or Image'),
        ),
      );
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isSaving = true;
    });

    await ref.read(userPlacesProvider.notifier).addPlace(
        _locationTitle!, _selectedImage!, _selectedLocation!, uuid.v4());

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text('$_locationTitle Added.'),
      ),
    );

    return;
  }

  void _onReset() {
    _formKey.currentState!.reset();

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Place',
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 20) {
                    return 'Must be between 1 and 20 characters long';
                  }
                  return null;
                },
                onSaved: (value) {
                  _locationTitle = value!;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ImageInput(
                onPickImage: (image) => _selectedImage = image,
              ),
              const SizedBox(
                height: 16,
              ),
              LocationInput(
                onSelectLocation: (location) {
                  _selectedLocation = location;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  _savePlace();
                },
                child: _isSaving
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Add Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
