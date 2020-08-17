package mobi.qrtag.tpay_flutter

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull
import com.tpay.android.library.web.TpayActivity
import com.tpay.android.library.web.TpayPayment
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar

/** TpayFlutterPlugin */
class TpayFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var tpayResult: Result? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tpay_flutter")
        channel.setMethodCallHandler(this)
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "tpay_flutter")
            channel.setMethodCallHandler(TpayFlutterPlugin())
            val instance = TpayFlutterPlugin()
            registrar.addActivityResultListener(instance)
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "requestPayment" -> {
                tpayResult = result
                activity?.let { requestPaymentActivity(it, call) }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    private fun requestPaymentActivity(activity: Activity, call: MethodCall) {
       val paymentBuilder = TpayPayment.Builder().setId(call.argument("id"))
                .setAmount(call.argument("amount"))
                .setCrc(call.argument("crc"))
                .setSecurityCode(call.argument("securityCode"))
                .setDescription(call.argument("description"))
                .setClientEmail(call.argument("clientEmail"))
                .setClientName(call.argument("clientName"))

        val payIntent = Intent(activity, TpayActivity::class.java)
        val tpayPayment = paymentBuilder?.create()
        payIntent.putExtra(TpayActivity.EXTRA_TPAY_PAYMENT, tpayPayment)

        activity.startActivityForResult(payIntent, TpayActivity.TPAY_PAYMENT_REQUEST)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        return when (requestCode) {
            TpayActivity.TPAY_PAYMENT_REQUEST ->
                if (resultCode == Activity.RESULT_OK) {
                    tpayResult?.success(1);
                    true
                } else {
                    tpayResult?.success(0)
                    true
                }
            else ->
                false
        }
    }
}