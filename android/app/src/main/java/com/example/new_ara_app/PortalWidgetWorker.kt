package com.example.new_ara_app

import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.work.Constraints
import androidx.work.CoroutineWorker
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.NetworkType
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.WorkerParameters
import com.example.new_ara_app.models.Board
import com.example.new_ara_app.networkings.NoticeState
import com.example.new_ara_app.networkings.PortalWidgetAPI
import com.example.new_ara_app.networkings.createRetrofitWithCookie
import com.example.new_ara_app.networkings.readWidgetConfiguration
import java.util.concurrent.TimeUnit

data class WidgetConfiguration(
    val showTrending: Boolean = true,
    val keywords: List<String> = emptyList(),
    val selectedBoards: List<Board> = emptyList(),
)

class PortalWidgetWorker(
    private val context: Context,
    workerParams: WorkerParameters,
) : CoroutineWorker(context, workerParams) {

    @RequiresApi(Build.VERSION_CODES.O)
    override suspend fun doWork(): Result {
        return try {
            val flutterContext = context.createPackageContext(
                "org.sparcs.newara",
                Context.CONTEXT_IGNORE_SECURITY
            )
            val sharedPref = flutterContext.getSharedPreferences(
                "HomeWidgetPreferences",
                Context.MODE_PRIVATE
            )
            val cookie = sharedPref.getString("user_cookie", "") ?: ""

            val retrofit = createRetrofitWithCookie(cookie)
            val config = readWidgetConfiguration(context)

            val repo = PortalWidgetAPI(retrofit, context)
            repo.fetchAndStorePosts(config)

            Result.success()
        } catch (e: Exception) {
            Result.retry()
        }
    }
}

fun schedulePortalWidgetWorker(context: Context) {
    val workRequest = PeriodicWorkRequestBuilder<PortalWidgetWorker>(
        1, TimeUnit.HOURS
    )
        .setConstraints(
            Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .build()
        )
        .build()

    WorkManager.getInstance(context).enqueueUniquePeriodicWork(
        "PortalWidgetUpdateWork",
        ExistingPeriodicWorkPolicy.REPLACE,
        workRequest
    )
}
