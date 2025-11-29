package com.example.new_ara_app.networkings

import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import com.example.new_ara_app.models.DisplayReason
import com.example.new_ara_app.models.Post
import kotlinx.serialization.SerialName
import java.time.Instant
import java.util.Date

data class ResultDTO(
    val results: List<PostDTO>
)

data class PostDTO(
    val id: Int,
    val title: String,
    @SerialName("ara_article") val araID: Int,
    @SerialName("writer_department") val author: String,
    @SerialName("registered_at") val date: String
){
    @RequiresApi(Build.VERSION_CODES.O)
    fun toModel(reason: DisplayReason): Post {
        return Post(
            id = this.araID,
            title = this.title,
            author = this.author,
            reason = reason,
            date = date.toDate() ?: Date(Long.MIN_VALUE)
        )
    }
    @RequiresApi(Build.VERSION_CODES.O)
    suspend fun getPost(keyword: String, api: PortalWidgetService, context: Context): Post? {
        return try {
            val postDto = api.fetchNoticeByPostId(this.araID, cookie = readCookie(context))
            toModel(DisplayReason.Keyword(keyword))
        } catch (e: Exception) {
            null
        }
    }

}

data class KeywordListDTO(
    val id: Int,
    val title: String
)

data class KeywordResultDTO(
    val results: List<KeywordListDTO>
)

@RequiresApi(Build.VERSION_CODES.O)
fun String.toDate(): Date? {
    return runCatching {
        Date.from(Instant.parse(this))
    }.getOrNull()
}

@RequiresApi(Build.VERSION_CODES.O)
suspend fun KeywordListDTO.getPost(
    keyword: String,
    api: PortalWidgetService,
    context: Context
): Post? {
    return try {
        val postDto = api.fetchNoticeByPostId(this.id, cookie = readCookie(context))
        postDto.toModel(DisplayReason.Keyword(keyword))
    } catch (e: Exception) {
        null
    }
}
