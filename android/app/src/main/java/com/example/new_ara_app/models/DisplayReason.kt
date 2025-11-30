package com.example.new_ara_app.models

import com.example.new_ara_app.R

sealed class DisplayReason {
    data object Trending : DisplayReason()
    data class Keyword(val word: String) : DisplayReason()
    data class BoardReason(val selectedBoard: Board) : DisplayReason()
}

fun DisplayReason.localizedString(): String = when (this) {
    is DisplayReason.Trending -> "Trending"
    is DisplayReason.Keyword -> "Keyword \"${word}\" detected"
    is DisplayReason.BoardReason -> "Notice in ${selectedBoard.localizedString}"
}

fun DisplayReason.image(): Int = when(this) {
    is DisplayReason.Trending -> R.drawable.round_trending_up_24
    is DisplayReason.Keyword -> R.drawable.outline_local_offer_24
    is DisplayReason.BoardReason -> R.drawable.outline_storage_24

}
