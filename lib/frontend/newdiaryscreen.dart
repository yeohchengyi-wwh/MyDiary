import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mydiary/frontend/homepage.dart';
import 'package:mydiary/models/mydairy.dart';
import 'package:mydiary/databasehelper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class NewDariy extends StatefulWidget {
  const NewDariy({super.key});

  @override
  State<NewDariy> createState() => _NewDariyState();
}

class _NewDariyState extends State<NewDariy> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DateFormat formatter = DateFormat('dd MMM yyyy, h:mm a');
  String diaryTitles = "", diaryNotes = "";
  File? image;

  Color priColor = const Color.fromARGB(255, 116, 144, 227);
  Color secColor = const Color.fromARGB(255, 245, 178, 107);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: priColor,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "New Diary",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(25, 30, 25, 30),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: openCameraGalleryDialog,
                          child: Container(
                            height: 220,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F4F7),
                              borderRadius: BorderRadius.circular(20),
                              image: image != null
                                  ? DecorationImage(
                                      image: FileImage(image!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              boxShadow: image != null
                                  ? [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: image == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black,
                                              blurRadius: 10,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.add_a_photo_rounded,
                                          size: 35,
                                          color: priColor,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "Add a cover photo",
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(
                                    alignment: Alignment.topRight,
                                    padding: const EdgeInsets.all(10),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black54,
                                      radius: 18,
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: priColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 14,
                                color: priColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                formatter.format(DateTime.now()),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        //Title TextFormField
                        TextFormField(
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                              child: Icon(
                                Icons.edit,
                                color: const Color.fromARGB(255, 41, 11, 61),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: secColor,
                                width: 3,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color:secColor,
                                width: 3,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: const Color.fromARGB(255, 173, 47, 38),
                                width: 3,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: const Color.fromARGB(255, 173, 47, 38),
                                width: 3,
                              ),
                            ),
                            hintText: 'Write down the title',
                            labelText: 'Title',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            helperText: "",
                            helperStyle: TextStyle(fontSize: 17),
                            errorStyle: TextStyle(fontSize: 17),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please fill in the title";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            diaryTitles = value!;
                          },
                        ),

                        TextFormField(
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          maxLines: 2,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                              child: Icon(
                                Icons.description,
                                color: const Color.fromARGB(255, 41, 11, 61),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color:secColor,
                                width: 3,
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: secColor,
                                width: 3,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: const Color.fromARGB(255, 173, 47, 38),
                                width: 3,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: const Color.fromARGB(255, 173, 47, 38),
                                width: 3,
                              ),
                            ),
                            hintText: 'Write down the descriptions',
                            labelText: 'Diary Descriptions',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            helperText: "",
                            helperStyle: TextStyle(fontSize: 17),
                            errorStyle: TextStyle(fontSize: 17),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please fill in Diary text";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            diaryNotes = value!;
                          },
                        ),

                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: validateCheck,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: priColor,
                              foregroundColor: Colors.white,
                              elevation: 5,
                              shadowColor: priColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Save Diary',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void validateCheck() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            backgroundColor: Colors.white,
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: priColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.save_rounded, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Save Entry',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Do you want to save this memory to your diary?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: addNewDiary,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: priColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> addNewDiary() async {
    String date = formatter.format(DateTime.now());
    Directory appDir = await getApplicationDocumentsDirectory();
    String storedImagePath =
        ""; // Changed default to empty string for cleaner logic

    if (image != null) {
      String imageName = "${DateTime.now().millisecondsSinceEpoch}.png";
      storedImagePath = "${appDir.path}/$imageName";
      await image!.copy(storedImagePath);
    }
    await DatabaseHelper().insertMyDiary(
      MyDiary(0, diaryTitles, diaryNotes, date, storedImagePath),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Diary saved successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  void openCameraGalleryDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add Image",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // CAMERA
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      openCamera();
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Color.fromARGB(255, 116, 144, 227),
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Camera",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // GALLERY
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      openGallery();
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.photo,
                            color: Color.fromARGB(255, 116, 144, 227),
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Gallery",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),
            ],
          ),
        );
      },
    );
  }

  Future<void> openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    

    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    setState(() {});
  }

  Future<void> openGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false, 
      imageQuality: 90,
    );

    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    setState(() {});
  }
}
