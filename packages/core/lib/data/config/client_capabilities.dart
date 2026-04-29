import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_config.dart';

final infoPageEnabledProvider = Provider<bool>(
  (ref) => AppConfig.enableInfoPage,
);

