package br.com.pontopj

import android.content.ActivityNotFoundException
import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * Abre a planilha gerada em outro app para conferência (RF-37). O arquivo fica na área
 * privada do app e é exposto só pelo FileProvider declarado no manifesto.
 */
class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "ponto_pj/arquivos")
            .setMethodCallHandler { chamada, resultado ->
                if (chamada.method != "abrir") {
                    resultado.notImplemented()
                    return@setMethodCallHandler
                }
                val caminho = chamada.argument<String>("caminho")
                val tipo = chamada.argument<String>("tipo") ?: "*/*"
                if (caminho == null) {
                    resultado.error("argumento", "Caminho ausente", null)
                    return@setMethodCallHandler
                }
                try {
                    val uri = FileProvider.getUriForFile(this, "$packageName.fileprovider", File(caminho))
                    val intencao = Intent(Intent.ACTION_VIEW).apply {
                        setDataAndType(uri, tipo)
                        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    }
                    startActivity(intencao)
                    resultado.success(true)
                } catch (erro: ActivityNotFoundException) {
                    resultado.error("sem_app", erro.message, null)
                } catch (erro: IllegalArgumentException) {
                    resultado.error("caminho_invalido", erro.message, null)
                }
            }
    }
}
