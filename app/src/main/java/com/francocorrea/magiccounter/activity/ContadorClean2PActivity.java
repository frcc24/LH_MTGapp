package com.francocorrea.magiccounter.activity;


import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.animation.ObjectAnimator;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import com.francocorrea.magiccounter.R;
import com.francocorrea.magiccounter.helper.Preferencias;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Random;

/**
 * An example full-screen activity that shows and hides the system UI (i.e.
 * status bar and navigation/system bar) with user interaction.
 */
public class ContadorClean2PActivity extends AppCompatActivity {

    private int pontuacao_p1;
    private int pontuacao_p2;
    private int intValorP1 = 0;
    private int intValorP2 = 0;

    private int intValorVenenoP1 = 0;
    private int intValorVenenoP2 = 0;

    private int intValorEnergiaP1 = 0;
    private int intValorEnergiaP2 = 0;

    private int rotacao_layout_p1 = 1;
    private int rotacao_layout_p2 = 1;


    private CountDownTimer txt_valor_timer;

    private int maxHP;

    //player 1
    private ImageButton change_bg_p1;
    private Button fab1_mais1;
    private Button fab1_mais5;
    private Button fab1_menos1;
    private Button fab1_menos5;
    private Button bt_rotete_lo_p1;
    private TextView pontos_p1;
    private LinearLayout contadores_p1;

    private TextView txt_veneno_p1;
    private Button bt_veneno_mais_p1;
    private Button bt_veneno_menos_p1;

    private TextView txt_energia_p1;
    private Button bt_energia_mais_p1;
    private Button bt_energia_menos_p1;



    //player 2
    private ImageButton change_bg_p2;
    private Button fab2_mais1;
    private Button fab2_mais5;
    private Button fab2_menos1;
    private Button fab2_menos5;
    private TextView pontos_p2;
    private TextView valorP1;
    private TextView valorP2;
    private LinearLayout contadores_p2;

    private TextView txt_veneno_p2;
    private Button bt_veneno_mais_p2;
    private Button bt_veneno_menos_p2;

    private TextView txt_energia_p2;
    private Button bt_energia_mais_p2;
    private Button bt_energia_menos_p2;


    // util
    Preferencias preferencias;
    CountDownTimer timer_turno;


    // UI
    private ImageButton bt_restart;
    private ImageButton bt_config;
    private ImageButton bt_config2;
    private ImageButton bt_dado;
    private ImageButton bt_tempo;
    private ProgressBar progressBar;

    LinearLayout lo_menu ;
    private int num_players;
    private float txt_size;
    private TextView lo_fixer_p1;
    private TextView lo_fixer_p2;

    private Handler mHandler = new Handler();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_contador_clean_2p);

        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);


        preferencias = new Preferencias(ContadorClean2PActivity.this);
        num_players  = Integer.parseInt(preferencias.getChavePlayers());
        txt_size     = Float.parseFloat(preferencias.getTxtSize());


        Locale myLocale = new Locale(preferencias.getLingua());
        Resources res = getResources();
        DisplayMetrics dm = res.getDisplayMetrics();
        Configuration conf = res.getConfiguration();
        conf.locale = myLocale;
        res.updateConfiguration(conf, dm);

        if(num_players == 3){
            Intent i2 = new Intent(ContadorClean2PActivity.this, ContadorClean3PActivity.class);
            startActivity(i2);
            finish();
        }



        //player 1
       // bt_rotete_lo_p1 = findViewById(r.id.bt_rotate_lo_p1);
        fab1_mais1 = findViewById(R.id.bt_p1_mais1);
        fab1_mais1.setTextSize(80 * txt_size);

        fab1_mais5 = findViewById(R.id.bt_p1_mais5);
        fab1_menos1 = findViewById(R.id.bt_p1_menos1);
        fab1_menos5 = findViewById(R.id.bt_p1_menos5);
        pontos_p1   = findViewById(R.id.pontuacao_p1);
        valorP1 = findViewById(R.id.txt_valor_mod_p1);
        contadores_p1 = findViewById(R.id.lo_contadores_p1);
        lo_fixer_p1 = findViewById(R.id.lo_fixer_p1);

        txt_veneno_p1 = findViewById(R.id.txt_valor_veneno_p1);
        txt_energia_p1 = findViewById(R.id.txt_valor_energia_p1);

        bt_veneno_mais_p1 = findViewById(R.id.bt_veneno_mais_p1);
        bt_veneno_menos_p1 = findViewById(R.id.bt_veneno_menos_p1);
        bt_energia_mais_p1 = findViewById(R.id.bt_energia_mais_p1);
        bt_energia_menos_p1 = findViewById(R.id.bt_energia_menos_p1);


        //player 2
        fab2_mais1 = findViewById(R.id.bt_p2_mais1);
        fab2_mais5 = findViewById(R.id.bt_p2_mais5);
        fab2_menos1 = findViewById(R.id.bt_p2_menos1);
        fab2_menos5 = findViewById(R.id.bt_p2_menos5);
        pontos_p2   = findViewById(R.id.pontuacao_p2);
        valorP2 = findViewById(R.id.txt_valor_mod_p2);
        contadores_p2 = findViewById(R.id.lo_contadores_p2);
        lo_fixer_p2 = findViewById(R.id.lo_fixer_p2);

        txt_veneno_p2 = findViewById(R.id.txt_valor_veneno_p2);
        txt_energia_p2 = findViewById(R.id.txt_valor_energia_p2);

        bt_veneno_mais_p2 = findViewById(R.id.bt_veneno_mais_p2);
        bt_veneno_menos_p2 = findViewById(R.id.bt_veneno_menos_p2);
        bt_energia_mais_p2 = findViewById(R.id.bt_energia_mais_p2);
        bt_energia_menos_p2 = findViewById(R.id.bt_energia_menos_p2);


        bt_veneno_mais_p1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                intValorVenenoP1+= 1;
                txt_veneno_p1.setText(String.valueOf(intValorVenenoP1));
            }
        });
        bt_veneno_menos_p1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                intValorVenenoP1-= 1;
                txt_veneno_p1.setText(String.valueOf(intValorVenenoP1));
            }
        });
        bt_veneno_mais_p2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                intValorVenenoP2+= 1;
                txt_veneno_p2.setText(String.valueOf(intValorVenenoP2));
            }
        });
        bt_veneno_menos_p2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                intValorVenenoP2-= 1;
                txt_veneno_p2.setText(String.valueOf(intValorVenenoP2));
            }
        });

        bt_energia_mais_p1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                intValorEnergiaP1+= 1;
                txt_energia_p1.setText(String.valueOf(intValorEnergiaP1));
            }
        });
        bt_energia_menos_p1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                intValorEnergiaP1-= 1;
                txt_energia_p1.setText(String.valueOf(intValorEnergiaP1));
            }
        });
        bt_energia_mais_p2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                intValorEnergiaP2+= 1;
                txt_energia_p2.setText(String.valueOf(intValorEnergiaP2));
            }
        });
        bt_energia_menos_p2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                intValorEnergiaP2-= 1;
                txt_energia_p2.setText(String.valueOf(intValorEnergiaP2));
            }
        });




        //UI
        bt_restart = findViewById(R.id.imageButton_restart);
        bt_config  = findViewById(R.id.imageButton_config);
        bt_config2  = findViewById(R.id.imageButton_config_2);
        bt_dado    = findViewById(R.id.imageButton_dados);
        bt_tempo   = findViewById(R.id.imageButton_tempo);
        lo_menu    = findViewById(R.id.lo_menu);


        bt_tempo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                iniciaContagemTempo();
            }
        });

        bt_restart.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                restartUI();
            }
        });

        bt_dado.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                rolarDado(20);
            }
        });

        bt_config.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                bt_config2.setVisibility(View.GONE);
                startActivity(new Intent(ContadorClean2PActivity.this, ConfigActivity.class));
            }
        });

        bt_config2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                lo_menu.setVisibility(View.VISIBLE);
                flipItHorizontal(lo_menu);
                bt_config2.setVisibility(View.GONE);

            }
        });



        esconderValorModificado();

        maxHP = pontuacao_p1 = pontuacao_p2 = Integer.parseInt(preferencias.getChaveQtdeHP());
        pontos_p1.setText(String.valueOf(pontuacao_p1));
        pontos_p2.setText(String.valueOf(pontuacao_p2));

        if(preferencias.getContadores().equals("off")){
            contadores_p1.setVisibility(View.GONE);
            contadores_p2.setVisibility(View.GONE);
            lo_fixer_p1.setVisibility(View.VISIBLE);
            lo_fixer_p2.setVisibility(View.VISIBLE);
        }else{
            contadores_p1.setVisibility(View.VISIBLE);
            contadores_p2.setVisibility(View.VISIBLE);
            lo_fixer_p1.setVisibility(View.GONE);
            lo_fixer_p2.setVisibility(View.GONE);
        }

//      //todo rotacionar telas
//        bt_rotete_lo_p1.setOnClickListener(new View.OnClickListener() {
//            @Override public void onClick(View v) {
//                rotacao_layout_p1 += 1;
//                if(rotacao_layout_p1 <=3)
//                    rotateLayout(1, rotacao_layout_p1);
//                else{
//                    rotacao_layout_p1 = 1;
//                    rotateLayout(1, rotacao_layout_p1);
//                }
//
//            }
//        });

        pontos_p1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pontuacao_p1 -= 1;
                setPontuacao(1, pontuacao_p1);
                setIntValorModPlayer(1, -1);
            }
        });


        pontos_p2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pontuacao_p2 -= 1;
                setPontuacao(2, pontuacao_p2);
                setIntValorModPlayer( 2, -1);
            }
        });

        fab1_mais1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pontuacao_p1 += 1;
                setPontuacao(1, pontuacao_p1);
                setIntValorModPlayer( 1, 1);
            }
        });
        fab1_mais5.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pontuacao_p1 += 5;
                setPontuacao(1, pontuacao_p1);
                setIntValorModPlayer( 1, 5);
            }
        });
        fab1_menos1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pontuacao_p1 -= 1;
                setPontuacao(1, pontuacao_p1);
                setIntValorModPlayer( 1, -1);
            }
        });
        fab1_menos5.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pontuacao_p1 -= 5;
                setPontuacao(1, pontuacao_p1);
                setIntValorModPlayer( 1, -5);
            }
        });


        fab2_mais1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pontuacao_p2 += 1;
                setPontuacao(2, pontuacao_p2);
                setIntValorModPlayer( 2, 1);
            }
        });
        fab2_mais5.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pontuacao_p2 += 5;
                setPontuacao(2, pontuacao_p2);
                setIntValorModPlayer( 2, 5);
            }
        });
        fab2_menos1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pontuacao_p2 -= 1;
                setPontuacao(2, pontuacao_p2);
                setIntValorModPlayer( 2, -1);
            }
        });
        fab2_menos5.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
               pontuacao_p2 -= 5;
               setPontuacao(2, pontuacao_p2);
               setIntValorModPlayer( 2, -5);
            }
        });

        setTxtSize();

    }

    private void iniciaContagemTempo() {
        hideMenubar();
        final AlertDialog alerta;

        final MediaPlayer ticking_sound = MediaPlayer.create(ContadorClean2PActivity.this, R.raw.ticking_countdown);
        final MediaPlayer explode_sound = MediaPlayer.create(ContadorClean2PActivity.this, R.raw.explode);

        ticking_sound.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
            public void onCompletion(MediaPlayer mp) {
                mp.release();

            };
        });
        explode_sound.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
            public void onCompletion(MediaPlayer mp) {
                mp.release();

            };
        });

        View view;
        view = LayoutInflater.from(ContadorClean2PActivity.this).inflate(R.layout.dialog_tempo, null);

        final TextView txt_mensagem = view.findViewById(R.id.txt_mensagem_alerta);
        progressBar = view.findViewById(R.id.progressBarTempo);
        TextView txt_tirulo = view.findViewById(R.id.txt_titulo_alerta);
        final ImageView imageViewAlertaTempo = view.findViewById(R.id.imageViewAlertaTempo);
        Button bt_positivo  = view.findViewById(R.id.bt_alerta_positivo);
        bt_positivo.setText(R.string.voltar);
        Button bt_negativo  = view.findViewById(R.id.bt_alerta_negativo);
        bt_negativo.setVisibility(View.GONE);

        //inicia contagem regressiva
        final int tempo_total = Integer.parseInt(preferencias.getChaveTimer())*1000;
        final int tempo_intervalo = 1000; //1 segundos
        progressBar.setMax(tempo_total/tempo_intervalo);

        if(timer_turno != null){
            timer_turno.cancel();
            timer_turno = null;
        }

        timer_turno = new CountDownTimer(tempo_total, tempo_intervalo) {

            public void onTick(long millisUntilFinished) {
                final int time_segundos = (int) millisUntilFinished / tempo_intervalo;
                flipItVertical(imageViewAlertaTempo);
                txt_mensagem.setText("Tempo Restante: " + time_segundos + " segundos");

                mHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        if(preferencias.getCHAVE_SOM().equals("on")) {
                            if (time_segundos == 14) {
                                ticking_sound.start();
                            }
                            if (time_segundos == 0) {
                                explode_sound.start();
                            }
                        }
                        progressBar.setProgress(time_segundos);
                    }
                }) ;
            }

            public void onFinish() {
                txt_mensagem.setText("Tempo Esgotado!");

            }

        }.start();


        txt_tirulo.setText(("Em desenvolvimento!"));
        //txt_mensagem.setText(R.string.confirmacaoAlerta);
        txt_mensagem.setGravity(View.TEXT_ALIGNMENT_CENTER);


        //Cria o gerador do AlertDialog
        AlertDialog.Builder builder = new AlertDialog.Builder(ContadorClean2PActivity.this);

        // Inflate and set the layout for the dialog
        // Pass null as the parent view because its going in the dialog layout
        builder.setView(view);
        //cria o AlertDialog
        alerta = builder.create();
        //Exibe
        alerta.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        alerta.show();

        bt_positivo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                timer_turno.cancel();

                try {
                    ticking_sound.stop();
                    explode_sound.stop();
                }catch (IllegalStateException e){
                    //todo ver se precisa corrigir algo nesse erro
                }
                alerta.dismiss();
            }
        });

    }

    private void esconderValorModificado() {
        valorP1.setTextColor(getResources().getColor(R.color.color_p1));
        valorP2.setTextColor(getResources().getColor(R.color.color_p2));

        try {
            valorP1.setShadowLayer(0, 0, 0, getResources().getColor(R.color.color_p1));
            valorP2.setShadowLayer(0, 0, 0, getResources().getColor(R.color.color_p2));
        }catch (Exception e){ // todo tratar erro

        }
    }

    private void setPontuacao(int player, int pontuacao) {

        if(lo_menu.getVisibility() == View.VISIBLE)
            hideMenubar();

        if (player == 1) {
            pontos_p1.setText(String.valueOf(pontuacao));
            try {
                pontos_p1.setShadowLayer(5, 1, 1, getResources().getColor(R.color.browser_actions_text_color));
            }catch (Exception e){ // todo tratar erro

            }

        } else {
            pontos_p2.setText(String.valueOf(pontuacao));
            try {
                pontos_p2.setShadowLayer(5, 1, 1, getResources().getColor(R.color.browser_actions_text_color));
            }catch (Exception e){ // todo tratar erro

            }

        }

        if(preferencias.getCHAVE_SOM().equals("on")) {
            final MediaPlayer btn_sound = MediaPlayer.create(ContadorClean2PActivity.this, R.raw.btn);
            btn_sound.start();
            btn_sound.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                public void onCompletion(MediaPlayer mp) {
                    mp.release();

                }

                ;
            });
        }
    }

    private void rotateLayout(int layout, int position) {
        if (layout == 1) {
            LinearLayout mainLayout1 = (LinearLayout) findViewById(R.id.lo_p1);
            LinearLayout mainLayout2 = (LinearLayout) findViewById(R.id.lo_p2);
            int lo_p1_w = mainLayout1.getWidth();
            int lo_p2_w = mainLayout2.getHeight();
            int lo_p1_h = mainLayout1.getWidth();
            int lo_p2_h = mainLayout2.getHeight();

            if(position == 1)
            {
                mainLayout1.setRotation(00.0f);
                mainLayout2.setRotation(00.0f);
            }
            if(position == 2)
            {
                mainLayout1.setRotation(90.0f);
                mainLayout2.setRotation(270.0f);
            }
            if(position == 3)
            {
                mainLayout1.setRotation(180.0f);
                mainLayout2.setRotation(00.0f);
            }

            mainLayout1.requestLayout();
            mainLayout2.requestLayout();
        }
    }


    private void setIntValorModPlayer(int iPlayer, int valor) {


        if(iPlayer == 1) {

            intValorP1 += valor;

            if(intValorP1 >= 0)
            {
                valorP1.setTextColor(getResources().getColor(R.color.color_mais1));
                valorP1.setText("+" + String.valueOf(intValorP1));

                try {
                    startAnimation(valorP1);
                    valorP1.setShadowLayer(5, 1, 1, getResources().getColor(R.color.browser_actions_text_color));
                }catch (Exception e){// todo tratar erro sombras

                }

            }
            else
            {
                valorP1.setTextColor(getResources().getColor(R.color.color_menos1));
                valorP1.setText(String.valueOf(intValorP1));

                try{
                    startAnimation(valorP1);
                    valorP1.setShadowLayer(5,1,1, getResources().getColor(R.color.browser_actions_text_color));
                }catch (Exception e){ //todo tratar erro das sombras

                }
            }

        }

        if(iPlayer == 2) {

            intValorP2 += valor;

            if(intValorP2 >= 0) {
                valorP2.setTextColor(getResources().getColor(R.color.color_mais1));
                valorP2.setText("+" + String.valueOf(intValorP2));

                try{
                    startAnimation(valorP2);
                    valorP2.setShadowLayer(5,1,1, getResources().getColor(R.color.browser_actions_text_color));
                }catch (Exception e){

                }
            }
            else{
                valorP2.setTextColor(getResources().getColor(R.color.color_menos1));
                valorP2.setText(String.valueOf(intValorP2));
                try{
                    startAnimation(valorP2);
                    valorP2.setShadowLayer(5,1,1, getResources().getColor(R.color.browser_actions_text_color));
                }catch (Exception e){

                }
            }

        }


        countDown();


    }

    private void startAnimation(TextView player_txt) {
        Animation animation = AnimationUtils.loadAnimation(this, R.anim.anim_scale);
//        overridePendingTransition( R.anim.anim_translate,  R.anim.anim_rotate);
        player_txt.startAnimation(animation);



    }

    private void flipItHorizontal(final View viewToFlip) {
        try {
            ObjectAnimator flip = ObjectAnimator.ofFloat(viewToFlip, "rotationY", 0f, 360f);
            flip.setDuration(200);
            flip.start();
        }catch (Exception e){

        }
    }

    private void flipItVertical(final View viewToFlip) {
        try {
            ObjectAnimator flip = ObjectAnimator.ofFloat(viewToFlip, "rotationX", 00f, 360f);
            flip.setDuration(200);
            flip.start();
        }catch (Exception e){

        }
    }

    private void countDown() {

        if(txt_valor_timer  == null ) {
            txt_valor_timer = new CountDownTimer(1000, 200) {

                public void onTick(long millisUntilFinished) {
                    //mTextField.setText("seconds remaining: " + millisUntilFinished / 1000);
                    //here you can have your logic to set text to edittext
                }

                public void onFinish() {
                    //mTextField.setText("done!");
                    intValorP1 = intValorP2 = 0;
                    esconderValorModificado();
                }

            }.start();
        }else
        {
            //para o timer antigo e comeca a contar de novo
            txt_valor_timer.cancel();
            txt_valor_timer = new CountDownTimer(3000, 1000) {

                public void onTick(long millisUntilFinished) {
                    //mTextField.setText("seconds remaining: " + millisUntilFinished / 1000);
                    //here you can have your logic to set text to edittext
                }

                public void onFinish() {
                    //mTextField.setText("done!");
                    intValorP1 = intValorP2 = 0;
                    esconderValorModificado();
                }

            }.start();

        }
    }


    private void restartUI() {
        hideMenubar();
        final AlertDialog alerta;

        View view;
        view = LayoutInflater.from(ContadorClean2PActivity.this).inflate(R.layout.dialog_alerta, null);

        TextView txt_mensagem = view.findViewById(R.id.txt_mensagem_alerta);
        TextView txt_tirulo = view.findViewById(R.id.txt_titulo_alerta);
        Button bt_positivo  = view.findViewById(R.id.bt_alerta_positivo);
        Button bt_negativo  = view.findViewById(R.id.bt_alerta_negativo);

        txt_tirulo.setText((R.string.restart));
        txt_mensagem.setText(R.string.confirmacaoAlerta);
        txt_mensagem.setGravity(View.TEXT_ALIGNMENT_CENTER);


        //Cria o gerador do AlertDialog
        AlertDialog.Builder builder = new AlertDialog.Builder(ContadorClean2PActivity.this);

        // Inflate and set the layout for the dialog
        // Pass null as the parent view because its going in the dialog layout
        builder.setView(view);
        //cria o AlertDialog
        alerta = builder.create();
        //Exibe
        alerta.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        alerta.show();

        bt_negativo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                alerta.dismiss();
            }
        });

        bt_positivo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                maxHP = pontuacao_p1 = pontuacao_p2 = Integer.parseInt(preferencias.getChaveQtdeHP());
                intValorP1 = intValorP2 = 0;
                intValorEnergiaP1 = intValorEnergiaP2 = 0;
                intValorVenenoP1 = intValorVenenoP2 = 0;
                esconderValorModificado();
                pontos_p1.setText(String.valueOf(pontuacao_p1));
                pontos_p2.setText(String.valueOf(pontuacao_p2));
                txt_energia_p1.setText(String.valueOf(intValorP1));
                txt_energia_p2.setText(String.valueOf(intValorP1));
                txt_veneno_p1.setText(String.valueOf(intValorP1));
                txt_veneno_p2.setText(String.valueOf(intValorP1));

                pontos_p1.setBackground(null);
                pontos_p2.setBackground(null);



                flipItHorizontal(pontos_p1);
                flipItHorizontal(pontos_p2);
                flipItHorizontal(lo_menu);

                if(preferencias.getCHAVE_SOM().equals("on")) {
                    final MediaPlayer restart_sound = MediaPlayer.create(ContadorClean2PActivity.this, R.raw.restart);
                    restart_sound.start();
                    restart_sound.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                        public void onCompletion(MediaPlayer mp) {
                            mp.release();

                        }

                        ;
                    });
                }
                alerta.dismiss();
            }
        });


    }

    @Override
    protected void onRestart() {
        super.onRestart();

        hideMenubar();



        Locale myLocale = new Locale(preferencias.getLingua());
        Resources res = getResources();
        DisplayMetrics dm = res.getDisplayMetrics();
        Configuration conf = res.getConfiguration();
        conf.locale = myLocale;
        res.updateConfiguration(conf, dm);

        num_players = Integer.parseInt(preferencias.getChavePlayers());
        int smaxHP = Integer.parseInt(preferencias.getChaveQtdeHP());

        setTxtSize();


        if(preferencias.getContadores().equals("off")){
            contadores_p1.setVisibility(View.GONE);
            contadores_p2.setVisibility(View.GONE);
            lo_fixer_p1.setVisibility(View.VISIBLE);
            lo_fixer_p2.setVisibility(View.VISIBLE);
        }else{
            contadores_p1.setVisibility(View.VISIBLE);
            contadores_p2.setVisibility(View.VISIBLE);
            lo_fixer_p1.setVisibility(View.GONE);
            lo_fixer_p2.setVisibility(View.GONE);
        }


        if(maxHP != smaxHP){
            restartUI();
        }
        if(num_players == 3){
            Intent i = new Intent(ContadorClean2PActivity.this, ContadorClean3PActivity.class);
            startActivity(i);
            finish();
        }




    }

    private void setTxtSize() {
        hideMenubar();
        //todo setar fontes para os tamanhos padroes
        float txt_size = Float.valueOf(preferencias.getTxtSize());

        fab1_mais1.setTextSize(txt_size * 40);
        fab1_mais5.setTextSize(txt_size * 40);
        fab1_menos1.setTextSize(txt_size * 40);
        fab1_menos5.setTextSize(txt_size * 40);

        valorP1.setTextSize(txt_size * 70);
        pontos_p1.setTextSize(txt_size * 250);
        //contadores_p1.setTextSize(txt_size * 40);

        txt_veneno_p1.setTextSize(txt_size * 40);
        bt_veneno_mais_p1.setTextSize(txt_size * 40);
        bt_veneno_menos_p1.setTextSize(txt_size * 40);

        txt_energia_p1.setTextSize(txt_size * 40);
        bt_energia_mais_p1.setTextSize(txt_size * 40);
        bt_energia_menos_p1.setTextSize(txt_size * 40);



        //player 2

        fab2_mais1.setTextSize(txt_size * 40);
        fab2_mais5.setTextSize(txt_size * 40);
        fab2_menos1.setTextSize(txt_size * 40);
        fab2_menos5.setTextSize(txt_size * 40);


        valorP2.setTextSize(txt_size * 70);
        pontos_p2.setTextSize(txt_size * 250);

//        contadores_p2.setTextSize(txt_size * 40);

        txt_veneno_p2.setTextSize(txt_size * 40);
        bt_veneno_mais_p2.setTextSize(txt_size * 40);
        bt_veneno_menos_p2.setTextSize(txt_size * 40);

        txt_energia_p2.setTextSize(txt_size * 40);
        bt_energia_mais_p2.setTextSize(txt_size * 40);
        bt_energia_menos_p2.setTextSize(txt_size * 40);

        // UI
//        bt_restart.setTextSize(txt_size * 40);
//        private ImageButton bt_config;
//        private ImageButton bt_dado;
//        LinearLayout lo_menu ;

        lo_fixer_p1.setTextSize(txt_size * 40);
        lo_fixer_p2.setTextSize(txt_size * 40);

    }

    private void rolarDado(final int lados){
        hideMenubar();

        AlertDialog alerta;

        View view;
        view = LayoutInflater.from(ContadorClean2PActivity.this).inflate(R.layout.dialog_d20, null);

        final TextView txt_resultado_p1  = view.findViewById(R.id.resultado_d20_p1);
        final TextView txt_resultado_p2  = view.findViewById(R.id.resultado_d20_p2);
        final TextView txt_vencedor  = view.findViewById(R.id.txt_vencedor);
        final ImageView imgWar  = view.findViewById(R.id.imageWar);
        final ImageView imgBalao  = view.findViewById(R.id.imgbalao);


        //Cria o gerador do AlertDialog
        AlertDialog.Builder builder = new AlertDialog.Builder(ContadorClean2PActivity.this);

        // Inflate and set the layout for the dialog
        // Pass null as the parent view because its going in the dialog layout
        builder.setView(view);

        //cria o AlertDialog
        alerta = builder.create();
        //Exibe
        alerta.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        alerta.show();



        new CountDownTimer(1000, 100) {
            int resultado1, resultado2 = 0;

            public void onTick(long millisUntilFinished) {
                Random random_p1 = new Random();
                resultado1 = random_p1.nextInt(lados);
                txt_resultado_p1.setText(String.valueOf(resultado1 + 1));

                Random random_p2 = new Random();
                resultado2 = random_p2.nextInt(lados);
                txt_resultado_p2.setText(String.valueOf(resultado2 + 1));

            }

            public void onFinish() {

                if(resultado1 == resultado2){
                    if(resultado1 >= 1)
                        resultado2 -= 1;
                    else
                        resultado2 += 1;
                    txt_resultado_p2.setText(String.valueOf(resultado2 + 1));
                }

                if(resultado1 > resultado2) {
                    txt_vencedor.setText("VENCEDOR Player1!"); // todo traduzir
                    txt_vencedor.setTextColor(getResources().getColor(R.color.color_p1));
                }else if (resultado1 < resultado2)
                {
                    txt_vencedor.setText("VENCEDOR Player2!"); // todo traduzir
                    txt_vencedor.setTextColor(getResources().getColor(R.color.color_p2));
                }


                txt_resultado_p1.setTextColor(getResources().getColor(R.color.color_p1));
                txt_resultado_p2.setTextColor(getResources().getColor(R.color.color_p2));
                imgWar.setVisibility(View.VISIBLE);
                imgBalao.setVisibility(View.VISIBLE);

            }

        }.start();


        if(preferencias.getCHAVE_SOM().equals("on")) {
            final MediaPlayer dice_sound = MediaPlayer.create(ContadorClean2PActivity.this, R.raw.dice_shake);
            dice_sound.start();
            dice_sound.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                public void onCompletion(MediaPlayer mp) {
                    mp.release();

                }

                ;
            });
        }

    }


    @Override
    public void onBackPressed() {

        final AlertDialog alerta;

        View view;
        view = LayoutInflater.from(ContadorClean2PActivity.this).inflate(R.layout.dialog_alerta, null);

        TextView txt_mensagem = view.findViewById(R.id.txt_mensagem_alerta);
        TextView txt_tirulo = view.findViewById(R.id.txt_titulo_alerta);
        Button bt_positivo  = view.findViewById(R.id.bt_alerta_positivo);
        Button bt_negativo  = view.findViewById(R.id.bt_alerta_negativo);

        txt_tirulo.setText("SAIR");
        txt_mensagem.setText("Deseja realmente sair?");
        txt_mensagem.setGravity(View.TEXT_ALIGNMENT_CENTER);


        //Cria o gerador do AlertDialog
        AlertDialog.Builder builder = new AlertDialog.Builder(ContadorClean2PActivity.this);

        // Inflate and set the layout for the dialog
        // Pass null as the parent view because its going in the dialog layout
        builder.setView(view);
        //cria o AlertDialog
        alerta = builder.create();
        //Exibe
        alerta.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        alerta.show();

        bt_negativo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                alerta.dismiss();
            }
        });

        bt_positivo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                alerta.dismiss();
                finish();
            }
        });


    }

    private void hideMenubar(){

        lo_menu.setVisibility(View.GONE);
        bt_config2.setVisibility(View.VISIBLE);
        flipItVertical(bt_config2);

    }
}
