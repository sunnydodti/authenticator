import 'dart:io';

class PlatformHelper {
  static get isCameraSupported => (Platform.isAndroid || Platform.isIOS);
}
