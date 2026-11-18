<div align="center">

# sharedstatus ☁️

**a tiny, cozy ios widget for couples & close friends · ein kleiner, gemütlicher ios-widget für paare & enge freunde**

![ios](https://shields.io)
![swift](https://shields.io)
![lang](https://shields.io)
![privacy](https://shields.io)

<br/>

<img src="assets/widget-small.svg" height="190" alt="small widget preview"/>
&nbsp;&nbsp;&nbsp;
<img src="assets/widget-medium.svg" height="190" alt="medium widget preview"/>

</div>

---

### 🇬🇧 english · about

no noise, no calls, no pressure to reply — just gentle presence on your home screen. pick a cute little buddy, tap your current vibe, and let your favorite person see what you're up to right through their wallpaper.

* **all lowercase aesthetic** — calm, minimal, and easy on the eyes.
* **wallpaper adaptive** — frosted glass (`ultraThinMaterial`) & ios tinted icon support.
* **cute companions** — choose between `🐱 kitty`, `🦊 little fox`, `🐻‍❄️ polar bear`, `🐰 bunny`, `🐸 froggy`, and `🦆 duckling`.
* **bilingual (de / en)** — switch between german and english in a single tap.
* **zero tracking (dsgvo)** — no emails, no passwords, no ads. just a simple room code like `kafe-42`.

---

### 🇩🇪 deutsch · über das projekt

kein lärm, keine anrufe, kein druck sofort zu antworten — nur ein sanftes lebenszeichen auf deinem home-bildschirm. wähle dein lieblingstierchen, tippe auf deinen aktuellen vibe und lass deinen lieblingsmenschen direkt über das widget daran teilhaben.

* **all lowercase ästhetik** — ruhig, minimalistisch und entspannt für die augen.
* **passt sich dem hintergrundbild an** — milchglas-optik (`ultraThinMaterial`) & unterstützung für eingefärbte ios-icons.
* **süße begleiter** — wähle zwischen `🐱 kätzchen`, `🦊 füchschen`, `🐻‍❄️ eisbär`, `🐰 häschen`, `🐸 fröschlein` und `🦆 entchen`.
* **zweisprachig (de / en)** — wechsel zwischen deutsch und englisch mit nur einem tipp.
* **kein tracking (dsgvo-konform)** — keine e-mails, keine passwörter, keine werbung. nur ein einfacher raum-code wie `miau-99`.

---

### ✨ widget preview · vorschau

| widget (`de`) | widget (`en`) | vibe |
| :--- | :--- | :--- |
| `🐱 💻` **am arbeiten** · *gerade eben* | `🐱 💻` **focusing** · *just now* | deep work / fokus |
| `🦊 ☕️` **lust auf kaffee?** · *gerade eben* | `🦊 ☕️` **up for coffee?** · *just now* | coffee break / kaffeepause |
| `🐰 🚃` **unterwegs** · *gerade eben* | `🐰 🚃` **on my way** · *just now* | commuting / bahn & bus |
| `🐻‍❄️ 🪫` **akku leer** · *gerade eben* | `🐻‍❄️ 🪫` **low battery** · *just now* | tired / müde |
| `🐸 🛋️` **zuhause & chill** · *gerade eben* | `🐸 🛋️` **chilling at home** · *just now* | cozy evening / feierabend |
| `🦆 🤍` **denk an dich** · *gerade eben* | `🦆 🤍` **thinking of you** · *just now* | gentle hug / liebe grüße |

---

### 🛠️ architecture & stack

```text
sharedstatus/
├── App/        # swiftui main interface, pet & vibe selector, room pairing
├── Widget/     # widgetkit adaptive home screen widget (.systemSmall & .systemMedium)
├── Shared/     # app groups storage (group.com.sharedstatus.app) & supabase sync
├── assets/     # vector widget previews
└── .github/    # automated macos xcodebuild ci pipeline
```

---

### 🤍 support · unterstützung

wenn dir dieses projekt gefällt oder hilft, würde mir eine spende sehr viel bedeuten und dabei helfen, es weiterzuentwickeln. alternativ kannst du das projekt mit einem stern ⭐ im github-repository unterstützen. vielen dank!

if you enjoy this tiny project, a small donation means a lot and helps keep it growing — or simply leave a star ⭐ on github. thank you!

* **solana:** `zQpgZ6nGigww7vYpz3Qqxb1BT44kqS567vFaLTeHagS`
* **ethereum:** `0x9c4fE1B2e9a1A9c22312c8296BB088Ca0e8F1B4e`
* **bitcoin:** `bc1p2jltk9ya9kyzv35d8kxn7mmg9jqkx66cqtgzqwe75zlr4v9jk4hsv468q7`

---

<div align="center">
<sub>made with ☁️ & ☕️ · made by ruslan ✌️ · all lowercase always</sub>
</div>
