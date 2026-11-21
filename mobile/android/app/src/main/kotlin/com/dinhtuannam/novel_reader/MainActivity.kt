package com.dinhtuannam.novel_reader

import android.content.Intent
import android.provider.Settings
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// AudioServiceActivity (thay cho FlutterActivity) để audio_service dùng chung
// Flutter engine với giao diện: vòng đọc to chạy tiếp khi tắt màn hình.
class MainActivity : AudioServiceActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "novel_reader/system")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openTtsSettings" -> result.success(openFirst(
                        Intent("com.android.settings.TTS_SETTINGS"),
                        Intent(Settings.ACTION_SETTINGS),
                    ))
                    "openBatterySettings" -> result.success(openFirst(
                        Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS),
                        Intent(Settings.ACTION_SETTINGS),
                    ))
                    else -> result.notImplemented()
                }
            }
    }

    private fun openFirst(vararg intents: Intent): Boolean {
        for (intent in intents) {
            try {
                startActivity(intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
                return true
            } catch (_: Exception) {
            }
        }
        return false
    }
}
