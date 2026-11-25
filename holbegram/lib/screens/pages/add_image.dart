import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../methods/auth_methods.dart';
import '../../models/user.dart';
import '../home.dart';
import 'methods/post_storage.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() =>
      _AddImageState();
}

class _AddImageState
    extends State<AddImage> {
  Uint8List? _image;

  final TextEditingController
      captionController =
      TextEditingController();

  Future<void>
      selectImageFromGallery() async {
    final ImagePicker picker =
        ImagePicker();

    XFile? file =
        await picker.pickImage(
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

  Future<void>
      selectImageFromCamera() async {
    final ImagePicker picker =
        ImagePicker();

    XFile? file =
        await picker.pickImage(
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

  Future<void> postImage() async {
    if (_image == null) {
      return;
    }

    Users user =
        await AuthMethod()
            .getUserDetails();

    String res =
        await PostStorage()
            .uploadPost(
      captionController.text,
      user.uid,
      user.username,
      user.photoUrl,
      _image!,
    );

    if (!mounted) return;

    if (res == "Ok") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const Home(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(res),
        ),
      );
    }
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Post',
        ),
        actions: [
          TextButton(
            onPressed: postImage,
            child: const Text(
              'POST',
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.all(
            20,
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 90,
                backgroundImage:
                    _image != null
                        ? MemoryImage(
                            _image!,
                          )
                        : null,
                child:
                    _image == null
                        ? const Icon(
                            Icons
                                .add_a_photo,
                            size: 80,
                          )
                        : null,
              ),

              const SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                children: [
                  IconButton(
                    onPressed:
                        selectImageFromCamera,
                    icon:
                        const Icon(
                      Icons
                          .camera_alt,
                      size: 40,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  IconButton(
                    onPressed:
                        selectImageFromGallery,
                    icon:
                        const Icon(
                      Icons.photo,
                      size: 40,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              TextField(
                controller:
                    captionController,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Caption',
                  border:
                      OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}