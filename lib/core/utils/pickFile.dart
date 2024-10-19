import 'dart:io';

import 'package:file_picker/file_picker.dart';


Future<File?> pickFile({required FileType type,required List<String> allowedExtensions}) async {
  try {
    final pickedFile = await FilePicker.platform
        .pickFiles(type: type, allowMultiple: false,allowedExtensions:allowedExtensions );
    if (pickedFile != null) {
      return File(pickedFile.files.single.path!);
    }
    return null;
  } catch (e) {
    return null;
  }
}