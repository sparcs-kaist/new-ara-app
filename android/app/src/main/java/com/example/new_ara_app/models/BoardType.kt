
package com.example.new_ara_app.models

import com.example.new_ara_app.R

enum class BoardType {
    TRENDING,
    KEYWORD,
    OTHER;

    companion object {
        fun fromBoard(board: BoardType): Int = when (board) {
            TRENDING -> R.drawable.round_trending_up_24
            KEYWORD -> R.drawable.outline_local_offer_24
            else -> R.drawable.outline_storage_24
        }
    }
}