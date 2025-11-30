package com.example.new_ara_app.networkings

import com.example.new_ara_app.models.Post
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

object NoticeState {
    private val _posts = MutableStateFlow<List<Post>>(emptyList())
    val posts = _posts.asStateFlow()

    fun setPosts(list: List<Post>) {
        _posts.value = list
    }
}
