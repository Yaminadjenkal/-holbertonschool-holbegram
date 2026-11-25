import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;

  Future<void> selectImageFromGallery() async {
    final ImagePicker picker = ImagePicker();

    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (file != null) {
      Uint8List imageBytes =
          await file.readAsBytes();

      setState(() {
        _image = imageBytes;
      });
    }
  }

  Future<void> selectImageFromCamera() async {
    final ImagePicker picker = ImagePicker();

    XFile? file = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (file != null) {
      Uint8List imageBytes =
          await file.readAsBytes();

      setState(() {
        _image = imageBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Picture',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: _image != null
                  ? MemoryImage(_image!)
                  : null,
              child: _image == null
                  ? const Icon(
                      Icons.person,
                      size: 80,
                    )
                  : null,
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed:
                      selectImageFromCamera,
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 40,
                  ),
                ),

                const SizedBox(width: 30),

                IconButton(
                  onPressed:
                      selectImageFromGallery,
                  icon: const Icon(
                    Icons.photo,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}