import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_config.dart';

final clientInfoPageEnabledProvider = Provider<bool>(
  (ref) => AppConfig.enableInfoPage,
);
