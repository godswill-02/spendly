import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late final GetStorage _box;
  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  static const currencyKey = 'currency';
  static const firstDayOfWeekKey = 'first_day_of_week';
  static const themeModeKey = 'theme_mode';
  static const languageKey = 'language_code';
  static const ratesKey = 'fx_rates';

  T? read<T>(String key) => _box.read<T>(key);
  Future<void> write(String key, dynamic value) => _box.write(key, value);
  Future<void> remove(String key) => _box.remove(key);
}