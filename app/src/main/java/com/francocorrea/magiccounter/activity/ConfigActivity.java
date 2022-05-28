package com.francocorrea.magiccounter.activity;

import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.content.res.Resources;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.os.Handler;
import android.util.DisplayMetrics;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RadioButton;
import android.widget.SeekBar;
import android.widget.Switch;
import android.widget.TextView;

import com.francocorrea.magiccounter.R;
import com.francocorrea.magiccounter.helper.Preferencias;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.initialization.InitializationStatus;
import com.google.android.gms.ads.initialization.OnInitializationCompleteListener;


import java.util.Locale;

public class ConfigActivity extends AppCompatActivity {

    Preferencias preferencias;

    RadioButton rb_2p;
    RadioButton rb_3p;

    private Button bt_sugestoes;
    private Button bt_mana_base;
//    private Button bt_consulta_cards;

    private SeekBar seekBar_txt_size;
    private TextView textView_txt_size;

    CheckBox cb_20hp;
    CheckBox cb_30hp;
    CheckBox cb_40hp;

    CheckBox cb_45s;
    CheckBox cb_60s;
    CheckBox cb_90s;

    CheckBox cb_show_counters;

    ImageView img_eua, img_br, img_es;
    Switch aSwitchSom;
    ProgressBar mProgressBarConfig;


    private Handler mHandler = new Handler();
    private Handler mHandler2 = new Handler();
    private AdView mAdView;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_config);

        preferencias = new Preferencias(ConfigActivity.this);

        TextView txt_configVersion = findViewById(R.id.txt_version_config);
        rb_2p   = findViewById(R.id.rb_2players);
        rb_3p   = findViewById(R.id.rb_3players);

        cb_20hp    = findViewById(R.id.cb_20);
        cb_30hp    = findViewById(R.id.cb_30);
        cb_40hp    = findViewById(R.id.cb_40);

        cb_45s     = findViewById(R.id.cb_45);
        cb_60s     = findViewById(R.id.cb_60);
        cb_90s     = findViewById(R.id.cb_90);

        cb_show_counters = findViewById(R.id.cb_cont_energia);

        img_br = findViewById(R.id.img_br);
        img_es = findViewById(R.id.img_es);
        img_eua = findViewById(R.id.img_eua);
        aSwitchSom = findViewById(R.id.switchSom);

        aSwitchSom.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if(aSwitchSom.isChecked()){
                    try{
                        preferencias.salvarSom("on");
                    }catch (Exception e){

                    }
                }
                else{
                    preferencias.salvarSom("off");
                }
            }
        });

        mHandler.post(new Runnable() {
            @Override
            public void run() {
                buscarPreferencias();
            }
        });

        mHandler2.post(new Runnable() {
            @Override
            public void run() {

                setTextSize();

                MobileAds.initialize(ConfigActivity.this, new OnInitializationCompleteListener() {
                    @Override
                    public void onInitializationComplete(InitializationStatus initializationStatus) {
                    }
                });

                mAdView = findViewById(R.id.adView);
                AdRequest adRequest = new AdRequest.Builder().build();
                mAdView.loadAd(adRequest);
            }


        });



        seekBar_txt_size = findViewById(R.id.seekBar_txt_size);
        textView_txt_size =  findViewById(R.id.textView_txt_size);

        seekBar_txt_size.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            int progress = 0;

            @Override
            public void onProgressChanged(SeekBar seekBar, int progresValue, boolean fromUser) {
                progress = progresValue;
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

                float txt_size = (float) (progress) / 10;
                preferencias.salvarTamanhoTexto(String.valueOf(txt_size));


                textView_txt_size.setTextSize(txt_size * 40);
                rb_2p.setTextSize(txt_size * 40);
                rb_3p.setTextSize(txt_size * 40);
                cb_20hp.setTextSize(txt_size * 40);
                cb_30hp.setTextSize(txt_size * 40);
                cb_40hp.setTextSize(txt_size * 40);
                cb_45s.setTextSize(txt_size * 40);
                cb_60s.setTextSize(txt_size * 40);
                cb_90s.setTextSize(txt_size * 40);
                cb_show_counters.setTextSize(txt_size * 30);
//                bt_consulta_cards.setTextSize(txt_size * 30);
                bt_mana_base.setTextSize(txt_size * 30);
                bt_sugestoes.setTextSize(txt_size * 30);




            }
        });

        img_br.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                preferencias.salvarLingua("pt");
                Intent refresh = new Intent(ConfigActivity.this, ConfigActivity.class);
                setLocale("pt", refresh);
                finish();
            }
        });


        img_eua.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                preferencias.salvarLingua("en");
                Intent refresh = new Intent(ConfigActivity.this, ConfigActivity.class);
                setLocale("en", refresh);
                finish();
            }
        });

        img_es.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                preferencias.salvarLingua("es");
                Intent refresh = new Intent(ConfigActivity.this, ConfigActivity.class);
                setLocale("es", refresh);
                finish();
            }
        });



        rb_2p.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setPlayers();
            }
        });

        rb_3p.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setPlayers();
            }
        });

        cb_20hp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                cb_20hp.setChecked(true);
                cb_30hp.setChecked(false);
                cb_40hp.setChecked(false);
                setHp("20");
            }
        });
        cb_30hp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                cb_20hp.setChecked(false);
                cb_30hp.setChecked(true);
                cb_40hp.setChecked(false);
                setHp("30");
            }
        });
        cb_40hp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                cb_20hp.setChecked(false);
                cb_30hp.setChecked(false);
                cb_40hp.setChecked(true);
                setHp("40");
            }
        });


        cb_45s.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                cb_45s.setChecked(true);
                cb_60s.setChecked(false);
                cb_90s.setChecked(false);
                setTimer("45");
            }
        });
        cb_60s.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                cb_45s.setChecked(false);
                cb_60s.setChecked(true);
                cb_90s.setChecked(false);
                setTimer("60");
            }
        });
        cb_90s.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                cb_45s.setChecked(false);
                cb_60s.setChecked(false);
                cb_90s.setChecked(true);
                setTimer("90");
            }
        });



        cb_show_counters.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(preferencias.getContadores().equals("on")){
                    cb_show_counters.setChecked(false);
                    preferencias.salvarContadores("off");
                }else{
                    cb_show_counters.setChecked(true);
                    preferencias.salvarContadores("on");
                }
            }
        });





        try {
            PackageInfo pInfo = this.getPackageManager().getPackageInfo(getPackageName(), 0);
            String version = pInfo.versionName;
            txt_configVersion.setText(getString(R.string.versao) + version);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        bt_sugestoes = findViewById(R.id.btn_donate);

        bt_sugestoes.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(ConfigActivity.this, SugestoesActivity.class));
            }
        });

        bt_mana_base = findViewById(R.id.bt_mana_base);

        bt_mana_base.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                startActivity(new Intent(ConfigActivity.this, ManaBaseCalculatorActivity.class));
            }
        });


    }

    private void buscarPreferencias() {


        if(preferencias.getContadores().equals("off")){
            cb_show_counters.setChecked(false);
        }
        else{
            cb_show_counters.setChecked(true);
        }

        if(preferencias.getChavePlayers().equals("2")){
            rb_2p.setChecked(true);
            rb_3p.setChecked(false);
        }
        else if(preferencias.getChavePlayers().equals("3")){
            rb_2p.setChecked(false);
            rb_3p.setChecked(true);
        }

        if(preferencias.getChaveQtdeHP().equals("20")){
            cb_20hp.setChecked(true);
            cb_30hp.setChecked(false);
            cb_40hp.setChecked(false);
        }
        else if(preferencias.getChaveQtdeHP().equals("30")){
            cb_20hp.setChecked(false);
            cb_30hp.setChecked(true);
            cb_40hp.setChecked(false);
        }
        else if(preferencias.getChaveQtdeHP().equals("40")){
            cb_20hp.setChecked(false);
            cb_30hp.setChecked(false);
            cb_40hp.setChecked(true);
        }

        if(preferencias.getChaveTimer().equals("45")){
            cb_45s.setChecked(true);
            cb_60s.setChecked(false);
            cb_90s.setChecked(false);
        }
        else if(preferencias.getChaveTimer().equals("60")){
            cb_45s.setChecked(false);
            cb_60s.setChecked(true);
            cb_90s.setChecked(false);
        }
        else if(preferencias.getChaveTimer().equals("90")){
            cb_45s.setChecked(false);
            cb_60s.setChecked(false);
            cb_90s.setChecked(true);
        }


        float fProgrees = Float.valueOf(preferencias.getTxtSize());
        int progress = (int) (fProgrees * 10);

        seekBar_txt_size.setProgress(progress);

        if(preferencias.getCHAVE_SOM().contentEquals("off")){
            aSwitchSom.setChecked(false);
        }else{
            aSwitchSom.setChecked(true);
        }


    }


    private void setPlayers(){

        if(rb_2p.isChecked()){
            preferencias.salvarPlayers("2");
        }
        else if(rb_3p.isChecked()){
            preferencias.salvarPlayers("3");
        }
    }

    private void setHp(String value){
         preferencias.salvarQtdeHP(value);
    }

    private void setTimer(String value){
        preferencias.salvarTimer(value);
    }

    public void setLocale(String lang, Intent intent) {

        Locale myLocale = new Locale(lang);
        Resources res = getResources();
        DisplayMetrics dm = res.getDisplayMetrics();
        Configuration conf = res.getConfiguration();
        conf.locale = myLocale;
        res.updateConfiguration(conf, dm);
        startActivity(intent);
        finish();
    }

    public void setTextSize(){
        float txt_size = Float.valueOf(preferencias.getTxtSize());
        textView_txt_size.setTextSize(txt_size * 40);
        rb_2p.setTextSize(txt_size * 40);
        rb_3p.setTextSize(txt_size * 40);
        cb_20hp.setTextSize(txt_size * 40);
        cb_30hp.setTextSize(txt_size * 40);
        cb_40hp.setTextSize(txt_size * 40);
        cb_45s.setTextSize(txt_size * 40);
        cb_60s.setTextSize(txt_size * 40);
        cb_90s.setTextSize(txt_size * 40);
        cb_show_counters.setTextSize(txt_size * 30);
//        bt_consulta_cards.setTextSize(txt_size * 30);
        bt_mana_base.setTextSize(txt_size * 30);
        bt_sugestoes.setTextSize(txt_size * 30);

    }



}
