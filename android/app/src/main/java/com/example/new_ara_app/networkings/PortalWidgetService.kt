package com.example.new_ara_app.networkings

import android.content.Context
import retrofit2.http.GET
import retrofit2.http.Query

interface PortalWidgetService {
    @GET("articles")
    suspend fun fetchPostsByKeyword(
        @Query("main_search__contains") keyword: String,
        @Query("parent_board") parentBoard: Int = 1,
        @Query("page") page: Int = 1,
        @Query("page_size") pageSize: Int = 5,
    ): KeywordResultDTO

    @GET("kaist/portal_notice")
    suspend fun fetchPostsByBoardId(
        @Query("board") boardId: Int,
        @Query("page") page: Int = 1,
        @Query("page_size") pageSize: Int = 5,
    ): List<PostDTO>

    @GET("kaist/portal_notice/trending")
    suspend fun fetchTrendingPosts(
    ): List<PostDTO>

    @GET("kaist/portal_notice/by_article")
    suspend fun fetchNoticeByPostId(
        @Query("ara_article") postId: Int,
    ): PostDTO
}

