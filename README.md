# Mental E.T. — Landing Page iOS (mentalite-site-web-flutter)

App Flutter iOS de la landing page **Mental E.T.** — inscription des utilisateurs en liste d'attente.

> Pour le guide CI/CD complet : voir `DEPLOY_IOS_TESTFLIGHT.md`

---

## Vue d'ensemble

| Élément | Valeur |
|---------|--------|
| **Bundle ID** | `com.mentalite.app` |
| **Repo GitHub** | `alvin971/mentalite-site-web-flutter` |
| **TestFlight** | App Store Connect → Mental E.T. (ID `6761692391`) |
| **Supabase** | `http://92.222.243.34:8000` (VPS auto-hébergé) |
| **Firebase** | Projet `mentalet-64b83` |
| **Flutter** | 3.27.0 stable |
| **iOS minimum** | 13.0 (requis par Firebase SDK 11+) |

---

## Ce que fait l'app

1. **Splash screen** — Logo animé (atome + orbites + points tournants) pendant 2,5 secondes
2. **Landing page** — Présentation de l'app Mentality (tests cognitifs WAIS-IV)
3. **Formulaire d'inscription** — Prénom, nom, email, téléphone, source
4. **Permission notifications** — Popup iOS proposée au moment de l'inscription (non obligatoire)
5. **Page confirmation** — Affiche le numéro de place dans la liste d'attente

---

## Architecture des fichiers

```
lib/
├── main.dart                        ← Point d'entrée (Firebase init)
├── app.dart                         ← GoRouter — routes /splash, /, /confirmation
├── pages/
│   ├── splash_screen.dart           ← Logo animé au démarrage (2,5s)
│   ├── home_page.dart               ← Landing page complète
│   └── confirmation_page.dart       ← Page après inscription
├── widgets/
│   ├── navbar_widget.dart           ← Navbar + logo animé (_OrbitPainter)
│   ├── hero_section.dart
│   ├── form_section.dart            ← Formulaire inscription + demande notifs
│   ├── stats_section.dart           ← Compteur d'inscrits (live depuis Supabase)
│   └── ...                          ← Autres sections
├── services/
│   ├── supabase_service.dart        ← API Supabase (inscriptions + compteur)
│   └── notification_service.dart    ← Firebase FCM (permission + token)
└── theme/
    ├── colors.dart                  ← Palette Kepler (accent #4D7C4A, bg #FAF9F6)
    └── typography.dart              ← Source Serif 4 + DM Sans (Google Fonts)

ios/
├── Runner/
│   ├── AppDelegate.swift            ← FirebaseApp.configure() au démarrage
│   ├── GoogleService-Info.plist     ← Config Firebase iOS (projet mentalet-64b83)
│   └── Info.plist                   ← ITSAppUsesNonExemptEncryption=false (export compliance)
├── fastlane/
│   └── Fastfile                     ← Pipeline signature + upload TestFlight
└── Gemfile                          ← Fastlane via Bundler

scripts/
└── send_notification.py             ← Envoyer des notifs push depuis le terminal

.github/workflows/
└── ios_deploy.yml                   ← CI/CD GitHub Actions
```

---

## Supabase (base de données)

Instance auto-hébergée sur le VPS `92.222.243.34`, port `8000`.

### Table `inscriptions`

| Colonne | Type | Description |
|---------|------|-------------|
| `id` | uuid | Clé primaire |
| `created_at` | timestamptz | Date d'inscription |
| `prenom` | text | Prénom |
| `nom` | text | Nom |
| `email` | text UNIQUE | Email (clé de déduplication) |
| `telephone` | text | Téléphone (optionnel) |
| `reseau_social` | text | Source (TikTok, Instagram, etc.) |
| `accepted_terms` | boolean | Conditions acceptées |
| `fcm_token` | text | Token Firebase pour notifications push |
| `place_number` | serial | Numéro de place dans la liste d'attente |

### Fonction RPC

```sql
get_inscription_count() → integer
```
Retourne le nombre total d'inscrits. Appelée par `stats_section.dart` à l'ouverture.

---

## Firebase (notifications push)

- **Projet** : `mentalet-64b83`
- **App iOS** : Bundle ID `com.mentalite.app`
- **APNs** : Clé `.p8` uploadée (Key ID `W426TUCNJK`, Team ID `J7K94W4PUN`)
- **Service Account** : `firebase-adminsdk-fbsvc@mentalet-64b83.iam.gserviceaccount.com`
- **Fichier JSON** : `/home/ubuntu/mentality-shared/firebase-service-account.json`

### Flux de notification

1. Utilisateur clique "Réserver ma place"
2. iOS affiche la popup de permission notifications
3. Si accepté → token FCM généré → sauvegardé dans `inscriptions.fcm_token`
4. Tu peux envoyer des notifs depuis le terminal :

```bash
cd /home/ubuntu/mentalite_site_web_flutter
pip3 install google-auth requests --break-system-packages

# Envoyer à tous les inscrits
python3 scripts/send_notification.py \
  --all \
  --title "Bonne nouvelle !" \
  --body "L'app Mental E.T. est disponible !"

# Envoyer à une personne précise
python3 scripts/send_notification.py \
  --email jean@example.com \
  --title "Votre accès" \
  --body "Bienvenue Jean !"
```

---

## CI/CD — Déploiement automatique TestFlight

À chaque `git push` sur `main` → build iOS → upload TestFlight automatique.

### Secrets GitHub requis

| Secret | Valeur |
|--------|--------|
| `APP_STORE_KEY_ID` | `W426TUCNJK` |
| `APP_STORE_ISSUER_ID` | `9ed054a6-6ff1-47d8-b54d-27e1a0c12862` |
| `APP_STORE_API_KEY_CONTENT` | Contenu du fichier `.p8` |
| `APPLE_TEAM_ID` | `J7K94W4PUN` |
| `BUNDLE_ID` | `com.mentalite.app` |
| `FIREBASE_SERVICE_ACCOUNT` | JSON du compte de service Firebase |

### Ce que fait le workflow

1. Checkout + Flutter 3.27.0
2. `flutter pub get`
3. Écriture de la clé `.p8` Apple depuis les secrets
4. Setup Ruby 3.2 + Fastlane via Bundler
5. `pod install --repo-update` (installe Firebase pods)
6. **Purge des certificats Distribution orphelins** (évite "max certs reached")
7. `flutter build ios --release --no-codesign`
8. Fastlane : keychain → cert → sigh → sign → `increment_build_number` → `build_app` → `upload_to_testflight`

### Problèmes résolus et leurs fixes

| Problème | Fix appliqué |
|----------|-------------|
| `invalid curve name` (OpenSSL ARM64) | Fastlane patche `OpenSSL::PKey.read` |
| `MISSING_EXPORT_COMPLIANCE` | `ITSAppUsesNonExemptEncryption=false` dans `Info.plist` |
| `max Distribution certificates` | Step de purge automatique via API ASC avant chaque build |
| `externally-managed-environment` pip | `pip3 install --break-system-packages` |
| Firebase SDK requiert iOS 13 | `IPHONEOS_DEPLOYMENT_TARGET = 13.0` dans `project.pbxproj` |

---

## Commandes utiles

```bash
# Dev local web
flutter run -d chrome

# Build iOS
flutter build ios --release --no-codesign

# Vérifier le dernier build CI
python3 -c "
import re, urllib.request, json
with open('/home/ubuntu/.git-credentials') as f:
    token = re.search(r'ghp_[^@]+', f.read()).group(0)
req = urllib.request.Request(
    'https://api.github.com/repos/alvin971/mentalite-site-web-flutter/actions/runs?per_page=1',
    headers={'Authorization': f'token {token}'}
)
with urllib.request.urlopen(req) as resp:
    r = json.loads(resp.read())['workflow_runs'][0]
    print(r['id'], r['status'], r.get('conclusion','—'))
"

# Vérifier les inscrits Supabase
curl -s -H "apikey: eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9.eyJyb2xlIjogImFub24iLCAiaXNzIjogInN1cGFiYXNlIiwgImlhdCI6IDE3NzM5NjE0NTIsICJleHAiOiAyMDg5MzIxNDUyfQ.zU4lqg55i1aUG-SEIz_SeVCdMI5twUyqK4W1eyVMXYo" \
  -H "Authorization: Bearer eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9.eyJyb2xlIjogImFub24iLCAiaXNzIjogInN1cGFiYXNlIiwgImlhdCI6IDE3NzM5NjE0NTIsICJleHAiOiAyMDg5MzIxNDUyfQ.zU4lqg55i1aUG-SEIz_SeVCdMI5twUyqK4W1eyVMXYo" \
  -X POST "http://92.222.243.34:8000/rest/v1/rpc/get_inscription_count"
```

---

## Où sont les secrets

| Secret | Emplacement |
|--------|-------------|
| Tous les secrets Apple + Firebase | `/home/ubuntu/mentality-shared/SECRETS.md` |
| Firebase service account JSON | `/home/ubuntu/mentality-shared/firebase-service-account.json` |
| Token GitHub | `/home/ubuntu/.git-credentials` |
| Secrets GitHub Actions | repo Settings → Secrets and variables → Actions |

---

*Dernière mise à jour : 2026-04-09 — Session de mise en place CI/CD + splash screen + Firebase FCM + Supabase*
