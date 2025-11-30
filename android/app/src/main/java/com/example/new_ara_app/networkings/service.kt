package com.example.new_ara_app.networkings

import kotlinx.serialization.Serializable
import retrofit2.Response
import retrofit2.http.GET
import retrofit2.http.Query

interface WidgetApiService {
        @GET("portal_notice/")
        suspend fun getNotices(
            @Query("board") boardId: Int? = null,
            @Query("limit") limit: Int = 10
        ): List<NoticeResponse>

        @GET("portal_notice/trending/")
        suspend fun getTrendingNotices(): List<NoticeResponse>

        @GET("portal_notice/by_article/")
        suspend fun getNoticeByArticle(
            @Query("ara_article") araArticleId: Int
        ): NoticeResponse
    }

@Serializable
data class NoticeResponse(
    val id: Int,
    val title: String,
    val content: String,
    val board_id: Int?,
    val registered_at: String,
    val view_count: Int
)