import 'package:get_storage/get_storage.dart';
import '../views/utils/storageKeys.dart';

class StorageService{
  static final session = GetStorage();

  static dynamic userSession = session.read(StorageKeys.userSession);
}