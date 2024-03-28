import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ms_admin/widgets/banner_list_widget.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({Key? key}) : super(key: key);

  static const String routeName = '/BannerScreen';

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic image;
  String? fileName;
  bool imageIsNull = false;

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);

    if (result != null) {
      setState(() {
        image = result.files.first.bytes;
        fileName = result.files.first.name;
        imageIsNull = false; // Reset imageIsNull state
      });
    }
  }

  saveImageToStorage(dynamic image) async {
    Reference ref =
        _firebaseStorage.ref().child('BannerImages').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  uploadToFirestore() async {
    if (_formKey.currentState!.validate()) {
      if (image == null) {
        setState(() {
          imageIsNull = true; // Set imageIsNull state to true
        });
        return;
      }

      EasyLoading.show();
      String imageUrl = await saveImageToStorage(image);
      await _firebaseFirestore.collection('Banners').doc(fileName).set({
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Upload Banners',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
            ),
            const Divider(color: Colors.grey),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color:
                                imageIsNull ? Colors.red : Colors.grey.shade800,
                          ),
                        ),
                        child: Center(
                          child: image == null
                              ? Text(
                                  imageIsNull
                                      ? 'Banner Required'
                                      : 'Banner Image',
                                  style: const TextStyle(color: Colors.red),
                                )
                              : Image.memory(image),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: pickImage,
                        child: const Text('Upload Image'),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: TextButton(
                      onPressed: uploadToFirestore,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.all(
                          BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(color: Theme.of(context).primaryColor),
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
                        backgroundColor: MaterialStateProperty.all(
                          Colors.white,
                        ),
                        side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.red),
                        ),
                        overlayColor: MaterialStateProperty.resolveWith(
                          (states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.red.withOpacity(0.1);
                            }
                            return null;
                          },
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey),
            const BannerWidget(),
          ],
        ),
      ),
    );
  }
}
