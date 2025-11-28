package com.example.new_ara_app.setting

import android.content.Context
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringSetPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

val Context.dataStore by preferencesDataStore(name = "widget_prefs")

object WidgetSettings {
    private val KEYWORDS = stringSetPreferencesKey("keywords")
    private val SHOW_TRENDING = booleanPreferencesKey("show_trending")
    private val BOARDS = stringSetPreferencesKey("boards")

    fun getKeywords(context: Context): Flow<Set<String>> =
        context.dataStore.data.map { it[KEYWORDS] ?: emptySet() }

    suspend fun setKeywords(context: Context, keywords: Set<String>) {
        context.dataStore.edit { it[KEYWORDS] = keywords }
    }

    fun getShowTrending(context: Context): Flow<Boolean> =
        context.dataStore.data.map { it[SHOW_TRENDING] ?: true }

    suspend fun setShowTrending(context: Context, show: Boolean) {
        context.dataStore.edit { it[SHOW_TRENDING] = show }
    }

    fun getBoards(context: Context): Flow<Set<String>> =
        context.dataStore.data.map { it[BOARDS] ?: setOf("TRENDING") }

    suspend fun setBoards(context: Context, boards: Set<String>) {
        context.dataStore.edit { it[BOARDS] = boards }
    }
}
