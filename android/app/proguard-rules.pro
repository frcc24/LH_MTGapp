# Regras do R8 no build de release (o plugin do Flutter liga o minify no release; sem regras o app sobe só com o que as
# dependências por acaso trouxerem). Mesmas regras dos outros apps que já mostram anúncios (destinydice, cardkingdoms).

# Unity Ads
-keep class com.unity3d.** { *; }
-keep class com.unity3d.services.** { *; }

# O modo completo do R8 remove o construtor sem argumentos de classes instanciadas por reflexão: compila, sobe, e morre no
# aparelho com NoSuchMethodException. É um crash só de release. Room e WorkManager entram transitivamente pela Unity.
-keep class * extends androidx.room.RoomDatabase { void <init>(); }
-keep class * extends androidx.work.InputMerger { void <init>(); }
# androidx.startup cria cada Initializer por esse construtor, antes da primeira Activity.
-keep class * extends androidx.startup.Initializer { void <init>(); }
