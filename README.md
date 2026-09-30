29/9/2026

Problemstilling
Jeg ville undersøge, hvilke af landene Danmark, Tyskland, Spanien og Italien der havde det højeste forhold mellem syriske statsborgere, som blev pålagt at forlade landet, og syriske statsborgere, som blev registreret som returneret efter et pålæg om at forlade landet.

1. Finde data
Jeg brugte search_eurostat_toc() til at finde relevante tabeller i Eurostat.
Jeg fandt to datasæt:
•	migr_eiord = personer, der er blevet pålagt at forlade landet
•	migr_eirtn = personer, der er blevet registreret som returneret efter et pålæg om at forlade landet
Jeg har altså brug for to datasæt, fordi et pålæg om at forlade landet ikke nødvendigvis betyder, at personen faktisk forlader landet.

2. Undersøge metadata
Før før analyserede data, undersøgte jeg metadata med get_eurostat_dsd().
Metadata er data om data og fortæller , hvad variabler og koder betyder.
Jeg fandt blandt andet:
•	citizen == "SY" → syrisk statsborgerskab
•	geo → landet, fx DK, DE, ES, IT
•	age == "TOTAL" → alle aldre
•	sex == "T" → alle køn
•	unit == "PER" → personer
•	c_dest == "TOTAL" → alle destinationer i returneringsdata

3. Hente og kontrollere data
Jeg hentede de faktiske data med get_eurostat_data().
Derefter undersøgte jeg datasættene og kontrollerede for manglende værdier med:
colSums(is.na(data))
Der var ingen NA-værdier.

4. Filtrere data
Jeg filtrerede data, så vi kun beholdt:
•	syriske statsborgere
•	Danmark, Tyskland, Spanien og Italien
•	alle aldre
•	alle køn
•	personer
Det gav to mindre datasæt: ordered_syria og returned_syria.

5. Samle datasættene
Begge datasæt havde en kolonne, der hed values. Derfor omdøbte jeg dem til henholdsvis ordered og returned.
Derefter brugte jeg inner_join() til at samle datasættene efter:
•	geo = samme land
•	time = samme år
Jeg brugte derefter select() til kun at beholde de kolonner, vi skulle bruge.

6. Beregne forholdet
Jeg ville ikke kun sammenligne antallet af returnerede personer, fordi landene havde meget forskellige antal personer, der var blevet pålagt at forlade landet.
Derfor sammenlignede jeg:
returnerede efter et pålæg / pålagt at forlade × 100
Jeg samlede først tallene for hvert land med group_by() og summarise() og beregnede derefter forholdet.
Blandt de fire undersøgte lande havde Danmark det højeste forhold mellem registrerede returneringer efter et pålæg og antallet af pålæg om at forlade landet i den analyserede periode.
Det er vigtigt, at forholdet ikke nødvendigvis viser, at 33,8 % af præcis de samme personer, der fik et pålæg, senere forlod landet.
En person kan eksempelvis få et pålæg ét år og blive registreret som returneret i et senere år.
Derfor bruger jeg tallene som en sammenligning af de registrerede totaler.
Til sidst lavede jeg et søjlediagram i ggplot2, så forholdet mellem de fire lande kunne sammenlignes visuelt.
Kilde: Eurostat – migr_eiord og migr_eirtn.

 

