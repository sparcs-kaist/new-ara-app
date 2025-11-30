package com.example.new_ara_app.notice

import android.content.Context
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.compose.runtime.collectAsState
import androidx.glance.GlanceId
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.provideContent
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import com.example.new_ara_app.PortalWidgetWorker
import com.example.new_ara_app.networkings.NoticeState
import com.example.new_ara_app.networkings.PortalWidgetAPI
import com.example.new_ara_app.networkings.createRetrofitWithCookie
import com.example.new_ara_app.networkings.readWidgetConfiguration
import com.example.new_ara_app.notice.components.MyContent

class PortalWidgetProvider : GlanceAppWidget() {
    override val sizeMode = SizeMode.Exact

    @RequiresApi(Build.VERSION_CODES.O)
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val config = readWidgetConfiguration(context)
        val flutterContext = context.createPackageContext(
            "org.sparcs.newara",
            Context.CONTEXT_IGNORE_SECURITY
        )
        val sharedPref = flutterContext.getSharedPreferences(
            "HomeWidgetPreferences",
            Context.MODE_PRIVATE
        )
        val cookie = sharedPref.getString("user_cookie", "")
        val apiWithCookie = createRetrofitWithCookie(cookie!!)
        val repository = PortalWidgetAPI(apiWithCookie, context)

        repository.fetchAndStorePosts(config)

        provideContent {
            MyContent(context)
        }
    }
}