import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kiosk/services/app_config.dart';

class PrinterService {
  static const MethodChannel _channel = MethodChannel('masung_printer');

  static Future<bool> connect() async {
    return await _channel.invokeMethod('connect');
  }

  static Future<void> printText(String text) async {
    await _channel.invokeMethod('printText', {'text': text});
  }

  static Future<void> cutPaper() async {
    await _channel.invokeMethod('cutPaper');
  }

  static Future<void> printReceipt({
    String? temple,
    String? templeAddress,
    String? templePlace,
    int? id,
    String? today,
    String? mode,
    String? total,
    String? website,
    String? billImage,
    List<Map<String, dynamic>>? items,
  }) async {
    await _channel.invokeMethod('printReceipt', {
      'temple': temple,
      'templeAddress': templeAddress,
      'templePlace': templePlace,
      'billNo': id.toString(),
      'date': today,
      'mode': mode,
      'total': total,
      'website': website,
      'billImage': await _loadImageBytes(billImage),
      'items': items,
    });
  }

  // bill_image from the API can be a full URL, a path relative to the
  // server's public folder, or base64 (with or without a data: prefix).
  // The image is fetched here because Android blocks network calls on the
  // main thread the plugin runs on. Any failure returns null so the receipt
  // still prints without the image.
  static Future<Uint8List?> _loadImageBytes(String? image) async {
    if (image == null || image.trim().isEmpty) return null;
    final value = image.trim();
    try {
      if (value.startsWith('data:')) {
        return base64Decode(value.substring(value.indexOf(',') + 1));
      }
      if (value.startsWith('http://') || value.startsWith('https://')) {
        return await _download(Uri.parse(value));
      }
      if (value.contains('/') || value.contains('.')) {
        final path = value.startsWith('/') ? value.substring(1) : value;
        return await _download(Uri.parse(AppConfig.baseUrl).resolve('../$path'));
      }
      return base64Decode(value);
    } catch (e) {
      debugPrint("Bill image load failed: $e");
      return null;
    }
  }

  static Future<Uint8List?> _download(Uri uri) async {
    final response = await http.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      debugPrint("Bill image download failed (${response.statusCode}): $uri");
      return null;
    }
    return response.bodyBytes;
  }
}
