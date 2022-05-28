package com.francocorrea.magiccounter.activity;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.ComponentName;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.francocorrea.magiccounter.R;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.initialization.InitializationStatus;
import com.google.android.gms.ads.initialization.OnInitializationCompleteListener;

public class NovaTelaInicialActivity extends AppCompatActivity {

    private Button btnGotoSite, btnWpp, btnInsta, btnCupons, btnMarcadordevida, btnConfig;
    public Activity context;
    private AdView mAdView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_nova_tela_inicial);

        context = this;

        btnGotoSite = findViewById(R.id.btn_goto_site);
        btnWpp = findViewById(R.id.btnWpp);
        btnInsta = findViewById(R.id.bntInsta);
        btnCupons = findViewById(R.id.btnCupons);
        btnMarcadordevida = findViewById(R.id.btnMarcadordevida);
        btnConfig = findViewById(R.id.btnCofig);


        btnGotoSite.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                String URL_GLOBAL = "https://www.lighthousegeek.com.br";
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

        btnWpp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String contact = "+55 37998567250"; // use country code with your phone number
                String url = "https://api.whatsapp.com/send?phone=" + contact;


                try {
                    PackageManager pm = context.getPackageManager();
                    pm.getPackageInfo("com.whatsapp", PackageManager.GET_ACTIVITIES);
                    Intent i = new Intent(Intent.ACTION_VIEW);
                    i.setData(Uri.parse(url));
                    startActivity(i);

                } catch (PackageManager.NameNotFoundException e) {
                    try {
                        PackageManager pm = context.getPackageManager();
                        pm.getPackageInfo("com.whatsapp.w4b", PackageManager.GET_ACTIVITIES);
                        Intent i = new Intent(Intent.ACTION_VIEW);
                        i.setData(Uri.parse(url));
                        startActivity(i);
                    }catch (PackageManager.NameNotFoundException e2) {
                        Toast.makeText(context, "Whatsapp app not installed in your phone. " + e2.getMessage(), Toast.LENGTH_SHORT).show();
                        e.printStackTrace();
                    }
                }

            }
        });

        btnInsta.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Uri uri = Uri.parse("https://www.instagram.com/lighthouse.geek/");
                Intent likeIng = new Intent(Intent.ACTION_VIEW, uri);

                likeIng.setPackage("com.instagram.android");

                try {
                    startActivity(likeIng);
                } catch (ActivityNotFoundException e) {
                    startActivity(new Intent(Intent.ACTION_VIEW,
                            Uri.parse("https://www.instagram.com/lighthouse.geek/")));
                }

            }
        });


        btnCupons.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(context, "Utilize o cupom #LIGHTHOUSE10APP em sua primeira compra para ganhar 10% de desconto", Toast.LENGTH_SHORT).show();
                Intent i = new Intent(NovaTelaInicialActivity.this, ConsultaCardsActivity.class);
                startActivity(i);

            }
        });

        btnMarcadordevida.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(NovaTelaInicialActivity.this, ContadorClean2PActivity.class);
                startActivity(i);

            }
        });

        btnConfig.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent i = new Intent(NovaTelaInicialActivity.this, ConfigActivity.class);
                startActivity(i);

            }
        });

        TextView txt_configVersion = findViewById(R.id.txt_version_config);
        try {
            PackageInfo pInfo = this.getPackageManager().getPackageInfo(getPackageName(), 0);
            String version = pInfo.versionName;
            txt_configVersion.setText(getString(R.string.versao) + version);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        MobileAds.initialize(NovaTelaInicialActivity.this, new OnInitializationCompleteListener() {
            @Override
            public void onInitializationComplete(InitializationStatus initializationStatus) {
            }
        });

        mAdView = findViewById(R.id.adView);
        AdRequest adRequest = new AdRequest.Builder().build();
        mAdView.loadAd(adRequest);




    }



}