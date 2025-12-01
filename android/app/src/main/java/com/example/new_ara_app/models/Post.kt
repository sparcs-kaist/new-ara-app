package com.example.new_ara_app.models

import java.util.Calendar
import java.util.Date



data class Post(
    val id: Int,
    val title: String,
    val author: String,
    val reason: DisplayReason,
    val date: Date
) {
    companion object {
        val mock: Post
            get() = Post(
                id = 1,
                title = "Trending Post",
                author = "Admission Dept.",
                reason = DisplayReason.Trending,
                date = Date()
            )

        val mockList: List<Post>
            get() {
                val now = Calendar.getInstance()
                return listOf(
                    Post(1, "Post 1", "Admission Dept.", DisplayReason.Trending, now.apply { add(
                        Calendar.MINUTE, 1) }.time),
                    Post(2, "Post 2", "Admission Dept.", DisplayReason.Board(Board.Affiliates), now.apply { add(
                        Calendar.MINUTE, 2) }.time),
                    Post(3, "Post 3", "Admission Dept.", DisplayReason.Board(Board.Affiliates), now.apply { add(
                        Calendar.MINUTE, 3) }.time),
                    Post(4, "Post 4", "Admission Dept.", DisplayReason.Keyword("Post"), now.apply { add(
                        Calendar.MINUTE, 4) }.time),
                    Post(5, "Post 5", "Admission Dept.", DisplayReason.Keyword("Trending"), now.apply { add(
                        Calendar.MINUTE, 5) }.time),
                )
            }
    }
}