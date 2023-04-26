import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sms/Screens/home/assigments/add_class.dart';
import 'package:sms/Screens/styles/font.dart';
import 'package:sms/Screens/widgets/spacer.dart';

// final storageRef = FirebaseStorage.instance.ref();
// final mountainsRef = storageRef.child("mountains.jpg");

class AssignmentFolder extends StatefulWidget {
  const AssignmentFolder({Key? key}) : super(key: key);

  @override
  AssignmentFolderState createState() => AssignmentFolderState();
}

class AssignmentFolderState extends State<AssignmentFolder> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> pdfData = [];
  List<String> className = [];
  int index = 0;

  Future<String?> uploadPdf(String fileName, File file) async {
    final reference =
    FirebaseStorage.instance.ref().child("assignments/$fileName.pdf");
    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {});
    final downloadLink = await reference.getDownloadURL();
    await _firebaseFirestore.collection("Assignments/$className").add({
      "name": fileName,
      "url": downloadLink,
    });
    return null;
  }

  FilePickerResult? result;
  PlatformFile? pickedfile;
  bool isLoading = false;
  File? fileToDisplay;

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      String fileName = result.files[0].name;
      File file = File(result.files[0].path!);
      uploadPdf(fileName, file);
    }
  }

  Future getAllPdf() async {
    final results = await _firebaseFirestore.collection("Assignments/$className").get();
    pdfData = results.docs.map((e) => e.data()).toList();
    setState(() {});
  }

  @override
  void initState() {
    getAllPdf();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assignment Upload"),
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //       bottomRight: Radius.circular(50),
        //       bottomLeft: Radius.circular(50)),
        // ),
        elevation: 0.00,
        backgroundColor: const Color.fromARGB(255, 114, 203, 245),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: (){
                return getAllPdf();
              },
              child: GridView.builder(
                  itemCount: className.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return AddClass(icon: Icons.folder_copy_outlined, heading: className[index]);
                    //  AssignmentCard(icon: Icons.picture_as_pdf_outlined, url: pdfData[index]['url'], heading: pdfData[index]['name'],)
                  }),
            ),
          ),
          const Divider(
            height: 5,
            thickness: 1,
          ),
          const Space(
            height: 20,
          ),
          Center(
            child: Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
              ),
              child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      index ++;
                      className.add('Class IV');
                    });
                  },
                  child: Text(
                    'Add Class',
                    style:
                    ThemeFontStyle(fontSize: 16, color: Colors.blue).style,
                  )),
            ),
          ),
          const Space(
            height: 20,
          ),
        ],
      ),
    );
  }
}
