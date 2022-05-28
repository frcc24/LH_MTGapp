package com.francocorrea.magiccounter.activity;

import android.content.Intent;
import android.os.AsyncTask;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.francocorrea.magiccounter.R;
import com.francocorrea.magiccounter.adapter.ListaCardsAdapter;
import com.francocorrea.magiccounter.model.MagicCard;

import java.util.ArrayList;
import java.util.List;

import io.magicthegathering.javasdk.api.CardAPI;
import io.magicthegathering.javasdk.resource.Card;

public class ConsultaCardsActivity extends AppCompatActivity {
    ImageView iv_card_img;
    List<Card> cards;
    ListView listView;
    List<String> filters;
    ProgressBar mProgressBar;
    ArrayAdapter adapter;
    String erro_da_busca = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_consulta_cards);

        mProgressBar = findViewById(R.id.progress_bar_listar_veic);
        exibirProgress(false);

        Button bt_pesquisar   = findViewById(R.id.bt_pesquisar);
        final EditText edt_pesquisa = findViewById(R.id.edt_pesquisa);
        listView = findViewById(R.id.lv_result_cards);


        cards = new ArrayList<>();


        bt_pesquisar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                String sPesquisa = edt_pesquisa.getText().toString();
                if (!sPesquisa.equals("") && sPesquisa.length() >= 3) {
                    try {
                        filters = new ArrayList<>();
                        filters.add("name=" + sPesquisa);
                        filters.add("language=Portuguese (Brazil)");
                        exibirProgress(true);
                        new GetCardsInBackground().execute("url");

                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                }
                else{
                    Toast.makeText(ConsultaCardsActivity.this, "Digite o nome de um card ou pelo menos 3 letras", Toast.LENGTH_LONG).show();
                }
            }
        });

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {


                MagicCard magicCard = new MagicCard(cards.get(position));

                Intent i = new Intent(ConsultaCardsActivity.this, DetalheDoCardActivity.class);
                i.putExtra("card", magicCard);
                startActivity(i);

            }
        });


    }

    private class GetCardsInBackground extends AsyncTask<String, Void, Boolean> {

        protected Boolean doInBackground(String... urls) {
                cards.clear();
            try {
                cards = CardAPI.getAllCards(filters);

                if(cards.size() > 0)
                    return true;


            } catch (Exception e) {
                Log.e("MCErro", e.getMessage());
                Toast.makeText(ConsultaCardsActivity.this, R.string.erro_cca01, Toast.LENGTH_LONG).show();
                e.printStackTrace();
                erro_da_busca = e.getMessage();
            }

            return false;
        }

        protected void onPostExecute(Boolean haveResult) {
            exibirProgress(false);

            if(haveResult) {
                adapter = new ListaCardsAdapter(ConsultaCardsActivity.this,
                        cards);
                listView.setAdapter(adapter);
            }

            else {
                Toast.makeText(ConsultaCardsActivity.this, R.string.erro_cca02, Toast.LENGTH_LONG).show();

            }

        }
    }

    private void exibirProgress(boolean exibir) {
        mProgressBar.setVisibility(exibir ? View.VISIBLE : View.GONE);
    }

}
