package com.example.new_ara_app.setting

import android.app.Activity
import android.content.Context
import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Checkbox
import androidx.compose.material3.CheckboxDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch

@Composable
fun WidgetSettingView(
    context: Context
) {
    val scope = rememberCoroutineScope()

    var keywords by remember { mutableStateOf(setOf<String>()) }
    var newKeyword by remember { mutableStateOf("") }

    var showTrending by remember { mutableStateOf(true) }
    var boards by remember { mutableStateOf(setOf("TRENDING")) }

    var originalKeywords by remember { mutableStateOf(setOf<String>()) }
    var originalShowTrending by remember { mutableStateOf(true) }
    var originalBoards by remember { mutableStateOf(setOf("TRENDING")) }

    LaunchedEffect(Unit) {
        originalKeywords = WidgetSettings.getKeywords(context).first()
        originalShowTrending = WidgetSettings.getShowTrending(context).first()
        originalBoards = WidgetSettings.getBoards(context).first()

        keywords = originalKeywords
        showTrending = originalShowTrending
        boards = originalBoards
    }

    Column(
        verticalArrangement = Arrangement.spacedBy(16.dp),
        modifier = Modifier.padding(16.dp)
    ) {
        Text(
            "위젯 설정",
            style = MaterialTheme.typography.headlineMedium,
            fontWeight = FontWeight.Bold,
            color = Color(0xFFE45A4E),
            modifier = Modifier.align(Alignment.CenterHorizontally)
        )

        Column(
            modifier = Modifier
                .fillMaxWidth()
                .background(MaterialTheme.colorScheme.surface, shape = MaterialTheme.shapes.medium)
                .padding(12.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text(
                "키워드 등록",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.SemiBold
            )

            Row(
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                CustomTextField(
                    value = newKeyword,
                    onValueChange = { newKeyword = it },
                    placeholder = "키워드 입력",
                    onEnter = {
                        val trimmed = newKeyword.trim()
                        if (trimmed.isNotBlank() && keywords.size < 3) {
                            keywords = keywords + trimmed
                            newKeyword = ""
                        } else if (keywords.size >= 3) {
                            Toast.makeText(context, "키워드는 최대 3개까지만 추가 가능합니다.", Toast.LENGTH_SHORT).show()
                        }
                    }
                )
            }

            Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
                keywords.forEach { keyword ->
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.SpaceBetween,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text(keyword, modifier = Modifier.weight(1f))
                        IconButton(onClick = {
                            keywords = keywords - keyword
                        }) {
                            Icon(Icons.Default.Delete, contentDescription = "삭제", tint = Color.Gray)
                        }
                    }
                }
            }
        }

        Column(
            modifier = Modifier
                .shadow(elevation = 4.dp, shape = MaterialTheme.shapes.medium)
                .fillMaxWidth()
                .background(Color.White, shape = MaterialTheme.shapes.medium)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("인기 급상승 게시물 보기", style = MaterialTheme.typography.titleMedium)
                Switch(
                    checked = showTrending,
                    onCheckedChange = { showTrending = it },
                    colors = SwitchDefaults.colors(
                        checkedIconColor = Color.White,
                        checkedTrackColor = Color(0xFFE45A4E),
                        uncheckedTrackColor = Color(0xFFA8A8A8),
                        uncheckedThumbColor = Color.White
                    )
                )
            }
        }

        Text("표시 게시판", style = MaterialTheme.typography.titleMedium)
        Column(
            modifier = Modifier
                .shadow(elevation = 4.dp, shape = MaterialTheme.shapes.medium)
                .fillMaxWidth()
                .background(Color.White, shape = MaterialTheme.shapes.medium)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            listOf("TRENDING", "KEYWORD", "NOTICE").forEach { board ->
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Checkbox(
                        checked = boards.contains(board),
                        onCheckedChange = { checked ->
                            boards = if (checked) boards + board else boards - board
                        },
                        colors = CheckboxDefaults.colors(
                            checkedColor = Color(0xFFE45A4E)
                        ),
                        modifier = Modifier.clip(CircleShape)
                    )
                    Text(board)
                }
            }
        }

        Spacer(Modifier.weight(1f))

        Row(
            horizontalArrangement = Arrangement.spacedBy(16.dp),
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.fillMaxWidth()
        ) {
            Button(
                onClick = {
                    keywords = originalKeywords
                    newKeyword = ""
                    showTrending = originalShowTrending
                    boards = originalBoards

                    (context as? Activity)?.finishAffinity()
                },
                modifier = Modifier
                    .weight(1f)
                    .border(2.dp, Color(0xFFE45A4E), RoundedCornerShape(12.dp)),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color.White,
                    contentColor = Color(0xFFE45A4E)
                ),
                shape = RoundedCornerShape(12.dp)
            ) {
                Text("취소")
            }

            Button(
                onClick = {
                    scope.launch {
                        WidgetSettings.setKeywords(context, keywords)
                        WidgetSettings.setShowTrending(context, showTrending)
                        WidgetSettings.setBoards(context, boards)

                        originalKeywords = keywords
                        originalShowTrending = showTrending
                        originalBoards = boards
                        (context as? Activity)?.finishAffinity()
                    }
                },
                modifier = Modifier.weight(1f),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color(0xFFE45A4E),
                    contentColor = Color.White
                ),
                shape = RoundedCornerShape(12.dp)
            ) {
                Text("확인")
            }
        }
    }
}


@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun CustomTextField(
    value: String,
    onValueChange: (String) -> Unit,
    placeholder: String = "",
    modifier: Modifier = Modifier,
    onEnter: (() -> Unit)? = null,
) {
    TextField(
        value = value,
        onValueChange = onValueChange,
        placeholder = { Text(text = placeholder) },
        colors = TextFieldDefaults.textFieldColors(
            containerColor = Color.White,
            focusedIndicatorColor = Color.Transparent,
            unfocusedIndicatorColor = Color.Transparent
        ),
        singleLine = true,
        shape = RoundedCornerShape(12.dp),
        modifier = modifier
            .fillMaxWidth()
            .border(2.dp, Color.Red, RoundedCornerShape(12.dp))
            .background(Color.White, RoundedCornerShape(12.dp)),
        keyboardOptions = KeyboardOptions.Default.copy(
            imeAction = ImeAction.Done
        ),
        keyboardActions = KeyboardActions(
            onDone = { onEnter?.invoke() }
        )
    )
}

@Preview
@Composable
private fun Preview() {
    WidgetSettingView(LocalContext.current)
}
