package com.example.new_ara_app.notice.components

import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.content.Intent
import android.util.Log
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.key
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.DpSize
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.ColorFilter
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.LocalContext
import androidx.glance.LocalSize
import androidx.glance.action.actionStartActivity
import androidx.glance.action.clickable
import androidx.glance.appwidget.action.actionStartActivity
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.layout.width
import androidx.glance.preview.ExperimentalGlancePreviewApi
import androidx.glance.preview.Preview
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import androidx.work.WorkerParameters
import com.example.new_ara_app.KEY_WIDGET_DATA
import com.example.new_ara_app.R
import com.example.new_ara_app.WidgetApiWorker
import com.example.new_ara_app.models.DisplayReason
import com.example.new_ara_app.setting.SettingActivity
import com.example.new_ara_app.setting.WidgetSettings
import com.example.new_ara_app.setting.dataStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.KeyData
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch


@Composable
fun MyContent(context: Context, size: DpSize, data: String) {

    var widgetData by remember { mutableStateOf("불러오는 중...") }
    val scope = rememberCoroutineScope()
    LaunchedEffect(Unit) {

        scope.launch {
            val prefs = context.dataStore.data.first()
            widgetData = prefs[KEY_WIDGET_DATA] ?: "No data yet"
        }
    }

    Log.d("Asasd", widgetData)

    val clickAction = actionStartActivity<FlutterActivity>()

    val showCount = when {
        size.height.value < 250 -> 3
        size.height.value < 400 -> 5
        size.height.value < 500 -> 7
        else -> 9
    }

    var keywords by remember { mutableStateOf(emptySet<String>()) }
    var showTrending by remember { mutableStateOf(true) }
    var boards by remember { mutableStateOf(setOf("TRENDING")) }
    val openSettings = actionStartActivity(Intent(context, SettingActivity::class.java))

    LaunchedEffect(Unit) {
        WidgetSettings.getKeywords(context).collect { keywords = it }
        WidgetSettings.getShowTrending(context).collect { showTrending = it }
        WidgetSettings.getBoards(context).collect { boards = it }
    }

    androidx.glance.appwidget.lazy.LazyColumn(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(ColorProvider(Color.White))
            .padding(16.dp)
            .clickable(clickAction),
        horizontalAlignment = Alignment.Start
    ) {
        item {
            Row(
                modifier = GlanceModifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Image(
                    provider = ImageProvider(R.drawable.rounded_inbox_text_24),
                    contentDescription = "portal icon",
                    colorFilter = ColorFilter.tint(ColorProvider(Color(0xFFE45A4E))),
                    modifier = GlanceModifier.size(20.dp)
                )

                Spacer(modifier = GlanceModifier.width(8.dp))

                Text(
                    text = context.getString(R.string.appwidget_text),
                    style = TextStyle(
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold,
                        color = ColorProvider(Color(0xFFE45A4E))
                    ),
                )

                Spacer(GlanceModifier.defaultWeight())

                Image(
                    provider = ImageProvider(R.drawable.round_settings_24),
                    contentDescription = context.getString(R.string.setting_icon),
                    colorFilter = ColorFilter.tint(ColorProvider(Color(0xFFE45A4E))),
                    modifier = GlanceModifier
                        .size(20.dp)
                        .clickable(openSettings)
                )
            }
        }
        item { Spacer(modifier = GlanceModifier.height(8.dp)) }

        repeat(showCount) {
            item {
                NoticeRow(
                    title = "< 공지 > 캠퍼스 내 실내소독 작업 안내 $data",
                    subtitle = "인기 급상승",
                    author = "시설팀",
                    board = DisplayReason.Trending,
                    onClick = clickAction
                )
            }
        }
    }
}

@Composable
private fun EmptyView(context: Context){
    val openSettings = actionStartActivity(Intent(context, SettingActivity::class.java))

    val cachedKeywords = context.getSharedPreferences("widget_prefs", MODE_PRIVATE)
        .getStringSet("keywords", emptySet()) ?: emptySet()
    val keywords = remember { cachedKeywords }

    Column {
        Row(
            modifier = GlanceModifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Image(
                provider = ImageProvider(R.drawable.rounded_inbox_text_24),
                contentDescription = "portal icon",
                colorFilter = ColorFilter.tint(ColorProvider(Color(0xFFE45A4E))),
                modifier = GlanceModifier.size(20.dp)
            )

            Spacer(modifier = GlanceModifier.width(8.dp))

            Text(
                text = context.getString(R.string.appwidget_text),
                style = TextStyle(
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold,
                    color = ColorProvider(Color(0xFFE45A4E))
                ),
            )

            Spacer(GlanceModifier.defaultWeight())

            Image(
                provider = ImageProvider(R.drawable.round_settings_24),
                contentDescription = context.getString(R.string.setting_icon),
                colorFilter = ColorFilter.tint(ColorProvider(Color(0xFFE45A4E))),
                modifier = GlanceModifier
                    .size(20.dp)
                    .clickable(openSettings)
            )
        }
        Row(verticalAlignment = Alignment.CenterVertically) {
            WidgetSettings.getKeywords(context)
            Image(
                provider = ImageProvider(R.drawable.baseline_browser_not_supported_24),
                contentDescription = "Board icon",
                colorFilter = ColorFilter.tint(ColorProvider(Color.LightGray))
            )
            Text(text = if(keywords.isNotEmpty()) "$${keywords} 결과 없음" else "결과 없음")
        }
    }
}

@OptIn(ExperimentalGlancePreviewApi::class)
@Preview
@Composable
private fun Preview() {
    MyContent(LocalContext.current, LocalSize.current, "")
}

