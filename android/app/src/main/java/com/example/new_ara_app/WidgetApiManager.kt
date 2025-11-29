package com.example.new_ara_app

import android.content.Context
import android.util.Log
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import androidx.glance.appwidget.updateAll
import androidx.work.CoroutineWorker
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.WorkerParameters
import com.example.new_ara_app.networkings.WidgetApiService
import com.example.new_ara_app.notice.NoticeWidget
import com.example.new_ara_app.setting.dataStore
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.scalars.ScalarsConverterFactory
import java.util.concurrent.TimeUnit

val KEY_WIDGET_DATA = stringPreferencesKey("widget_data")

class WidgetApiWorker(
    context: Context,
    params: WorkerParameters
) : CoroutineWorker(context, params) {

    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        try {
            val prefs = applicationContext.dataStore.data.first()
            val cookie = prefs[KEY_WIDGET_DATA] ?: return@withContext Result.retry()
            val logging = HttpLoggingInterceptor { message -> Log.d("WidgetApi", message) }
            logging.level = HttpLoggingInterceptor.Level.BODY
            val client = OkHttpClient.Builder()
                .addInterceptor { chain ->
                    val request = chain.request().newBuilder()
                        .addHeader("Cookie", cookie)
                        .build()
                    chain.proceed(request)
                }
                .addInterceptor(logging)
                .build()

            val request = Request.Builder()
                .url("https://newara.sparcs.org/api/portal-notice/trending/")
                .addHeader("Cookie", cookie)
                .build()

            val response = client.newCall(request).execute()
            if (!response.isSuccessful) return@withContext Result.retry()
            val body = response.body?.string() ?: ""

            applicationContext.dataStore.edit { it[KEY_WIDGET_DATA] = body }

           NoticeWidget().updateAll(applicationContext)

            Result.success()
        } catch (e: Exception) {
            e.printStackTrace()
            Result.retry()
        }
    }
}

fun createApi(cookie: String): WidgetApiService {
    val logging = HttpLoggingInterceptor { message -> Log.d("WidgetApi", message) }
    logging.level = HttpLoggingInterceptor.Level.BODY

    val client = OkHttpClient.Builder()
        .addInterceptor { chain ->
            val request = chain.request().newBuilder()
                .addHeader("Cookie", cookie)
                .build()
            chain.proceed(request)
        }
        .addInterceptor(logging)
        .build()

    return Retrofit.Builder()
        .baseUrl("https://newara.sparcs.org")
        .client(client)
        .addConverterFactory(ScalarsConverterFactory.create())
        .build()
        .create(WidgetApiService::class.java)
}



fun scheduleWidgetWorker(context: Context) {
    val workRequest = PeriodicWorkRequestBuilder<WidgetApiWorker>(1, TimeUnit.HOURS)
        .build()
    WorkManager.getInstance(context).enqueueUniquePeriodicWork(
        "widget_api_worker",
        ExistingPeriodicWorkPolicy.REPLACE,
        workRequest
    )
}
