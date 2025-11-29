package com.example.new_ara_app.models

import java.util.Date

data class Post(
    val id: String,
    val title: String,
    val author: String,
    val reason: DisplayReason,
    val date: Date
)
