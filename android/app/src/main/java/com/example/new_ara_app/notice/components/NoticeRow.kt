package com.example.new_ara_app.notice.components

import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.ColorFilter
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.action.Action
import androidx.glance.action.actionStartActivity
import androidx.glance.action.clickable
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.preview.ExperimentalGlancePreviewApi
import androidx.glance.preview.Preview
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import com.example.new_ara_app.models.DisplayReason
import io.flutter.embedding.android.FlutterActivity


@Composable
fun NoticeRow(
    title: String,
    subtitle: String,
    author: String,
    board: DisplayReason,
    onClick: Action,
) {
    Column {
        Spacer(
            modifier = GlanceModifier
                .fillMaxWidth()
                .height(1.dp)
                .background(ColorProvider(Color.LightGray))
        )

        Column(
            modifier = GlanceModifier
                .fillMaxWidth()
                .padding(8.dp)
                .clickable(onClick)
        ) {
            Text(
                text = title,
                maxLines = 1,
                style = TextStyle(
                    fontSize = 14.sp,
                    fontWeight = FontWeight.Medium,
                    color = ColorProvider(Color.Black)
                ),
                modifier = GlanceModifier.padding(end = 4.dp)
            )


            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = GlanceModifier.fillMaxWidth()
            ) {
                Image(
                    provider = ImageProvider(DisplayReason.icon(res = board)),
                    contentDescription = null,
                    colorFilter = ColorFilter.tint(ColorProvider(Color.LightGray)),
                    modifier = GlanceModifier.size(20.dp).padding(end = 4.dp)
                )

                Text(
                    text = subtitle,
                    maxLines = 1,
                    style = TextStyle(
                        fontSize = 12.sp,
                        color = ColorProvider(Color(0xFF7A7A7A))
                    ),
                    modifier = GlanceModifier.defaultWeight()
                )

                Text(
                    text = author,
                    maxLines = 1,
                    style = TextStyle(
                        fontSize = 10.sp,
                        color = ColorProvider(Color.Gray)
                    ),
                )
            }
        }
    }
}

@OptIn(ExperimentalGlancePreviewApi::class)
@Preview
@Composable
private fun Preview() {
    NoticeRow(
        title = "< 공지 > 캠퍼스 내 실내소독 작업 안내 (어쩌구저쩌구 대충 엄청 긴 제목",
        subtitle = "인기 급상승",
        author = "시설팀",
        board = DisplayReason.Trending,
        onClick = actionStartActivity<FlutterActivity>()
    )
}