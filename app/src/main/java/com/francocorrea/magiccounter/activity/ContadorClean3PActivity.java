package com.francocorrea.magiccounter.activity;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.francocorrea.magiccounter.R;
import com.francocorrea.magiccounter.helper.Preferencias;

import java.util.Locale;
import java.util.Random;

public class ContadorClean3PActivity extends AppCompatActivity {

    private int pontuacao_p1;
    private int pontuacao_p2;
    private int pontuacao_p3;
    private int intValorP1 = 0;
    private int intValorP2 = 0;
    private int intValorP3 = 0;
    private int rotacao_layout_p1 = 1;
    private int rotacao_layout_p2 = 1;
    private int rotacao_layout_p3 = 1;


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
    private ImageButton veneno_bg_p1;
    private LinearLayout bt_veneno_p1;
    private TextView veneno_p1;
    private ImageButton energia_bg_p1;
    private LinearLayout bt_energia_p1;
    private TextView energia_p1;

    //player 2
    private ImageButton change_bg_p2;
    private ImageButton veneno_bg_p2;
    private LinearLayout bt_veneno_p2;
    private Button fab2_mais1;
    private Button fab2_mais5;
    private Button fab2_menos1;
    private Button fab2_menos5;
    private TextView pontos_p2;
    private TextView veneno_p2;


    //player 3
    private ImageButton change_bg_p3;
    private ImageButton veneno_bg_p3;
    private LinearLayout bt_veneno_p3;
    private Button fab3_mais1;
    private Button fab3_mais5;
    private Button fab3_menos1;
    private Button fab3_menos5;
    private TextView pontos_p3;
    private TextView veneno_p3;
    private ImageButton energia_bg_p2;
    private LinearLayout bt_energia_p2;
    private TextView energia_p2;

    // UI
    private ImageButton bt_restart;
    private ImageButton bt_config;
    private TextView valorP1;
    private TextView valorP2;
    private TextView valorP3;

    private int num_players;
    Preferencias preferencias;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_contador_clean_3p);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

        preferencias = new Preferencias(ContadorClean3PActivity.this);
        num_players = Integer.parseInt(preferencias.getChavePlayers());

        Locale myLocale = new Locale(preferencias.getLingua());
        Resources res = getResources();
        DisplayMetrics dm = res.getDisplayMetrics();
        Configuration conf = res.getConfiguration();
        conf.locale = myLocale;
        res.updateConfiguration(conf, dm);

        if(num_players == 2){
            Intent i = new Intent(ContadorClean3PActivity.this, ContadorClean2PActivity.class);
            startActivity(i);
            finish();
        }


        //player 1
//        bt_rotete_lo_p1 = findViewById(r.id.bt_rotate_lo_p1);
        fab1_mais1 = findViewById(R.id.bt_p1_mais1);
        fab1_mais5 = findViewById(R.id.bt_p1_mais5);
        fab1_menos1 = findViewById(R.id.bt_p1_menos1);
        fab1_menos5 = findViewById(R.id.bt_p1_menos5);
        pontos_p1   = findViewById(R.id.pontuacao_p1);
        //veneno_bg_p1 = findViewById(r.id.bt_veneno_p1);
        //bt_veneno_p1 = findViewById(r.id.lo_veneno_p1);
        //veneno_p1 = findViewById(r.id.txt_veneno_p1);
        //energia_bg_p1 = findViewById(r.id.bt_energia_p1);
        //bt_energia_p1 = findViewById(r.id.lo_energia_p1);
        //energia_p1 = findViewById(r.id.txt_energia_p1);
        valorP1 = findViewById(R.id.txt_valor_mod_p1);


        //player 2
        fab2_mais1 = findViewById(R.id.bt_p2_mais1);
        fab2_mais5 = findViewById(R.id.bt_p2_mais5);
        fab2_menos1 = findViewById(R.id.bt_p2_menos1);
        fab2_menos5 = findViewById(R.id.bt_p2_menos5);
        pontos_p2   = findViewById(R.id.pontuacao_p2);
        //veneno_bg_p1 = findViewById(r.id.bt_veneno_p1);
        //bt_veneno_p1 = findViewById(r.id.lo_veneno_p1);
        //veneno_p1 = findViewById(r.id.txt_veneno_p1);
        //energia_bg_p1 = findViewById(r.id.bt_energia_p1);
        //bt_energia_p1 = findViewById(r.id.lo_energia_p1);
        //energia_p1 = findViewById(r.id.txt_energia_p1);
        valorP2 = findViewById(R.id.txt_valor_mod_p2);

        //player 3
        fab3_mais1 = findViewById(R.id.bt_p3_mais1);
        fab3_mais5 = findViewById(R.id.bt_p3_mais5);
        fab3_menos1 = findViewById(R.id.bt_p3_menos1);
        fab3_menos5 = findViewById(R.id.bt_p3_menos5);
        pontos_p3   = findViewById(R.id.pontuacao_p3);
        //veneno_bg_p1 = findViewById(r.id.bt_veneno_p1);
        //bt_veneno_p1 = findViewById(r.id.lo_veneno_p1);
        //veneno_p1 = findViewById(r.id.txt_veneno_p1);
        //energia_bg_p1 = findViewById(r.id.bt_energia_p1);
        //bt_energia_p1 = findViewById(r.id.lo_energia_p1);
        //energia_p1 = findViewById(r.id.txt_energia_p1);
        valorP3 = findViewById(R.id.txt_valor_mod_p3);


        //UI
        bt_restart = findViewById(R.id.imageButton_restart);
        bt_config = findViewById(R.id.imageButton_config);




        bt_restart.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                restartUI();
            }
        });

        bt_config.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(ContadorClean3PActivity.this, ConfigActivity.class));
            }
        });


        ImageButton bt_dado;
        bt_dado   = findViewById(R.id.imageButton_dados);
        bt_dado.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                rolarDado(20);
            }
        });


        esconderValorModificado();


        maxHP = pontuacao_p1 = pontuacao_p2 = pontuacao_p3 = Integer.parseInt(preferencias.getChaveQtdeHP());
        pontos_p1.setText(String.valueOf(pontuacao_p1));
        pontos_p2.setText(String.valueOf(pontuacao_p2));
        pontos_p3.setText(String.valueOf(pontuacao_p3));


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

        pontos_p3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pontuacao_p3 -= 1;
                setPontuacao(3, pontuacao_p3);
                setIntValorModPlayer( 3, -1);
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


        fab3_mais1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pontuacao_p3 += 1;
                setPontuacao(3, pontuacao_p3);
                setIntValorModPlayer( 3, 1);
            }
        });
        fab3_mais5.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pontuacao_p3 += 5;
                setPontuacao(3, pontuacao_p3);
                setIntValorModPlayer( 3, 5);
            }
        });
        fab3_menos1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pontuacao_p3 -= 1;
                setPontuacao(3, pontuacao_p3);
                setIntValorModPlayer( 3, -1);
            }
        });
        fab3_menos5.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pontuacao_p3 -= 5;
                setPontuacao(3, pontuacao_p3);
                setIntValorModPlayer( 3, -5);
            }
        });


    }


    private void restartUI() {


        final AlertDialog alerta;

        View view;
        view = LayoutInflater.from(ContadorClean3PActivity.this).inflate(R.layout.dialog_alerta, null);

        TextView txt_mensagem = view.findViewById(R.id.txt_mensagem_alerta);
        TextView txt_tirulo = view.findViewById(R.id.txt_titulo_alerta);
        Button bt_positivo  = view.findViewById(R.id.bt_alerta_positivo);
        Button bt_negativo  = view.findViewById(R.id.bt_alerta_negativo);

        txt_tirulo.setText((R.string.restart));
        txt_mensagem.setText(R.string.confirmacaoAlerta);
        txt_mensagem.setGravity(View.TEXT_ALIGNMENT_CENTER);


        //Cria o gerador do AlertDialog
        AlertDialog.Builder builder = new AlertDialog.Builder(ContadorClean3PActivity.this);

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
                maxHP = pontuacao_p1 = pontuacao_p2 = pontuacao_p3 = Integer.parseInt(preferencias.getChaveQtdeHP());
                intValorP1 = intValorP2 = intValorP3 = 0;
//                intValorEnergiaP1 = intValorEnergiaP2 = 0;
//                intValorVenenoP1 = intValorVenenoP2 = 0;
                esconderValorModificado();
                pontos_p1.setText(String.valueOf(pontuacao_p1));
                pontos_p2.setText(String.valueOf(pontuacao_p2));
                pontos_p3.setText(String.valueOf(pontuacao_p3));
//                txt_energia_p1.setText(String.valueOf(intValorP1));
//                txt_energia_p2.setText(String.valueOf(intValorP1));
//                txt_veneno_p1.setText(String.valueOf(intValorP1));
//                txt_veneno_p2.setText(String.valueOf(intValorP1));

                pontos_p1.setBackground(null);
                pontos_p2.setBackground(null);
                pontos_p3.setBackground(null);
                alerta.dismiss();
            }
        });


    }

    private void esconderValorModificado() {

        valorP1.setTextColor(getResources().getColor(R.color.color_p1));
        valorP2.setTextColor(getResources().getColor(R.color.color_p2));
        valorP3.setTextColor(getResources().getColor(R.color.color_p3));

        try{
            valorP1.setShadowLayer(0,0,0, getResources().getColor(R.color.color_p1));
            valorP2.setShadowLayer(0,0,0, getResources().getColor(R.color.color_p2));
            valorP3.setShadowLayer(0,0,0, getResources().getColor(R.color.color_p3));
        }catch (Exception e){ // todo fix shadow problems

        }
    }

    private void setPontuacao(int player, int pontuacao) {
        if (player == 1) {
            pontos_p1.setText(String.valueOf(pontuacao));
            try {
                pontos_p1.setShadowLayer(5, 1, 1, getResources().getColor(R.color.browser_actions_text_color));
            }catch (Exception e){ // todo tratar erro

            }

        } else if (player == 2) {
            pontos_p2.setText(String.valueOf(pontuacao));
            try {
                pontos_p2.setShadowLayer(5, 1, 1, getResources().getColor(R.color.browser_actions_text_color));
            }catch (Exception e){ // todo tratar erro

            }
        }
        else{
            pontos_p3.setText(String.valueOf(pontuacao));
            try {
                pontos_p3.setShadowLayer(5, 1, 1, getResources().getColor(R.color.browser_actions_text_color));
            }catch (Exception e){ // todo tratar erro

            }
        }
        if(preferencias.getCHAVE_SOM().equals("on")) {
            final MediaPlayer btn_sound = MediaPlayer.create(ContadorClean3PActivity.this, R.raw.btn);
            btn_sound.start();
            btn_sound.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                public void onCompletion(MediaPlayer mp) {
                    mp.release();

                }

                ;
            });
        }

    }

    private void setIntValorModPlayer(int iPlayer, int valor) {

        if(iPlayer == 1) {

            intValorP1 += valor;

            if(intValorP1 >= 0)
            {
                valorP1.setTextColor(getResources().getColor(R.color.color_mais1));
                valorP1.setText("+" + String.valueOf(intValorP1));

                try{
                    startAnimation(valorP1);
                    valorP1.setShadowLayer(5,1,1, getResources().getColor(R.color.browser_actions_text_color));
                }catch (Exception e){
                    // todo fix shadow problems
                }

            }
            else
            {
                valorP1.setTextColor(getResources().getColor(R.color.color_menos1));
                valorP1.setText(String.valueOf(intValorP1));

                try{
                    startAnimation(valorP1);
                    valorP1.setShadowLayer(5,1,1, getResources().getColor(R.color.browser_actions_text_color));
                }catch (Exception e){
                    //todo fiz shadow problems
                }
            }

        }

        else if(iPlayer == 2) {

            intValorP2 += valor;

            if(intValorP2 >= 0) {
                valorP2.setTextColor(getResources().getColor(R.color.color_mais1));
                valorP2.setText("+" + String.valueOf(intValorP2));

                try{
                    startAnimation(valorP2);
                    valorP2.setShadowLayer(5,1,1, getResources().getColor(R.color.browser_actions_text_color));
                }catch (Exception e){
                    // todo fiz shadow problems
                }
            }
            else{
                valorP2.setTextColor(getResources().getColor(R.color.color_menos1));
                valorP2.setText(String.valueOf(intValorP2));

                try{
                    startAnimation(valorP2);
                    valorP2.setShadowLayer(5,1,1, getResources().getColor(R.color.browser_actions_text_color));
                }catch (Exception e){
                    // todo fix shadow problems
                }
            }

        }
        else if(iPlayer == 3) {

            intValorP3 += valor;

            if(intValorP3 >= 0) {
                valorP3.setTextColor(getResources().getColor(R.color.color_mais1));
                valorP3.setText("+" + String.valueOf(intValorP3));
                try{
                    startAnimation(valorP3);
                    valorP3.setShadowLayer(5,1,1, getResources().getColor(R.color.browser_actions_text_color));
                }catch (Exception e){

                }
            }
            else{
                valorP3.setTextColor(getResources().getColor(R.color.color_menos1));
                valorP3.setText(String.valueOf(intValorP3));
                try{
                    startAnimation(valorP3);
                    valorP3.setShadowLayer(5,1,1, getResources().getColor(R.color.browser_actions_text_color));
                }catch (Exception e){

                }
            }

        }
        countDown();
    }
    private void startAnimation(TextView player_txt) {
        Animation animation = AnimationUtils.loadAnimation(this, R.anim.anim_scale);
        player_txt.startAnimation(animation);
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
                    intValorP1 = intValorP2 = intValorP3 = 0;
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
                    intValorP1 = intValorP2 = intValorP3 = 0;
                    esconderValorModificado();
                }

            }.start();

        }
    }

    @Override
    protected void onRestart() {
        super.onRestart();

        num_players = Integer.parseInt(preferencias.getChavePlayers());
        int smaxHP = Integer.parseInt(preferencias.getChaveQtdeHP());

        if(maxHP != smaxHP){
            restartUI();
        }

        if(num_players == 2){
            Intent i = new Intent(ContadorClean3PActivity.this, ContadorClean2PActivity.class);
            startActivity(i);
            finish();
        }

//        if(preferencias.getVeneno().equals("off")){
//            bt_veneno_p1.setVisibility(View.GONE);
//            bt_veneno_p2.setVisibility(View.GONE);
//            bt_veneno_p3.setVisibility(View.GONE);
//
//        }else{
//            bt_veneno_p1.setVisibility(View.VISIBLE);
//            bt_veneno_p2.setVisibility(View.VISIBLE);
//            bt_veneno_p3.setVisibility(View.VISIBLE);
//        }
//        if(preferencias.getContadores().equals("off")){
//            bt_energia_p1.setVisibility(View.GONE);
//            bt_energia_p2.setVisibility(View.GONE);
//           // bt_energia_p3.setVisibility(View.GONE);
//
//        }else{
//            bt_energia_p1.setVisibility(View.VISIBLE);
//            bt_energia_p2.setVisibility(View.VISIBLE);
//         //   bt_energia_p3.setVisibility(View.VISIBLE);
//        }
    }

    private void rolarDado(final int lados){

        AlertDialog alerta;

        View view;
        view = LayoutInflater.from(ContadorClean3PActivity.this).inflate(R.layout.dialog_d20, null);

        final TextView txt_resultado_p1  = view.findViewById(R.id.resultado_d20_p1);
        final TextView txt_resultado_p2  = view.findViewById(R.id.resultado_d20_p2);
        final TextView txt_vencedor  = view.findViewById(R.id.txt_vencedor);


        //Cria o gerador do AlertDialog
        AlertDialog.Builder builder = new AlertDialog.Builder(ContadorClean3PActivity.this);

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

            }

        }.start();


        if(preferencias.getCHAVE_SOM().equals("on")) {
            final MediaPlayer dice_sound = MediaPlayer.create(ContadorClean3PActivity.this, R.raw.dice_shake);
            dice_sound.start();
            dice_sound.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                public void onCompletion(MediaPlayer mp) {
                    mp.release();

                }

                ;
            });
        }

    }



}
