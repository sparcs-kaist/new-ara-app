package com.example.new_ara_app.notice

import android.appwidget.AppWidgetManager
import android.content.Context
import android.os.Bundle
import android.util.SizeF
import android.widget.RemoteViews
import androidx.compose.runtime.collectAsState
import androidx.datastore.preferences.core.emptyPreferences
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.glance.GlanceId
import androidx.glance.LocalSize
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.provideContent
import androidx.glance.currentState
import com.example.new_ara_app.KEY_WIDGET_DATA
import com.example.new_ara_app.notice.components.MyContent
import com.example.new_ara_app.setting.dataStore
import java.util.prefs.Preferences

class NoticeWidget : GlanceAppWidget() {
    override val sizeMode = SizeMode.Exact

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            val size = LocalSize.current
            val prefs = context.dataStore.data.collectAsState(initial = emptyPreferences()).value

            val data = prefs[KEY_WIDGET_DATA] ?: "데이터 없음"


            MyContent(context, size, data)
        }
    }
}
