import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

abstract class StorageService {
  Future<void> init();

  Future<void> remove(String key);

  dynamic get(String key);

  dynamic getAll();

  Future<void> clear();

  bool has(String key);

  Future<void> set(String? key, dynamic data);

  Future<void> close();
}

class HiveService extends StorageService {
  late Box hiveBox;
  static final HiveService _instance = HiveService._internal();
  HiveService._internal();

  factory HiveService() => _instance;
  Future<void> openBox([String boxName = 'imagecreator']) async {
    final path = await getApplicationDocumentsDirectory();
    hiveBox = await Hive.openBox(boxName, path: path.path);
  }

  @override
  Future<void> init() async {
    await openBox();
  }

  @override
  Future<void> remove(String key) async {
    hiveBox.delete(key);
  }

  @override
  dynamic get(String key) {
    return hiveBox.get(key);
  }

  @override
  dynamic getAll() {
    return hiveBox.values.toList();
  }

  @override
  bool has(String key) {
    return hiveBox.containsKey(key);
  }

  @override
  Future<void> set(String? key, dynamic data) async {
    hiveBox.put(key, data);
  }

  @override
  Future<void> clear() async {
    await hiveBox.clear();
  }

  @override
  Future<void> close() async {
    await hiveBox.close();
  }
}