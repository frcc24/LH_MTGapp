package com.francocorrea.magiccounter.activity;

import android.content.DialogInterface;
import android.content.res.Configuration;
import android.content.res.Resources;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.francocorrea.magiccounter.R;
import com.francocorrea.magiccounter.helper.Preferencias;

import java.util.Locale;

public class ManaBaseCalculatorActivity extends AppCompatActivity {

    private EditText mana_branca;
    private EditText mana_azul;
    private EditText mana_preta;
    private EditText mana_vermelha;
    private EditText mana_verde;
    private EditText total_terrenos;
    Preferencias preferencias;

    private Button bt_limpar;
    private Button bt_calcular;




    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_mana_base_calculator);
        preferencias = new Preferencias(ManaBaseCalculatorActivity.this);

        Locale myLocale = new Locale(preferencias.getLingua());
        Resources res = getResources();
        DisplayMetrics dm = res.getDisplayMetrics();
        Configuration conf = res.getConfiguration();
        conf.locale = myLocale;
        res.updateConfiguration(conf, dm);

        mana_branca = findViewById(R.id.editText_branca);
        mana_azul   = findViewById(R.id.editText_azul);
        mana_preta = findViewById(R.id.editText_preta);
        mana_vermelha = findViewById(R.id.editText_vermelha);
        mana_verde = findViewById(R.id.editText_verde);

        total_terrenos = findViewById(R.id.editText_total_terrenos);

        bt_limpar = findViewById(R.id.button_limpar);
        bt_calcular = findViewById(R.id.button_calcular);


        bt_limpar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mana_azul.setText("");
                mana_branca.setText("");
                mana_verde.setText("");
                mana_vermelha.setText("");
                mana_preta.setText("");
                total_terrenos.setText("");
            }
        });

        bt_calcular.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                double total_terrenos_deck = 0.0;
                double i_mana_branca= 0.0;
                double i_mana_azul= 0.0;
                double i_mana_preta= 0.0;
                double i_mana_vermelha= 0.0;
                double i_mana_verde= 0.0;

                if(!total_terrenos.getText().toString().equalsIgnoreCase(""))
                    total_terrenos_deck = Integer.parseInt(total_terrenos.getText().toString());

                if(!mana_branca.getText().toString().equalsIgnoreCase(""))
                    i_mana_branca       = Integer.parseInt(mana_branca.getText().toString());

                if(!mana_azul.getText().toString().equalsIgnoreCase(""))
                    i_mana_azul         = Integer.parseInt(mana_azul.getText().toString());

                if(!mana_preta.getText().toString().equalsIgnoreCase(""))
                    i_mana_preta        = Integer.parseInt(mana_preta.getText().toString());

                if(!mana_vermelha.getText().toString().equalsIgnoreCase(""))
                    i_mana_vermelha     = Integer.parseInt(mana_vermelha.getText().toString());

                if(!mana_verde.getText().toString().equalsIgnoreCase(""))
                    i_mana_verde        = Integer.parseInt(mana_verde.getText().toString());


                double i_total_mana_cost = i_mana_azul + i_mana_branca + i_mana_preta + i_mana_verde + i_mana_vermelha;

                double porcentagem_mana_branca  = i_mana_branca / i_total_mana_cost;
                double porcentagem_mana_azul    = i_mana_azul / i_total_mana_cost;
                double porcentagem_mana_preta   = i_mana_preta / i_total_mana_cost;
                double porcentagem_mana_vermelha= i_mana_vermelha/ i_total_mana_cost;
                double porcentagem_mana_verde   = i_mana_verde / i_total_mana_cost;

                double total_terrenos_brancos   = total_terrenos_deck * porcentagem_mana_branca;
                double total_terrenos_azuis     = total_terrenos_deck * porcentagem_mana_azul;
                double total_terrenos_pretos    = total_terrenos_deck * porcentagem_mana_preta;
                double total_terrenos_vermelhos = total_terrenos_deck * porcentagem_mana_vermelha;
                double total_terrenos_verdes   = total_terrenos_deck * porcentagem_mana_verde;

                total_terrenos_brancos = Math.round(total_terrenos_brancos*100)/100.0d;
                total_terrenos_azuis = Math.round(total_terrenos_azuis*100)/100.0d;
                total_terrenos_pretos = Math.round(total_terrenos_pretos*100)/100.0d;
                total_terrenos_vermelhos = Math.round(total_terrenos_vermelhos*100)/100.0d;
                total_terrenos_verdes = Math.round(total_terrenos_verdes*100)/100.0d;


                String result = getResources().getString(R.string.dos ) + " " + total_terrenos.getText().toString() + " " + getResources().getString(R.string.terrenos) +
                        "\n" + getResources().getString(R.string.terrenosBrancos )+ total_terrenos_brancos +
                        "\n" + getResources().getString(R.string.terrenosAzuis) + total_terrenos_azuis +
                        "\n" + getResources().getString( R.string.terrenosPretos) + total_terrenos_pretos +
                        "\n" + getResources().getString(R.string.terrenosVermelhos) + total_terrenos_vermelhos +
                        "\n" + getResources().getString(R.string.terrenosVerdes) + total_terrenos_verdes ;

                AlertDialog alerta;

                View view;
                view = LayoutInflater.from(ManaBaseCalculatorActivity.this).inflate(R.layout.dialog_alerta, null);

                TextView txt_mensagem = view.findViewById(R.id.txt_mensagem_alerta);
                TextView txt_tirulo = view.findViewById(R.id.txt_titulo_alerta);
                txt_tirulo.setText((R.string.numTerrenos));
                txt_mensagem.setText(result);
                txt_mensagem.setGravity(View.TEXT_ALIGNMENT_CENTER);

                //Cria o gerador do AlertDialog
                AlertDialog.Builder builder = new AlertDialog.Builder(ManaBaseCalculatorActivity.this);

                // Inflate and set the layout for the dialog
                // Pass null as the parent view because its going in the dialog layout
                builder.setView(view);

//                builder.setNegativeButton("Voltar", new DialogInterface.OnClickListener() {
//                    public void onClick(DialogInterface arg0, int arg1) {
//                    }
//                });
                //cria o AlertDialog
                alerta = builder.create();
                //Exibe
                alerta.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
                alerta.show();



            }
        });

    }
}
