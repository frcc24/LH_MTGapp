package com.francocorrea.magiccounter.model;

import java.io.Serializable;

import io.magicthegathering.javasdk.resource.Card;

public class MagicCard implements Serializable{
    String card_name;
    String type;
    String card_text;
    String expansao;
    String raridade;
    String mana_cost;
    String converted_manacost;
    String flavor;
    String img_url;
    String card_artist;
    String poder;
    String menor_preco;
    String maior_preco;
    String cod_colecao;



    public MagicCard() {
    }

    public MagicCard(Card card) {
        this.card_name = card.getName();
        this.type      = card.getType();
        this.card_text = card.getText();
        this.expansao  = card.getSetName();
        this.raridade  = card.getRarity();

        if(card.getManaCost() != null)
            this.mana_cost = card.getManaCost();
        else
            this.mana_cost = "";

        this.cod_colecao = card.getSet();
        this.converted_manacost = String.valueOf(card.getCmc());
        this.flavor    = card.getFlavor();
        this.img_url   = card.getImageUrl();
        this.card_artist = card.getArtist();

        if(card.getToughness() != null)
            this.poder = card.getPower() + "/" + card.getToughness();
        else
            this.poder = "";

    }

    public String getCod_colecao() {
        return cod_colecao;
    }

    public void setCod_colecao(String cod_colecao) {
        this.cod_colecao = cod_colecao;
    }

    public String getMenor_preco() {
        return menor_preco;
    }

    public void setMenor_preco(String menor_preco) {
        this.menor_preco = menor_preco;
    }

    public String getMaior_preco() {
        return maior_preco;
    }

    public void setMaior_preco(String maior_preco) {
        this.maior_preco = maior_preco;
    }

    public String getPoder() {
        return poder;
    }

    public void setPoder(String poder) {
        this.poder = poder;
    }

    public String getCard_artist() {
        return card_artist;
    }

    public void setCard_artist(String card_artist) {
        this.card_artist = card_artist;
    }

    public String getImg_url() {
        return img_url;
    }

    public void setImg_url(String img_url) {
        this.img_url = img_url;
    }

    public String getCard_name() {
        return card_name;
    }

    public void setCard_name(String card_name) {
        this.card_name = card_name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getCard_text() {
        return card_text;
    }

    public void setCard_text(String card_text) {
        this.card_text = card_text;
    }

    public String getExpansao() {
        return expansao;
    }

    public void setExpansao(String expansao) {
        this.expansao = expansao;
    }

    public String getRaridade() {
        return raridade;
    }

    public void setRaridade(String raridade) {
        this.raridade = raridade;
    }

    public String getMana_cost() {
        return mana_cost;
    }

    public void setMana_cost(String mana_cost) {
        this.mana_cost = mana_cost;
    }

    public String getConverted_manacost() {
        return converted_manacost;
    }

    public void setConverted_manacost(String converted_manacost) {
        this.converted_manacost = converted_manacost;
    }

    public String getFlavor() {
        return flavor;
    }

    public void setFlavor(String flavor) {
        this.flavor = flavor;
    }
}
