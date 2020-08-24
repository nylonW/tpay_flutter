package mobi.qrtag.tpay_flutter

import android.os.Bundle
import android.view.View
import androidx.appcompat.widget.Toolbar
import com.tpay.android.library.web.TpayActivity

class CustomTpayActivity: TpayActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val toolBar = findViewById<Toolbar>(R.id.tPayToolbar)
        toolBar.visibility = View.GONE
    }
}