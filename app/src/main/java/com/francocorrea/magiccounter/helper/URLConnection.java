package com.francocorrea.magiccounter.helper;

import android.util.Log;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class URLConnection {

    InputStream is = null;
    JSONObject jObj = null;
    String json = "";

    // constructor
    public URLConnection() {
    }

    public String getResponseFromUrl(String stringUrl) {

        // Making HTTP request
        try {

            URL url = new URL(stringUrl);

            HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
            urlConnection.setRequestMethod("GET");
            urlConnection.connect();

            InputStream inputStream = urlConnection.getInputStream();
            if (inputStream == null) {
                return null;
            }

            BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, "utf-8"));
            String linha;
            StringBuffer buffer = new StringBuffer();
            while ((linha = reader.readLine()) != null) {
                buffer.append(linha + "\n");
            }

            if (buffer.length() == 0) {
                return null;
            }

            if (urlConnection != null) {
                urlConnection.disconnect();
            }

            if (reader != null) {

                try {
                    reader.close();
                } catch (final IOException e) {
                    Log.e("LOGRast", "JsonParser: Erro fechando o stream", e);
                }

            }

            json = buffer.toString();
            is.close();

        } catch (Exception e) {
            Log.e("Buffer Error", "Error converting result " + e.toString());
        }
        return json;

    }
}