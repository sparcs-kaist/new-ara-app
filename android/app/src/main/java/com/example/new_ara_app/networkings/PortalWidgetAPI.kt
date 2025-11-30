package com.example.new_ara_app.networkings

import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.glance.appwidget.GlanceAppWidgetManager
import com.example.new_ara_app.models.Board
import com.example.new_ara_app.models.DisplayReason
import com.example.new_ara_app.models.Post
import com.example.new_ara_app.WidgetConfiguration
import com.example.new_ara_app.notice.PortalWidgetProvider
import com.example.new_ara_app.setting.WidgetSettings
import kotlinx.coroutines.flow.first

class PortalWidgetAPI(private val api: PortalWidgetService, private val context: Context) {

    @RequiresApi(Build.VERSION_CODES.O)
    private suspend fun fetchPostsByKeyword(keyword: String): List<Post> {
        return try {
            val posts = api.fetchPostsByKeyword(keyword = keyword)
            val result = mutableListOf<Post>()
            posts.results.take(5).forEach { listing ->
                val post = listing.getPost(keyword, api, context)
                if (post != null) {
                    result.add(post)
                }
            }
            result
        } catch (e: Exception) {
            emptyList()
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    suspend fun fetchAndStorePosts(configuration: WidgetConfiguration) {
        val data = fetchPosts(configuration)
        val manager = GlanceAppWidgetManager(context)
        val ids = manager.getGlanceIds(PortalWidgetProvider::class.java)

        NoticeState.setPosts(data)

        ids.forEach { id ->
            PortalWidgetProvider().update(context, id)
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    suspend fun fetchPostsByBoardId(board: DisplayReason.Board): List<Post> {
        return try {
            val boardId = board.selectedBoard.id
            val posts = api.fetchPostsByBoardId(boardId)
            posts.take(5).map { it.toModel(board) }
        } catch (e: Exception) {
            emptyList()
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    suspend fun fetchTrendingPosts(): List<Post> {
        return try {
            val posts = api.fetchTrendingPosts()
            posts.take(5).map { it.toModel(DisplayReason.Trending) }
        } catch (e: Exception) {
            emptyList()
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    suspend fun fetchPosts(configuration: WidgetConfiguration): List<Post> {
        val result = mutableListOf<Post>()
        if (configuration.showTrending) result += fetchTrendingPosts()
        configuration.keywords.forEach { result += fetchPostsByKeyword(it) }
        configuration.selectedBoards.forEach { result += fetchPostsByBoardId(DisplayReason.Board(it)) }
        return result.distinctBy { it.id }.sortedByDescending { it.date }
    }
}

suspend fun readWidgetConfiguration(context: Context): WidgetConfiguration {
    val showTrending = WidgetSettings.getShowTrending(context).first()
    val keywords = WidgetSettings.getKeywords(context).first().toList()
    val selectedBoards = WidgetSettings.getBoards(context)
        .first()
        .map { Board.fromId(it) }

    return WidgetConfiguration(
        showTrending = showTrending,
        keywords = keywords,
        selectedBoards = selectedBoards
    )
}