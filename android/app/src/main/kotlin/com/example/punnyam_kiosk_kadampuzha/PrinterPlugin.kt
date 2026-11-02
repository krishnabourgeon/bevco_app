package com.example.punnyam_kiosk_kadampuzha

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Rect
import android.hardware.usb.UsbManager
import android.text.Layout
import android.text.StaticLayout
import android.text.TextPaint
import android.util.Log
import com.kioskworldline.com.PrintCmd
import com.kioskworldline.com.UsbDriver
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PrinterPlugin(
    private val context: Context
) : MethodChannel.MethodCallHandler {

    private var usbDriver: UsbDriver? = null

    // The printer only understands GB2312 (see PrintCmd.PrintString), which has
    // no Malayalam glyphs — those bytes come back as literal '?' on paper.
    // Malayalam lines are rendered to a bitmap using the system's default
    // typeface (Android's built-in font fallback handles Malayalam glyph
    // shaping reliably) and sent as an image so the printer's font ROM is
    // bypassed.

    init {
        usbDriver = UsbDriver(
            context.getSystemService(
                Context.USB_SERVICE
            ) as UsbManager,
            context
        )
    }

    private fun containsMalayalam(text: String): Boolean {
        return text.any { it.code in 0x0D00..0x0D7F }
    }

    private fun printLine(text: String, center: Boolean = false, textSize: Float = 24f) {
        if (text.isEmpty()) return
        if (containsMalayalam(text)) {
            printTextAsBitmap(text, center, textSize)
        } else {
            usbDriver?.write(PrintCmd.PrintString(text, 0))
        }
    }

    private fun printTextAsBitmap(text: String, center: Boolean = false, textSize: Float = 24f) {
        val paint = TextPaint(Paint.ANTI_ALIAS_FLAG).apply {
            color = Color.BLACK
            this.textSize = textSize
        }

        // Must match the printer's actual dot width (same width the 32-char
        // GB2312 text lines use elsewhere) - going wider makes the native
        // PrintBitmap() call silently fail, which falls back to GB2312 and
        // Malayalam stops printing.
        val maxLineWidthPx = 256
        val padding = 10

        // Text width excludes the padding on both sides so wrapped lines are
        // not clipped at the right edge, and centred text lands mid-bitmap.
        val layout = StaticLayout(
            text,
            paint,
            maxLineWidthPx - padding * 2,
            if (center) Layout.Alignment.ALIGN_CENTER else Layout.Alignment.ALIGN_NORMAL,
            1f,
            0f,
            false
        )

        val bitmapHeight = layout.height.coerceAtLeast(40) + padding * 2
        val bitmap = Bitmap.createBitmap(maxLineWidthPx, bitmapHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        canvas.drawColor(Color.WHITE)
        canvas.save()
        canvas.translate(padding.toFloat(), padding.toFloat())
        layout.draw(canvas)
        canvas.restore()

        val bytes = PrintCmd.PrintBitmap(bitmap)
        if (bytes != null) {
            usbDriver?.write(bytes)
        } else {
            Log.e(
                "PrinterPlugin",
                "PrintBitmap failed for \"$text\" (${bitmap.width}x${bitmap.height}); " +
                    "falling back to GB2312, Malayalam glyphs will not render"
            )
            // Fall back to the GB2312 path (renders as '?') rather than dropping the line silently.
            usbDriver?.write(PrintCmd.PrintString(text, 0))
        }
        bitmap.recycle()
    }

    // Prints the bill_image sent from Dart as encoded PNG/JPG bytes.
    private fun printImage(imageBytes: ByteArray?) {
        if (imageBytes == null || imageBytes.isEmpty()) {
            Log.w("PrinterPlugin", "No bill image received, printing receipt without it")
            return
        }

        val source = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
        if (source == null) {
            Log.e("PrinterPlugin", "Bill image could not be decoded (${imageBytes.size} bytes)")
            return
        }
        Log.d("PrinterPlugin", "Bill image decoded: ${source.width}x${source.height}")

        // Same 256-dot limit as printTextAsBitmap - wider images make the
        // native PrintBitmap() fail. Height keeps the aspect ratio.
        val printWidth = 256
        val printHeight = (source.height * printWidth.toFloat() / source.width)
            .toInt().coerceAtLeast(1)

        // Draw onto white so transparent PNG areas don't print as black.
        val bitmap = Bitmap.createBitmap(printWidth, printHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        canvas.drawColor(Color.WHITE)
        canvas.drawBitmap(
            source,
            null,
            Rect(0, 0, printWidth, printHeight),
            Paint(Paint.FILTER_BITMAP_FLAG)
        )
        source.recycle()

        val bytes = PrintCmd.PrintBitmap(bitmap)
        if (bytes != null) {
            val written = usbDriver?.write(bytes)
            Log.d(
                "PrinterPlugin",
                "Bill image sent to printer (${printWidth}x$printHeight, ${bytes.size} bytes, written=$written)"
            )
        } else {
            Log.e("PrinterPlugin", "PrintBitmap failed for bill image (${printWidth}x$printHeight)")
        }
        bitmap.recycle()
    }

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {

        when (call.method) {

            "connect" -> {

                val connected =
                    usbDriver?.openUsbDevice() ?: false

                result.success(connected)
            }

            "printText" -> {

                val text =
                    call.argument<String>("text") ?: ""

                usbDriver?.write(
                    PrintCmd.SetClean()
                )

                usbDriver?.write(
                    PrintCmd.PrintString(
                        text,
                        0
                    )
                )

                usbDriver?.write(
                    PrintCmd.PrintFeedline(2)
                )

                result.success(true)
            }

            "cutPaper" -> {

                usbDriver?.write(
                    PrintCmd.PrintCutpaper(0)
                )

                result.success(true)
            }

            "printReceipt" -> {
val temple =  call.argument<String>("temple") ?: ""
val templeAddress =  call.argument<String>("templeAddress") ?: ""
val templePlace =  call.argument<String>("templePlace") ?: ""
                val billNo =
                    call.argument<String>("billNo") ?: ""

                val date =
                    call.argument<String>("date") ?: ""

                val mode =
                    call.argument<String>("mode") ?: ""

                val total =
                    call.argument<String>("total") ?: ""

                val website =
                    call.argument<String>("website") ?: ""
                val billImage =
                    call.argument<ByteArray>("billImage")
                val items =call.argument<List<Map<String, Any?>>>("items")
        ?: emptyList()

                printReceipt(
                    temple,
                    templeAddress,
                    templePlace,
                    billNo,
                    date,
                    mode,
                    total,
                    website,
                    billImage,
                    items
                )

                result.success(true)
            }

            else -> result.notImplemented()
        }
    }

    // Characters per line in the normal 12x24 font. 48 fits 80mm paper
    // (576 dots); use 32 for 58mm paper.
    private val lineChars = 48

    private fun divider() = printLine("-".repeat(lineChars))

    private fun printTwoColumn(
        left: String,
        right: String
    ) {
        val spaces = (lineChars - left.length - right.length).coerceAtLeast(1)
        printLine(left + " ".repeat(spaces) + right)
    }

    // Same as printTwoColumn, with the left text in bold.
    private fun printTwoColumnBoldLeft(left: String, right: String) {
        val spaces = (lineChars - left.length - right.length).coerceAtLeast(1)
        usbDriver?.write(PrintCmd.SetBold(1))
        usbDriver?.write(PrintCmd.PrintString(left, 1))
        usbDriver?.write(PrintCmd.SetBold(0))
        usbDriver?.write(PrintCmd.PrintString(" ".repeat(spaces) + right, 0))
    }

    // Address fields from the API contain \r\n line breaks and stray spaces;
    // print each part on its own centred line.
    private fun printCentredLines(text: String) {
        text.split("\r\n", "\n", "\r")
            .map { it.trim() }
            .filter { it.isNotEmpty() }
            .forEach { printLine(it, center = true) }
    }

    // 240.0 -> "240", 12.5 -> "12.50"
    private fun formatAmount(value: Any?): String {
        val number = value?.toString()?.toDoubleOrNull() ?: return value?.toString() ?: ""
        return if (number % 1.0 == 0.0) number.toLong().toString() else String.format("%.2f", number)
    }

    // Total always shows two decimals: 2370 -> "2370.00"
    private fun formatTotal(value: Any?): String {
        val number = value?.toString()?.toDoubleOrNull() ?: return value?.toString() ?: ""
        return String.format(java.util.Locale.US, "%.2f", number)
    }

    private fun printReceipt(
        temple: String,
        templeAddress: String,
        templePlace: String,
        billNo: String,
        date: String,
        mode: String,
        total: String,
        website: String,
        billImage: ByteArray?,
        items: List<Map<String, Any?>>
    ) {

        usbDriver?.write(PrintCmd.SetClean())

        // Logo and temple header are centred; everything below is left-aligned.
        usbDriver?.write(PrintCmd.SetAlignment(1))

        printImage(billImage)

        // Temple name in the smaller font: 9x17 printer font for English,
        // 20px for Malayalam (drawn as a bitmap, so the printer font doesn't apply).
        usbDriver?.write(PrintCmd.SetSizechar(0, 0, 0, 1))
        printLine(temple.trim().uppercase(), center = true, textSize = 20f)
        usbDriver?.write(PrintCmd.SetSizechar(0, 0, 0, 0))
        printCentredLines(templeAddress)
        printCentredLines(templePlace)

        usbDriver?.write(PrintCmd.SetAlignment(0))

        usbDriver?.write(PrintCmd.PrintFeedline(1))

        // Bill No / Date labels, then the values below them; bill number in bold.
        printTwoColumn("Bill No", "Date")
        printTwoColumnBoldLeft(billNo, date)

        divider()

        for (item in items) {
            val product = item["pooja"]?.toString() ?: ""
            val qty = item["qty"]?.toString() ?: ""
            val rate = formatAmount(item["rate"])
            val amount = formatAmount(item["amount"])

            // Product name on its own line, then quantity x rate and the line amount.
            printLine(product)
            printTwoColumn("$qty x $rate", amount)

            usbDriver?.write(PrintCmd.PrintFeedline(1))
        }

        divider()

        printTwoColumn(
            "Mode: $mode",
            "Total: Rs.${formatTotal(total)}"
        )

        usbDriver?.write(PrintCmd.PrintFeedline(4))

        usbDriver?.write(PrintCmd.PrintCutpaper(0))
    }

}
