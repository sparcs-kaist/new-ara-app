package com.example.new_ara_app.models

import android.content.Context
import com.example.new_ara_app.R

sealed class DisplayReason {
    data object Trending : DisplayReason()
    data class Keyword(val word: String) : DisplayReason()
    data class Board(val selectedBoard: com.example.new_ara_app.models.Board) : DisplayReason()

    companion object {
        fun icon(res: DisplayReason): Int = when (res) {
            Trending -> R.drawable.round_trending_up_24
            is Keyword -> R.drawable.outline_local_offer_24
            is Board -> R.drawable.outline_storage_24
        }
    }

    fun localizedString(res: DisplayReason, context: Context): String = when (res) {
        is Trending -> context.getString(R.string.trending)
        is Keyword -> context.getString(R.string.keyword_detected, res.word)
        is Board -> context.getString(
            R.string.board_notice,
            res.selectedBoard.localizedString(context)
        )
    }

}
