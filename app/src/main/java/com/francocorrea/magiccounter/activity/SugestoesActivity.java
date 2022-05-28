package com.francocorrea.magiccounter.activity;

import androidx.appcompat.app.AppCompatActivity;

import android.content.ActivityNotFoundException;
import android.content.ComponentName;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.francocorrea.magiccounter.R;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.initialization.InitializationStatus;
import com.google.android.gms.ads.initialization.OnInitializationCompleteListener;

public class SugestoesActivity extends AppCompatActivity {

    private Button btnPolicy, btn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sugestoes);


        MobileAds.initialize(SugestoesActivity.this, new OnInitializationCompleteListener() {
            @Override
            public void onInitializationComplete(InitializationStatus initializationStatus) {
            }
        });

        AdView adView = findViewById(R.id.adView);
        AdRequest adRequest = new AdRequest.Builder().build();
        adView.loadAd(adRequest);



        btnPolicy = findViewById(R.id.button_policy);

        btnPolicy.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                String URL_GLOBAL = "https://frcc248.wixsite.com/lifecounterpolitics";
//                new connectAsyncTaskLigaMagic(URL_GLOBAL).execute();
                try {
                    Intent i = new Intent("android.intent.action.MAIN");
                    i.setComponent(ComponentName.unflattenFromString("com.android.chrome/com.android.chrome.Main"));
                    i.addCategory("android.intent.category.LAUNCHER");
                    i.setData(Uri.parse(URL_GLOBAL));
                    startActivity(i);
                }
                catch(ActivityNotFoundException e) {
                   // Toast.makeText(SugestoesActivity.this, "Nao foi possivel iniciar Activity. [SAC-04]", Toast.LENGTH_LONG).show();
                    // Chrome is not installed
                    Intent i = new Intent(Intent.ACTION_VIEW, Uri.parse(URL_GLOBAL));
                    startActivity(i);
                }
            }
        });




    }


}
