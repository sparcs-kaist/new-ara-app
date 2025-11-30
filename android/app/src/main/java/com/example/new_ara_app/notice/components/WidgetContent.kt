package com.example.new_ara_app.notice.components

import android.content.Context
import android.content.Intent
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.net.toUri
import androidx.glance.ColorFilter
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.LocalContext
import androidx.glance.LocalSize
import androidx.glance.action.actionStartActivity
import androidx.glance.action.clickable
import androidx.glance.appwidget.action.actionStartActivity
import androidx.glance.appwidget.lazy.LazyColumn
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
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
import com.example.new_ara_app.MainActivity
import com.example.new_ara_app.R
import com.example.new_ara_app.models.Board
import com.example.new_ara_app.models.Post
import com.example.new_ara_app.networkings.NoticeState
import com.example.new_ara_app.setting.SettingActivity
import com.example.new_ara_app.setting.WidgetSettings


@Composable
fun MyContent(context: Context) {
    val posts = NoticeState.posts.collectAsState().value

    val size = LocalSize.current
    val showCount = if (size.height < 250.dp) 3 else 5

    var keywords by remember { mutableStateOf(emptySet<String>()) }
    var showTrending by remember { mutableStateOf(true) }
    var boards by remember { mutableStateOf(setOf(Board.Unknown.id)) }

    val openSettings = actionStartActivity(SettingActivity::class.java)
    val clickAction = actionStartActivity(MainActivity::class.java)

    LaunchedEffect(Unit) {
        WidgetSettings.getKeywords(context).collect { keywords = it }
        WidgetSettings.getShowTrending(context).collect { showTrending = it }
        WidgetSettings.getBoards(context).collect { boards = it }
    }

    LazyColumn(
        modifier = GlanceModifier.fillMaxSize().background(ColorProvider(Color.White))
            .padding(16.dp).clickable(clickAction), horizontalAlignment = Alignment.Start
    ) {
        item {
            Row(
                modifier = GlanceModifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Image(
                    provider = ImageProvider(R.drawable.rounded_inbox_text_24),
                    contentDescription = context.getString(R.string.portal_icon),
                    colorFilter = ColorFilter.tint(ColorProvider(Color(0xFFE45A4E))),
                    modifier = GlanceModifier.size(20.dp)
                )

                Spacer(modifier = GlanceModifier.width(8.dp))

                Text(
                    text = context.getString(R.string.portal_notices),
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
                    modifier = GlanceModifier.size(20.dp).clickable(openSettings)
                )
            }
        }

        item { Spacer(modifier = GlanceModifier.height(8.dp)) }
        if (posts.isNotEmpty()) {
            item {
                Box(modifier = GlanceModifier.fillMaxWidth(), contentAlignment = Alignment.Center) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Image(
                            provider = ImageProvider(R.drawable.baseline_browser_not_supported_24),
                            contentDescription = null,
                            colorFilter = ColorFilter.tint(ColorProvider(Color.Gray)),
                            modifier = GlanceModifier.size(50.dp)
                        )
                        Text(
                            text = context.getString(R.string.no_results),
                            style = TextStyle(
                                fontSize = 16.sp,
                                fontWeight = FontWeight.Bold,
                                color = ColorProvider(Color.Gray)
                            ),
                        )
                    }
                }
            }
        } else posts.take(showCount).forEach { post ->
            item {
                val intent = Intent (Intent.ACTION_VIEW, "newara://post/${post.id}".toUri()).setPackage(context.packageName)
                NoticeRow(
                    title = post.title,
                    subtitle = post.reason.localizedString(res = post.reason, context),
                    author = post.author,
                    board = post.reason,
                    onClick = actionStartActivity(intent)
                )
            }
        }
    }
}


@OptIn(ExperimentalGlancePreviewApi::class)
@Preview
@Composable
private fun Preview() {
    MyContent(LocalContext.current)
}

