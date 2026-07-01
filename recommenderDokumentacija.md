# Implementacija sistema preporuke



##### U okviru aplikacije implementiran je sistem preporuke životinja čiji je cilj korisnicima prikazati životinje koje najbolje odgovaraju njihovim prethodnim interesima i aktivnostima unutar sistema. Za razliku od jednostavnog prikazivanja svih dostupnih životinja, implementirani algoritam analizira ponašanje korisnika i na osnovu toga generiše personalizovane preporuke.



##### Sistem preporuke realizovan je kroz servis *RecommendationService*, koji implementira interfejs *IRecommendationService*. Servis koristi informacije o trenutno prijavljenom korisniku putem servisa *IAuthenticatedUserAccessor*, čime se preporuke generišu individualno za svakog korisnika. Rezultat rada servisa predstavlja lista objekata tipa *AnimalRecommendationResponse*, koja za svaku preporučenu životinju sadrži osnovne informacije o životinji, numeričku vrijednost ostvarenog skora te tekstualno objašnjenje zbog čega je određena životinja preporučena korisniku.



##### Prilikom generisanja preporuka sistem analizira tri vrste korisničkih aktivnosti. Prvi izvor podataka predstavljaju životinje koje je korisnik dodao u listu omiljenih (*Favorites*), što se smatra najjačim pokaziteljem korisničkih preferencija. Drugi izvor podataka čine zahtjevi za udomljavanje koje je korisnik prethodno podnio, pri čemu se uzimaju u obzir svi zahtjevi osim odbijenih, budući da oni predstavljaju stvarnu namjeru korisnika za udomljavanjem određene vrste životinja. Treći izvor podataka predstavlja historija pregleda životinja (*AnimalViewHistory*), koja omogućava sistemu da prepozna životinje koje su privukle korisnikovu pažnju, čak i ukoliko ih nije dodao među omiljene niti podnio zahtjev za udomljavanje.



##### Historija pregleda implementirana je kroz entitet *AnimalViewHistory*, koji za svakog korisnika evidentira pregledane životinje i vrijeme posljednjeg pregleda. Evidentiranje pregleda realizovano je servisom *AnimalViewHistoryService*, koji prilikom svakog otvaranja detalja životinje provjerava postoji li već zapis za kombinaciju korisnika i životinje. Ukoliko zapis ne postoji, kreira se novi unos, dok se u suprotnom ažurira vrijeme posljednjeg pregleda. Na ovaj način izbjegava se kreiranje velikog broja duplih zapisa za istu životinju, a istovremeno se čuva informacija da je korisnik ponovo pokazao interes za određenog ljubimca.



##### Nakon prikupljanja korisničkih aktivnosti sistem provjerava posjeduje li korisnik bilo kakvu historiju interakcija. Ukoliko korisnik još uvijek nije pregledao nijednu životinju, nije dodao nijednu u omiljene niti je podnio zahtjev za udomljavanje, nije moguće izračunati personalizovane preporuke. U tom slučaju primjenjuje se ***popularity-based*** pristup, odnosno preporučuju se trenutno najpopularnije dostupne životinje u sistemu.



##### U slučaju da korisnik posjeduje historiju aktivnosti, sistem primjenjuje ***content-based*** pristup preporučivanju. Prije samog izračuna iz skupa kandidata uklanjaju se sve životinje koje je korisnik već pregledao, dodao među omiljene ili za koje je podnio zahtjev za udomljavanje. Time se izbjegava preporučivanje već poznatih životinja i korisniku se prikazuju isključivo novi prijedlozi.



##### Za svaku preostalu životinju izračunava se ukupan skor sličnosti u odnosu na životinje koje se nalaze u korisnikovoj historiji. Izračun se vrši metodom *CalculateScore*, koja poredi karakteristike kandidata sa svakom životinjom iz odgovarajuće grupe. Prilikom poređenja uzimaju se u obzir četiri osnovna atributa životinje: vrsta, rasa, spol, i starost.

##### Najveći broj bodova dodjeljuje se ukoliko kandidat pripada istoj vrsti kao prethodno interesantna životinja, zatim slijedi podudaranje rase, dok spol i približna starost imaju nešto manji uticaj na konačni rezultat. Starost se smatra sličnom ukoliko razlika između dvije životinje nije veća od jedne godine.



##### Nakon izračuna ukupnog skora za svakog kandidata, preporuke se sortiraju prema ostvarenom broju bodova, nakon čega se korisniku prikazuje unaprijed definisan broj najbolje rangiranih životinja. Pored numeričkog skora, sistem generiše i tekstualno objašnjenje preporuke, koje korisniku pruža dodatnu transparentnost rada algoritma. Objašnjenje zavisi od izvora koji je imao najveći doprinos konačnom rezultatu te može ukazivati da je životinja preporučena zbog sličnih omiljenih životinja, prethodnih zahtjeva za udomljavanje ili ranije pregledanih životinja.



##### Na ovaj način implementirani sistem kombinuje content-based filtering i popularity-based preporučivanje. Za nove korisnike, koji još uvijek nemaju historiju aktivnosti, koriste se preporuke zasnovane na popularnosti, čime se rješava problem cold start. Nakon što korisnik počne koristiti aplikaciju i ostvarivati interakcije sa životinjama, sistem automatski prelazi na personalizovane preporuke zasnovane na karakteristikama životinja koje su u skladu s prethodno iskazanim interesima korisnika. Ovakav pristup omogućava jednostavnu implementaciju, dobru interpretabilnost rezultata i kvalitetnije korisničko iskustvo prilikom pretraživanja životinja za udomljavanje.

##### 

