package com.example.new_ara_app.helpers

import android.os.Build
import androidx.annotation.RequiresApi
import java.time.Instant
import java.util.Date

@RequiresApi(Build.VERSION_CODES.O)
fun String.toDate(): Date? {
    return runCatching {
        Date.from(Instant.parse(this))
    }.getOrNull()
}