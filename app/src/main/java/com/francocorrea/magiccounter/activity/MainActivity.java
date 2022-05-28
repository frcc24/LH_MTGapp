package com.francocorrea.magiccounter.activity;

import android.content.Intent;

import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;

import java.util.Locale;

import android.content.res.Configuration;
import android.content.res.Resources;
import android.util.DisplayMetrics;


import com.francocorrea.magiccounter.R;
import com.francocorrea.magiccounter.helper.Preferencias;

public class MainActivity extends AppCompatActivity {


    //todo gerar uma splashScreen
    Preferencias preferencias;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        Intent i = new Intent(MainActivity.this, NovaTelaInicialActivity.class);
        startActivity(i);
        finish();

        preferencias = new Preferencias(MainActivity.this);

        Locale myLocale = new Locale(preferencias.getLingua());
        Resources res = getResources();
        DisplayMetrics dm = res.getDisplayMetrics();
        Configuration conf = res.getConfiguration();
        conf.locale = myLocale;
        res.updateConfiguration(conf, dm);



//        bt_veneno_p1.setOnLongClickListener(new View.OnLongClickListener() {
//            @Override
//            public boolean onLongClick(View v) {
//                veneno_p1.setText("0");
//                return true;
//            }
//        });
//
//        veneno_bg_p1.setOnLongClickListener(new View.OnLongClickListener() {
//            @Override
//            public boolean onLongClick(View v) {
//                veneno_p1.setText("0");
//                return true;
//            }
//        });
//        veneno_bg_p2.setOnLongClickListener(new View.OnLongClickListener() {
//            @Override
//            public boolean onLongClick(View v) {
//                veneno_p2.setText("0");
//                return true;
//            }
//        });
//
//        bt_veneno_p1.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                incrementaVenenoP1();
//            }
//        });
//        veneno_bg_p1.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                incrementaVenenoP1();
//            }
//        });
//
//        bt_veneno_p2.setOnLongClickListener(new View.OnLongClickListener() {
//            @Override
//            public boolean onLongClick(View v) {
//                veneno_p2.setText("0");
//                return true;
//            }
//        });
//        bt_veneno_p2.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                incrementaVenenoP2();
//            }
//        });
//        veneno_bg_p2.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                incrementaVenenoP2();
//            }
//        });
//
//        bt_energia_p1.setOnLongClickListener(new View.OnLongClickListener() {
//            @Override
//            public boolean onLongClick(View v) {
//                energia_p1.setText("0");
//                return true;
//            }
//        });
//
//        energia_bg_p1.setOnLongClickListener(new View.OnLongClickListener() {
//            @Override
//            public boolean onLongClick(View v) {
//                energia_p1.setText("0");
//                return true;
//            }
//        });
//        energia_bg_p2.setOnLongClickListener(new View.OnLongClickListener() {
//            @Override
//            public boolean onLongClick(View v) {
//                energia_p2.setText("0");
//                return true;
//            }
//        });
//
//        bt_energia_p1.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                incrementaenergiaP1();
//            }
//        });
//        energia_bg_p1.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                incrementaenergiaP1();
//            }
//        });
//
//        bt_energia_p2.setOnLongClickListener(new View.OnLongClickListener() {
//            @Override
//            public boolean onLongClick(View v) {
//                energia_p2.setText("0");
//                return true;
//            }
//        });
//        bt_energia_p2.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                incrementaenergiaP2();
//            }
//        });
//        energia_bg_p2.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                incrementaenergiaP2();
//            }
//        });
//
//
//
//
//        bt_dice.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                rolarDado(20);
//            }
//
//
//        });


    }
//
//
//    private void rolarDado(final int lados){
//
//
//
//        String result = getString(r.string.resultado_dados) + " " +  lados + " " +  getString(r.string.lados);
//
//        Random random = new Random();
//
//        int resultado = random.nextInt(lados);
//
//
//        AlertDialog alerta;
//
//        View view;
//        view = LayoutInflater.from(MainActivity.this).inflate(r.layout.dialog_d20, null);
//
//        TextView txt_mensagem = view.findViewById(r.id.txt_mensagem_alerta);
//        TextView txt_titulo = view.findViewById(r.id.txt_titulo_alerta);
//        final TextView txt_resultado  = view.findViewById(r.id.resultado_d20);
//        ImageView img_dice = view.findViewById(r.id.img_dice);
//
//        txt_titulo.setText(r.string.titulo_rolagem_dados);
//        txt_mensagem.setText(result);
//        txt_resultado.setText(String.valueOf(resultado + 1));
//
//        txt_mensagem.setGravity(View.TEXT_ALIGNMENT_CENTER);
//
//        //Cria o gerador do AlertDialog
//        AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
//
//        // Inflate and set the layout for the dialog
//        // Pass null as the parent view because its going in the dialog layout
//        builder.setView(view);
//
//        img_dice.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                Random random = new Random();
//                int resultado = random.nextInt(lados);
//                txt_resultado.setText(String.valueOf(resultado + 1));
//            }
//        });
//
//        builder.setNegativeButton(r.string.voltar, new DialogInterface.OnClickListener() {
//            public void onClick(DialogInterface arg0, int arg1) {
//            }
//        });
//        //cria o AlertDialog
//        alerta = builder.create();
//        //Exibe
//        alerta.show();
//    }
//
//
//
//
//    private void incrementaVenenoP1(){
//        String sveneno_p1 = veneno_p1.getText().toString();
//        int iveneno_p1    = Integer.parseInt(sveneno_p1);
//        iveneno_p1+=1;
//        veneno_p1.setText(String.valueOf(iveneno_p1));
//    }
//
//    private void incrementaVenenoP2(){
//        String sveneno_p2 = veneno_p2.getText().toString();
//        int iveneno_p2    = Integer.parseInt(sveneno_p2);
//        iveneno_p2+=1;
//        veneno_p2.setText(String.valueOf(iveneno_p2));
//    }
//
//    private void incrementaenergiaP1(){
//        String senergia_p1 = energia_p1.getText().toString();
//        int ienergia_p1    = Integer.parseInt(senergia_p1);
//        ienergia_p1+=1;
//        energia_p1.setText(String.valueOf(ienergia_p1));
//    }
//
//    private void incrementaenergiaP2(){
//        String senergia_p2 = energia_p2.getText().toString();
//        int ienergia_p2    = Integer.parseInt(senergia_p2);
//        ienergia_p2+=1;
//        energia_p2.setText(String.valueOf(ienergia_p2));
//    }
//
//

}
