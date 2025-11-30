package com.example.new_ara_app.networkings

import android.content.Context
import retrofit2.http.GET
import retrofit2.http.Query
import retrofit2.http.Header

fun readCookie(context: Context): String {
    val sharedPref = context.getSharedPreferences("home_widget_prefs", Context.MODE_PRIVATE)
    return sharedPref.getString("user_cookie", "") ?: ""
}

sealed interface PortalWidgetTarget {
    data class FetchPostsByKeyword(val keyword: String) : PortalWidgetTarget
    data class FetchPostsByBoardId(val boardId: Int) : PortalWidgetTarget
    data object FetchTrendingPosts : PortalWidgetTarget
    data class FetchNoticeByPostId(val postId: Int) : PortalWidgetTarget
}

interface PortalWidgetService {
    @GET("articles")
    suspend fun fetchPostsByKeyword(
        @Query("main_search__contains") keyword: String,
        @Query("parent_board") parentBoard: Int = 1,
        @Query("page") page: Int = 1,
        @Query("page_size") pageSize: Int = 5,
        @Header("Cookie") cookie: String
    ): ResultDTO

    @GET("kaist/portal_notice")
    suspend fun fetchPostsByBoardId(
        @Query("board") boardId: Int,
        @Query("page") page: Int = 1,
        @Query("page_size") pageSize: Int = 5,
        @Header("Cookie") cookie: String
    ): ResultDTO

    @GET("kaist/portal_notice/trending")
    suspend fun fetchTrendingPosts(
        @Header("Cookie") cookie: String
    ): ResultDTO

    @GET("kaist/portal_notice/by_article")
    suspend fun fetchNoticeByPostId(
        @Query("ara_article") postId: Int,
        @Header("Cookie") cookie: String
    ): PostDTO
}
