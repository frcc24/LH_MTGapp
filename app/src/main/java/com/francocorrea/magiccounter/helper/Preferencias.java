package com.francocorrea.magiccounter.helper;

import android.content.Context;
import android.content.SharedPreferences;

public class Preferencias {

    private Context contexto;
    private SharedPreferences preferences;
    private final String NOME_ARQUIVO = "magic.preferencias";
    private final int MODE = 0;
    private SharedPreferences.Editor editor;

    // ad de teste
    private String adCode = "ca-app-pub-3940256099942544/6300978111";
    // ad de Producao
    //private String adCode = "ca-app-pub-7357171440518292~8329648137";


    private final String CHAVE_PLAYERS   = "players";
    private final String CHAVE_MODO_JOGO = "modo_jogo";
    private final String CHAVE_QTDE_HP   = "qtde_hp";
    private final String CHAVE_VENENO    = "veneno_on";
    private final String CHAVE_ENERGIA   = "energia_on";
    private final String CHAVE_LINGUA    = "lingua";
    private final String CHAVE_TXT_SIZE  = "tamanho_txt";
    private final String CHAVE_SOM       = "som";
    private final String CHAVE_TIMER     = "timer";


    public Preferencias( Context contextoParametro){
        contexto = contextoParametro;
        preferences = contexto.getSharedPreferences(NOME_ARQUIVO, MODE );
        editor = preferences.edit();

    }
    public void restoreDefault( ) {
        editor.putString(CHAVE_PLAYERS, "2");
        editor.putString(CHAVE_MODO_JOGO, "normal");
        editor.putString(CHAVE_QTDE_HP, "20");
        editor.putString(CHAVE_VENENO, "on");
        editor.putString(CHAVE_ENERGIA, "on");
        editor.commit();
    }


    public void salvarVeneno( String sOnOff) {
        editor.putString(CHAVE_VENENO, sOnOff);
        editor.commit();
    }
    public void salvarContadores(String sOnOff) {
        editor.putString(CHAVE_ENERGIA, sOnOff);
        editor.commit();
    }

    public void salvarSom(String sOnOff) {
        editor.putString(CHAVE_SOM, sOnOff);
        editor.commit();
    }

    public void salvarPlayers( String num_players  ) {
        editor.putString(CHAVE_PLAYERS, num_players);
        editor.commit();
    }

    public void salvarLingua( String lingua ) {
        editor.putString(CHAVE_LINGUA, lingua);
        editor.commit();
    }

    public void salvarTamanhoTexto( String tamanho_txt ) {
        editor.putString(CHAVE_TXT_SIZE, tamanho_txt);
        editor.commit();
    }

    public void salvarModoJogo( String modo_jogo  ) {
        editor.putString(CHAVE_MODO_JOGO, modo_jogo);
        editor.commit();
    }

    public void salvarQtdeHP( String qtde_hp  ) {
        editor.putString(CHAVE_QTDE_HP, qtde_hp);
        editor.commit();
    }

    public void salvarTimer(String value) {
        editor.putString(CHAVE_TIMER, value);
        editor.commit();
    }
    public String getChaveTimer(){
        return preferences.getString(CHAVE_TIMER, "45");
    }

    public String getChavePlayers(){
        return preferences.getString(CHAVE_PLAYERS, "2");
    }

    public String getLingua(){
        return preferences.getString(CHAVE_LINGUA, "pt");
    }


    public String getChaveModoJogo(){
        return preferences.getString(CHAVE_MODO_JOGO, "normal");
    }

    public String getChaveQtdeHP(){
        return preferences.getString(CHAVE_QTDE_HP, "20");
    }

    public String getVeneno(){
        return preferences.getString(CHAVE_VENENO, "off");
    }

    public String getTxtSize(){
        return preferences.getString(CHAVE_TXT_SIZE, "0.5");
    }

    public String getContadores(){
        return preferences.getString(CHAVE_ENERGIA, "off");
    }

    public String getCHAVE_SOM(){
        return preferences.getString(CHAVE_SOM, "on");
    }



}
