package com.francocorrea.magiccounter.adapter;



import android.content.Context;
import androidx.annotation.NonNull;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.francocorrea.magiccounter.R;

import java.util.List;

import io.magicthegathering.javasdk.resource.Card;

public class ListaCardsAdapter extends ArrayAdapter<Card> {
    private Context context;
    private List<Card> lst_cards;


    public ListaCardsAdapter(@NonNull Context c, @NonNull List<Card> objects) {
        super(c, 0, objects);
        this.context = c;
        this.lst_cards = objects;
    }


    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View view = convertView;

        LayoutInflater inflater = (LayoutInflater) context.getSystemService(context.LAYOUT_INFLATER_SERVICE);

        view = inflater.inflate(R.layout.item_lista_card, parent, false);

        if( lst_cards.size() > 0 ){

            TextView cardname  = view.findViewById(R.id.txt_card_name);
            TextView tipo      = view.findViewById(R.id.txt_type);
            TextView mana_cost = view.findViewById(R.id.txt_mana_cost);
            TextView raridade  = view.findViewById(R.id.txt_raridade);
            TextView expansion = view.findViewById(R.id.txt_expansion);

            Card card = lst_cards.get(position);

            cardname.setText(card.getName());
            tipo.setText(card.getType());
            mana_cost.setText(card.getManaCost());
            raridade.setText(card.getRarity());
            expansion.setText(card.getSetName() + " - " + card.getSet());



        }


        return view;
    }
}


