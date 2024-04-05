import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:ms_admin/widgets/category_dropdown_widget.dart';

class UploadMedWidget extends StatefulWidget {
  final String? pn; // Rendre pn optionnel en ajoutant le '?' après String
  const UploadMedWidget({Key? key, this.pn})
      : super(key: key); // Marquer pn comme étant facultatif
  @override
  State<UploadMedWidget> createState() => _UploadMedWidgetState();
}

class _UploadMedWidgetState extends State<UploadMedWidget> {
  late String? pn; // Déclaration de la variable pn

  @override
  void initState() {
    super.initState();
    pn = widget
        .pn; // Initialisation de la variable pn dans la méthode initState()
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic image;
  String? fileName;
  String? selectedCategory;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final TextEditingController _medName = TextEditingController();
  final TextEditingController _medPeremptionDate = TextEditingController();
  final TextEditingController _medPrice = TextEditingController();
  final TextEditingController _medDescription = TextEditingController();

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);

    if (result != null) {
      setState(() {
        image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  saveImageToStorage(dynamic image) async {
    Reference ref =
        _firebaseStorage.ref().child('MedicineImages').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  uploadToFirestore() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();
      String imageUrl = await saveImageToStorage(image);
      await _firebaseFirestore.collection('Medicines').doc(_medName.text).set({
        'category': selectedCategory,
        'pharmacyName': pn,
        'peremption': _medPeremptionDate.text,
        'price': _medPrice.text,
        'description': _medDescription.text,
        'image': imageUrl,
      }).whenComplete(() {
        EasyLoading.dismiss();
        setState(() {
          image = null;
          _formKey.currentState!.reset();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 1000,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Medicine Details',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Name*:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _medName,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter medicine name';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Enter medicine name',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Category*:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  CategoryDropdownWidget(
                                    onCategorySelected: _onCategorySelected,
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Peremption date*:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _medPeremptionDate,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter peremption date';
                                      }
                                      return null;
                                    },
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: 'Select peremption date',
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.calendar_today),
                                        onPressed: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2101),
                                          );
                                          if (pickedDate != null) {
                                            setState(() {
                                              _medPeremptionDate.text =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Price*:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _medPrice,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter medicine price';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Enter medicine price',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Description*:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _medDescription,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter medicine description';
                                      }
                                      return null;
                                    },
                                    maxLines: 4,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter medicine description',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: pickImage,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 250,
                                      height: 350,
                                      color: Colors.white,
                                      child: image == null
                                          ? const Icon(Icons.add_a_photo,
                                              size: 50)
                                          : Image.memory(image),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: TextButton(
                                onPressed: uploadToFirestore,
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  side: MaterialStateProperty.all(
                                    BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Flexible(
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    image = null;
                                    _formKey.currentState!.reset();
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  side: MaterialStateProperty.all(
                                    const BorderSide(color: Colors.red),
                                  ),
                                  overlayColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.hovered)) {
                                      return Colors.red.withOpacity(0.1);
                                    }
                                    return null;
                                  }),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        )
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
}
