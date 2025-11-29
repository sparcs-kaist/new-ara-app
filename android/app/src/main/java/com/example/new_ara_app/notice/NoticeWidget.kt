package com.example.new_ara_app.notice

import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.rememberCoroutineScope
import androidx.glance.GlanceId
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import com.example.new_ara_app.models.Post
import com.example.new_ara_app.networkings.PortalWidgetAPI
import com.example.new_ara_app.networkings.RetrofitInstance
import com.example.new_ara_app.networkings.readWidgetConfiguration
import com.example.new_ara_app.notice.components.MyContent
import kotlinx.coroutines.launch


class NoticeWidget : GlanceAppWidget() {
    @RequiresApi(Build.VERSION_CODES.O)
    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val widgetConfig = readWidgetConfiguration(context)
        val api = PortalWidgetAPI(RetrofitInstance.api, context)
        val posts = api.fetchPosts(widgetConfig)

        provideContent {
            MyContent(posts, context)
        }
    }
}