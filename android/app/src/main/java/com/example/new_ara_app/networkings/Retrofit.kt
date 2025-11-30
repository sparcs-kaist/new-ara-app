package com.example.new_ara_app.networkings

import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

fun createRetrofitWithCookie(cookie: String): PortalWidgetService {
    val logging = HttpLoggingInterceptor().apply { level = HttpLoggingInterceptor.Level.BODY }
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
        .baseUrl("https://newara.dev.sparcs.org/api/")
        .client(client)
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(PortalWidgetService::class.java)
}
