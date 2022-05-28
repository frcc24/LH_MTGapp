package com.francocorrea.magiccounter.activity;

import android.content.ActivityNotFoundException;
import android.content.ComponentName;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.francocorrea.magiccounter.R;
import com.francocorrea.magiccounter.helper.URLConnection;
import com.francocorrea.magiccounter.model.MagicCard;
import com.squareup.picasso.Picasso;

import java.io.InputStream;

public class DetalheDoCardActivity extends AppCompatActivity {
    ImageView iv_card_image;
    ProgressBar mProgressBarImage;
    ProgressBar mProgressBarPreco;
    TextView txt_menor_preco;
    TextView txt_maior_preco;
    MagicCard card;
    String card_name;
    String card_set;

    LinearLayout layout_mana_symbols;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detalhe_do_card);

        mProgressBarImage = findViewById(R.id.progress_bar_card_image);
        mProgressBarPreco = findViewById(R.id.progress_bar_price);
        exibirProgressImage(false);
        exibirProgressPreco(false);

        TextView txt_card_name = findViewById(R.id.txt_card_name_det);
        TextView txt_card_text = findViewById(R.id.txt_card_text_det);
        TextView txt_card_arti = findViewById(R.id.txt_card_artist_det);
        TextView txt_card_flavor = findViewById(R.id.txt_card_flavor_det);
        TextView txt_mana_cost = findViewById(R.id.txt_mana_cost_det);
        TextView txt_tipo = findViewById(R.id.txt_tipo_det);
        TextView txt_poder = findViewById(R.id.txt_poder_det);
        txt_menor_preco = findViewById(R.id.txt_menor_preco_det);
        txt_maior_preco = findViewById(R.id.txt_maior_preco_det);

        Button bt_busca_preco   = findViewById(R.id.bt_busca_precos);
        bt_busca_preco.setVisibility(View.GONE);
        Button bt_ver_card_site = findViewById(R.id.bt_ver_no_site);




        iv_card_image = findViewById(R.id.iv_card_img);


        card = (MagicCard) getIntent().getSerializableExtra("card");

        card_name = card.getCard_name();
        card_set  = card.getCod_colecao();

        txt_card_arti.setText(getString(R.string.artist) + card.getCard_artist());
        txt_card_name.setText(card_name);
        txt_card_text.setText(card.getCard_text());
        txt_card_flavor.setText(card.getFlavor());
        txt_poder.setText(card.getPoder());
        txt_tipo.setText(card.getType());
        txt_mana_cost.setText(getString(R.string.mana) + card.getMana_cost());


//todo apartir daqui consertar para aparecer o simbolo de mana
//        LinearLayout picLL = findViewById(r.id.layout_mana_symbols); //the layout you set in `setContentView()`
////        picLL.layout(0, 0, 100, 0);
////        picLL.setLayoutParams(new LinearLayout.LayoutParams(1000, 60));
////        picLL.setOrientation(LinearLayout.HORIZONTAL);
//        ImageView myImage = new ImageView(this);
//        myImage.setImageResource(r.drawable.w);
//
//        ImageView myImage2 = new ImageView(this);
//        myImage2.setImageResource(r.drawable.w);
//
//        picLL.addView(myImage);
//        picLL.addView(myImage2);


        // show The Image in a ImageView
        if(card.getImg_url() != null)
        {


            Picasso.get().load(card.getImg_url()).into(iv_card_image);
            exibirProgressPreco(true);
            //preco ligamagic
            String URL_GLOBAL = "https://www.lighthousegeek.com.br/?view=ecom%2Fitens&id=276802&searchExactMatch=&busca=" + card_name ;
            new connectAsyncTaskLigaMagic(URL_GLOBAL).execute();
        }
        else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Picasso.get().load(R.drawable.card_back).into(iv_card_image);
        }


        bt_busca_preco.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                exibirProgressPreco(true);


                // preco ug card shop
                String urlCardName = card_name.replace(" ", "+");
                String URL_UG = "http://www.ugcardshop.com.br/?action=cardSearch&search%5Bname%5D=" + urlCardName + "&search%5Bexact%5D=0&search%5Bedition%5D="+ card_set + "&search%5Border%5D=nome&search%5Bway%5D=ASC&pg=0";

                //preco ligamagic
                String URL_GLOBAL = "https://www.ligamagic.com.br/?view=cards%2Fsearch&card=" + card_name + "+ed%3D" + card_set;
                new connectAsyncTaskLigaMagic(URL_GLOBAL).execute();

                //new connectAsyncTaskUG(URL_UG).execute();
            }
        });

        bt_ver_card_site.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //http://gatherer.wizards.com/Pages/Search/Default.aspx?action=advanced&name=+[silence]&set=+[%22m14%22]

                card_name = card_name.replace(" ", "]+[");
                String URL_GLOBAL = "https://gatherer.wizards.com/Pages/Search/Default.aspx?action=advanced&name=+[" + card_name + "]&set=+[%22" + card_set + "%22]";
//                new connectAsyncTaskLigaMagic(URL_GLOBAL).execute();
                try {
                    Intent i = new Intent("android.intent.action.MAIN");
                    i.setComponent(ComponentName.unflattenFromString("com.android.chrome/com.android.chrome.Main"));
                    i.addCategory("android.intent.category.LAUNCHER");
                    i.setData(Uri.parse(URL_GLOBAL));
                    startActivity(i);
                }
                catch(ActivityNotFoundException e) {
                    Toast.makeText(DetalheDoCardActivity.this, "Nao foi possivel iniciar Activity. [DDC-04]", Toast.LENGTH_LONG).show();
                    // Chrome is not installed
                    Intent i = new Intent(Intent.ACTION_VIEW, Uri.parse(URL_GLOBAL));
                    startActivity(i);
                }
            }
        });

    }



    private class connectAsyncTaskLigaMagic extends AsyncTask<Void, Void, String> {
        String url;

        connectAsyncTaskLigaMagic(String urlPass) {
            url = urlPass;
        }

        @Override
        protected void onPreExecute() {
            // TODO Auto-generated method stub
            super.onPreExecute();
        }

        @Override
        protected String doInBackground(Void... params) {
            URLConnection urlConnection= new URLConnection();
            String resp = urlConnection.getResponseFromUrl(url);
            return resp;
        }

        @Override
        protected void onPostExecute(String result) {
            super.onPostExecute(result);
            exibirProgressPreco(false);
            if (result != null) {
//
                // <td class="itemPreco hmin30 ">R$ 0,64</td>
                // <td class="itemPreco hmin30 ">R$ 8,54</td>
                int i = result.indexOf("itemPreco hmin30");

                if(i > 0) {
                    String menorValor = result.substring(i + 21, i + 28);
                    menorValor = menorValor.replace("<" , "");
                    menorValor = menorValor.replace("/" , "");

                    //i = result.indexOf("<div class='col-xl-6 col-6 b preco-maior'><font class='smaller'>r$</font> <font class='bigger'>");
                    //String maiorValor = result.substring(i + 95, i + 100);
                    //maiorValor = maiorValor.replace("<" , "");
                    //maiorValor = maiorValor.replace("<" , "");

                    txt_menor_preco.setText(getString(R.string.preco) + menorValor);
                    //txt_maior_preco.setText(getString(R.string.ate) + maiorValor);
                }
                else{
                    Toast.makeText(DetalheDoCardActivity.this, "Nao foi possivel buscar o preco.", Toast.LENGTH_LONG).show();
                    txt_menor_preco.setText(R.string.erro_ddc01);
                }
            }
            else{
                Toast.makeText(DetalheDoCardActivity.this, "Nao foi possivel buscar o preco2.", Toast.LENGTH_LONG).show();
                txt_menor_preco.setText(R.string.erro_ddc02);
            }
        }
    }



    private void exibirProgressImage(boolean exibir) {
        mProgressBarImage.setVisibility(exibir ? View.VISIBLE : View.GONE);
    }
    private void exibirProgressPreco(boolean exibir) {
        mProgressBarPreco.setVisibility(exibir ? View.VISIBLE : View.GONE);
    }

}
