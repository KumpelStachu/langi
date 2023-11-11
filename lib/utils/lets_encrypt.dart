import 'dart:io';

import 'package:flutter/services.dart';

Future<void> patchLetsEncrypt() async {
  try {
    final ca = await PlatformAssetBundle().load('assets/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(ca.buffer.asUint8List());
  } catch (e) {
    // ignore
  }
}
