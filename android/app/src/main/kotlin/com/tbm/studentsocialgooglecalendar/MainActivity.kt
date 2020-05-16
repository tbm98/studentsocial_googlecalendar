package com.tbm.studentsocialgooglecalendar

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.provider.OpenableColumns
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.multidex.MultiDex
import com.tbm.studentsocialgooglecalendar.FileUtils.copyFileStream
import com.tbm.studentsocialgooglecalendar.FileUtils.getPath
import com.tbm.studentsocialgooglecalendar.MethodChannelHelper.CHANNEL
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File
import java.io.FileInputStream
import android.content.ContextWrapper
import android.content.IntentFilter
import java.security.cert.Extension


class MainActivity : FlutterActivity() {

    private lateinit var call: MethodCall
    private lateinit var result: MethodChannel.Result

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            this.call = call
            this.result = result
            if (allPermissionAccepted()) {
                runMethod()
            } else {
                requestPermisstion()
            }
        }
    }

    private fun runMethod() {
        if (call.method == "pickerFile") {
            browseClick()
        } else {
            result.notImplemented()
        }
    }

    private fun allPermissionAccepted(): Boolean {
        return (ContextCompat.checkSelfPermission(this,
                Manifest.permission.READ_EXTERNAL_STORAGE)
                == PackageManager.PERMISSION_GRANTED) && (ContextCompat.checkSelfPermission(this,
                Manifest.permission.WRITE_EXTERNAL_STORAGE)
                == PackageManager.PERMISSION_GRANTED)
    }

    private fun requestPermisstion() {
        // Permission is not granted
        // Should we show an explanation?
//        if (ActivityCompat.shouldShowRequestPermissionRationale(this,
//                        Manifest.permission.READ_CONTACTS)) {
        // Show an explanation to the user *asynchronously* -- don't block
        // this thread waiting for the user's response! After the user
        // sees the explanation, try again to request the permission.
//        } else {
        // No explanation needed, we can request the permission.
        ActivityCompat.requestPermissions(this,
                arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE),
                2)

        // MY_PERMISSIONS_REQUEST_READ_CONTACTS is an
        // app-defined int constant. The callback method gets the
        // result of the request.
//        }
    }

    override fun onRequestPermissionsResult(requestCode: Int,
                                            permissions: Array<String>, grantResults: IntArray) {
        when (requestCode) {
            2 -> {
                // If request is cancelled, the result arrays are empty.
                if ((grantResults.isNotEmpty()
                                && grantResults[0] == PackageManager.PERMISSION_GRANTED
                                && grantResults[1] == PackageManager.PERMISSION_GRANTED)) {
                    // permission was granted, yay! Do the
                    // contacts-related task you need to do.
                    runMethod()
                } else {
                    // permission denied, boo! Disable the
                    // functionality that depends on this permission.
                    requestPermisstion()
                }
                return
            }

            // Add other 'when' lines to check for other
            // permissions this app might request.
            else -> {
                // Ignore all other requests.
            }
        }
    }

    override fun attachBaseContext(newBase: Context?) {
        super.attachBaseContext(newBase)
        MultiDex.install(this)
    }

    private fun browseClick() {
        val intent = Intent(Intent.ACTION_GET_CONTENT)
        intent.type = "*/*"
        intent.addCategory(Intent.CATEGORY_OPENABLE)
        try {
            startActivityForResult(Intent.createChooser(intent, "Chọn file excel thời khoá biểu"), 1)
        } catch (ex: Exception) {
            println("browseClick :$ex") //android.content.ActivityNotFoundException ex
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        val fileName: String?


        if (requestCode == 1) {

            if (resultCode == RESULT_OK) {
                try {
                    val uri = data?.data
                    val mimeType = contentResolver.getType(uri!!)
                    if (mimeType == null) {
                        val path: String? = getPath(this, uri)
                        Log.e("URI", uri.toString())
                        if (path == null) { //filename = FilenameUtils.getName(uri.toString());
                            fileName = "null" //FilenameUtils.getName(uri.toString());
                        } else {
                            val file = File(path)
                            fileName = file.name
                        }
                    } else {
                        val returnUri = data.data
                        val returnCursor = contentResolver.query(returnUri!!, null, null, null, null)
                        val nameIndex = returnCursor?.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                        val sizeIndex = returnCursor?.getColumnIndex(OpenableColumns.SIZE)
                        returnCursor?.moveToFirst()
                        fileName = returnCursor?.getString(nameIndex!!)
                        val size = returnCursor?.getLong(sizeIndex!!).toString()
                    }
                    val fileSave = getExternalFilesDir(null)
                    val sourcePath = getExternalFilesDir(null)?.toString()
                    try {
                        copyFileStream(File("$sourcePath/$fileName"), uri, this)
                    } catch (e: java.lang.Exception) {
                        e.printStackTrace()
                    }
                    Log.e("PATH", sourcePath)


                    val file = File("$sourcePath/$fileName")
                    val stringResult = XLSReader.readExcelFile(FileInputStream(file))

                    result.success(stringResult)
                } catch (e: java.lang.Exception) {
                    e.printStackTrace()
                    result.error("UNAVAILABLE", "Pick file error.", null)
                }
            }
        }
    }

}
