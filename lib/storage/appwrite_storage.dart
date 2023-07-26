import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:appwrite/models.dart';
import 'package:flutter_chat/constants/new_constants.dart';
import 'package:flutter_chat/new_provider/new_provider.dart';
import 'package:image_picker/image_picker.dart';

class dpStorage{
  static appwrite.Client client = appwrite.Client().setEndpoint(NewConstants.endPoint).setProject(NewConstants.projectId);
  static appwrite.Storage storage = appwrite.Storage(client);

  static Future<String> chooseImage(String src) async{
    ImagePicker picker = ImagePicker();
    if(src == 'camera'){
      XFile? image = await picker.pickImage(source: ImageSource.camera);
      if(image!.path.isNotEmpty){
        return image.path;
      }
      else{
        return '';
      }
    }
    if(src == 'gallery'){
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if(image!.path.isNotEmpty){
        return image.path;
      }
      else{
        return '';
      }
    }
    else{
      return '';
    }
  }

  static Future<File> uploadImage(String imagePath) async{
    try{
      final response = await storage.createFile(
          bucketId: NewConstants.userBucketID,
          fileId: ConnectUserProvider.userId,
          file: appwrite.InputFile(
              path: imagePath,
              filename: imagePath)
      );
      return response;
    } on appwrite.AppwriteException catch(e){
      print(e);
      rethrow;
    }
  }

  static Future<File> getImage(String userId) async{
    try{
      final doc = storage.getFile(
          bucketId: NewConstants.userBucketID,
          fileId: userId
      );
      return doc;
    }on appwrite.AppwriteException catch(e){
      print(e);
      rethrow;
    }
  }
}