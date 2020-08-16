package mobi.qrtag.tpay_flutter

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.tpay.android.library.web.TpayActivity
import com.tpay.android.library.web.TpayPayment


class TpayPaymentActivity : AppCompatActivity() {
    private var paymentBuilder: TpayPayment.Builder? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_payment_tpay)

        Log.d("TPAY_P", "OnCreate")
        paymentBuilder = if (savedInstanceState == null) {
            TpayPayment.Builder().setId("id")
                    .setAmount("123.20")
                    .setCrc("crc")
                    .setSecurityCode("kod_b")
                    .setDescription("Zakupy w Bar-a-boo")
                    .setClientEmail("email-klienta")
                    .setClientName("Imie i nazwisko")
        } else {
            savedInstanceState.getParcelable(TpayActivity.EXTRA_TPAY_PAYMENT)
                    ?: TpayPayment.Builder()
        }

        pay()
        Toast.makeText(this, "SIEMA", Toast.LENGTH_LONG).show()
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putParcelable(TpayActivity.EXTRA_TPAY_PAYMENT, paymentBuilder)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        when (requestCode) {
            TpayActivity.TPAY_PAYMENT_REQUEST ->
                if (resultCode == Activity.RESULT_OK) {
                    print("ok")
                } else {
                    print("error")
                }
            else ->
                super.onActivityResult(requestCode, resultCode, data)
        }
    }

    private fun pay() {
        val payIntent = Intent(this, TpayActivity::class.java)
        val tpayPayment = paymentBuilder?.create()
        payIntent.putExtra(TpayActivity.EXTRA_TPAY_PAYMENT, tpayPayment)

        startActivityForResult(payIntent, TpayActivity.TPAY_PAYMENT_REQUEST)
    }
}