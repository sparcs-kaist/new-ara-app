package com.example.new_ara_app.notice.components

import android.content.Context
import android.content.Intent
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.graphics.Color
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
import com.example.new_ara_app.models.BoardType
import com.example.new_ara_app.R
import com.example.new_ara_app.setting.SettingActivity
import com.example.new_ara_app.setting.WidgetSettings
import io.flutter.embedding.android.FlutterActivity


@Composable
fun MyContent(context: Context) {

    val clickAction = actionStartActivity<FlutterActivity>()
    val size = LocalSize.current

    val showCount = when {
        size.height < 150.dp -> 3
        size.height > 150.dp -> 5
        else -> 5
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

    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(ColorProvider(Color.White))
            .padding(16.dp)
            .clickable(clickAction),
        verticalAlignment = Alignment.Top,
        horizontalAlignment = Alignment.Start
    ) {
        // Header
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
                text = "포탈 공지",
                style = TextStyle(
                    fontSize = 16.sp,
                    fontWeight = FontWeight.Bold,
                    color = ColorProvider(Color(0xFFE45A4E))
                ),
            )

            Spacer(GlanceModifier.defaultWeight())

            Image(
                provider = ImageProvider(R.drawable.round_settings_24),
                contentDescription = "setting icon",
                colorFilter = ColorFilter.tint(ColorProvider(Color(0xFFE45A4E))),
                modifier = GlanceModifier
                    .size(20.dp)
                    .clickable(openSettings)
            )
        }

        Spacer(modifier = GlanceModifier.height(8.dp))

        repeat(showCount) {
            NoticeRow(
                title = "< 공지 > 캠퍼스 내 실내소독 작업 안내 (어쩌구저쩌구 대충 엄청 긴 제목",
                subtitle = "인기 급상승",
                author = "시설팀",
                board = BoardType.TRENDING,
                onClick = clickAction
            )
        }
    }
}


//Button(
//                text = "Home",
//                onClick = actionStartActivity<FlutterActivity>()
//            )

@OptIn(ExperimentalGlancePreviewApi::class)
@Preview
@Composable
private fun Preview() {
    MyContent(LocalContext.current)
}

