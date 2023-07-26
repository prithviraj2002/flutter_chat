import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:appwrite/models.dart';
import 'package:flutter_chat/constants/new_constants.dart';
import 'package:image_picker/image_picker.dart';

class dpStorage{
  static appwrite.Client client = appwrite.Client().setEndpoint(NewConstants.endPoint).setProject(NewConstants.projectId);
  static appwrite.Storage storage = appwrite.Storage(client);

  static pickCameraImage() async{
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    if(image.toString().isNotEmpty){
      return image;
    }
    else{
      return '';
    }
  }

  static pickGalleryImage() async{
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image.toString().isNotEmpty){
      return image;
    }
    else{
      return '';
    }
  }

  static Future<File> uploadImage(String imagePath) async{
    try{
      final response = await storage.createFile(
          bucketId: NewConstants.userBucketID,
          fileId: DateTime.now().toString(),
          file: appwrite.InputFile.fromPath(path: '$imagePath./path-to-files/image.jpg', filename: 'image.jpg')
      );
      return response;
    } on appwrite.AppwriteException catch(e){
      print(e);
      rethrow;
    }
  }
}