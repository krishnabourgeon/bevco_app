package com.example.punnyam_kiosk_kadampuzha

import android.media.AudioManager
import android.media.ToneGenerator
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    // Created once and reused so a beep starts instantly (no file to load).
    private var toneGenerator: ToneGenerator? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        toneGenerator = try {
            ToneGenerator(AudioManager.STREAM_MUSIC, ToneGenerator.MAX_VOLUME)
        } catch (e: RuntimeException) {
            null
        }

        // Masung thermal printer, used by PrinterService in lib/print_service.dart.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "masung_printer")
            .setMethodCallHandler(PrinterPlugin(this))

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "punnyam_kiosk_kadampuzha/beep")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    // Short high-pitched beep, like a checkout scanner.
                    "success" -> toneGenerator?.startTone(ToneGenerator.TONE_PROP_BEEP, 120)
                    // Low double tone for an unknown barcode.
                    "error" -> toneGenerator?.startTone(ToneGenerator.TONE_PROP_NACK, 300)
                    else -> {
                        result.notImplemented()
                        return@setMethodCallHandler
                    }
                }
                result.success(null)
            }
    }

    override fun onDestroy() {
        toneGenerator?.release()
        toneGenerator = null
        super.onDestroy()
    }
}

