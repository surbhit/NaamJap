import 'dart:typed_data';

import 'image_download_stub.dart'
    if (dart.library.html) 'image_download_web.dart'
    as impl;

void downloadPng(Uint8List bytes, String filename) {
  impl.downloadPng(bytes, filename);
}
