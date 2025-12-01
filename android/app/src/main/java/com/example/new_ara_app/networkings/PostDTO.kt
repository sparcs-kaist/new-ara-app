package com.example.new_ara_app.networkings

import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import com.example.new_ara_app.helpers.toDate
import com.example.new_ara_app.models.DisplayReason
import com.example.new_ara_app.models.Post
import com.google.gson.annotations.SerializedName
import java.util.Date

data class PostDTO(
    val title: String,
    @SerializedName("ara_article") val araID: Int,
    @SerializedName("writer_department") val author: String,
    @SerializedName("registered_at") val date: String,
) {
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
}

data class KeywordPostDTO(
    val id: Int,
    val title: String,
) {
    @RequiresApi(Build.VERSION_CODES.O)
    suspend fun getPost(keyword: String, api: PortalWidgetService, context: Context): Post? {
        return try {
            val post = api.fetchNoticeByPostId(this.id)
            post.toModel(DisplayReason.Keyword(keyword))
        } catch (e: Exception) {
            null
        }
    }
}

data class KeywordResultDTO(
    val results: List<KeywordPostDTO>
)