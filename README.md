##### \# eAnimalShelter

##### 

##### \## Opis aplikacije

##### 

##### eAnimalShelter je sistem namijenjen upravljanju šeltera za životinje. Sistem omogućava administraciju životinja, korisnika, donacija, volontiranja, objava i procesa udomljavanja kroz desktop i mobilnu aplikaciju.

##### 

##### Desktop aplikacija je namijenjena administratorima šeltera, dok je mobilna aplikacija namijenjena krajnjim korisnicima koji žele pregledavati životinje, podnositi zahtjeve za udomljavanje, prijavljivati se za volontiranje, donirati sredstva i pratiti novosti.

##### 

##### \---

##### 

##### \# Korištene tehnologije

##### 

##### \## Backend

##### 

##### \* ASP.NET Core 9

##### \* Entity Framework Core 9

##### \* SQL Server

##### \* JWT autentifikacija

##### \* Docker

##### \* RabbitMQ (EasyNetQ)

##### \* Stripe API

##### \* FluentValidation

##### \* Mapster

##### 

##### \## Desktop aplikacija

##### 

##### \* Flutter (Windows)

##### \* Provider

##### \* HTTP

##### \* JWT Authentication

##### 

##### \## Mobilna aplikacija

##### 

##### \* Flutter (Android)

##### \* Provider

##### \* HTTP

##### \* JWT Authentication

##### \* Stripe Flutter SDK

##### 

##### \---

##### 

##### \# Pokretanje aplikacije

##### 

##### \## 1. Pokretanje backend sistema

##### 

##### Pozicionirati se u root direktorij projekta gdje se nalazi `docker-compose.yml`.

##### 

##### Pokrenuti:

##### 

##### docker compose up --build

##### 

##### 

##### Nakon uspješnog pokretanja:

##### 

##### \* SQL Server će biti automatski kreiran

##### \* izvršit će se EF Core migracije

##### \* baza će biti automatski seedovana

##### \* Web API će biti dostupan na:

##### 

##### http://localhost:5036

##### 

##### Swagger dokumentacija:

##### 

##### http://localhost:5036/swagger

##### 

##### 

##### \---

##### 

##### \## 2.Pokretanje Windows aplikacije

##### 

##### Preuzeti Windows Release iz GitHub Releases.

##### 

##### Otvoriti folder:

##### 

##### Release/

##### 

##### i pokrenuti:

##### 

##### eanimalshelter\_desktop.exe

##### 

##### \---

##### 

##### \## 3. Pokretanje Android aplikacije

##### 

##### Preuzeti app-release.apk iz GitHub Releases.

##### 

##### Instalirati APK na Android uređaj ili Android Emulator te pokrenuti aplikaciju.

##### \---

##### 

##### \# Korisnički nalozi

##### 

##### | Kontekst        | Korisničko ime | Lozinka |

##### | --------------- | -------------- | ------- |

##### | Desktop         | admin1         | Test1   |

##### | Client          | client1        | Test1   |

##### | Volunteer       | volunteer1     | Test1   |

##### 

##### 

##### \---

##### 

##### \# Napomene

##### 

##### \* API koristi JWT autentifikaciju.

##### \* Stripe test kartice mogu se koristiti za simulaciju donacija.

##### \* Baza podataka se automatski kreira prilikom prvog pokretanja Docker kontejnera.

##### \* Za Android emulator koristi se adresa:

##### 

##### http://10.0.2.2:5036

##### 

##### \* Za Windows aplikaciju koristi se:

##### 

##### http://localhost:5036

##### 

##### \---

##### 

##### \# Release

##### 

##### GitHub Release sadrži:

##### 

##### \* Windows Release build

##### \* Android APK

##### \* Izvorni kod projekta

##### 

##### \---

##### 

##### \# Konfiguracija

##### 

##### Iz sigurnosnih razloga .env fajlovi nisu uključeni u repozitorij.

##### 

##### Potrebno je raspakovati sljedeće arhive prije pokretanja sistema:

##### 

##### Lokacija	                 Arhiva

##### Root direktorij projekta	.env-tajne.rar

##### UI/eanimalshelter\_mobile/	.env-tajne.rar



##### Napomena

##### 

##### \*Root .env sadrži konfiguraciju backend sistema (JWT, baza podataka,RabbitMq, Stripe Secret Key i ostale server konfiguracije).

##### \*Mobilni .env sadrži Stripe Publishable Key koja je potrebna za izvršavanje Stripe plaćanja u mobilnoj aplikaciji.

##### 

