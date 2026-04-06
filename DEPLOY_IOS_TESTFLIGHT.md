# Guide complet — Déploiement automatique iOS sur TestFlight

> Ce guide documente la méthode exacte utilisée pour publier automatiquement une app Flutter iOS
> sur TestFlight via GitHub Actions + Fastlane. Il est rédigé pour être réutilisable sur n'importe
> quelle autre app Flutter iOS.

---

## Table des matières

1. [Vue d'ensemble](#1-vue-densemble)
2. [Prérequis](#2-prérequis)
3. [Étape 1 — Préparer Apple Developer Portal](#3-étape-1--préparer-apple-developer-portal)
4. [Étape 2 — Créer la clé API App Store Connect](#4-étape-2--créer-la-clé-api-app-store-connect)
5. [Étape 3 — Configurer les secrets GitHub](#5-étape-3--configurer-les-secrets-github)
6. [Étape 4 — Structure des fichiers Fastlane](#6-étape-4--structure-des-fichiers-fastlane)
7. [Étape 5 — Le workflow GitHub Actions](#7-étape-5--le-workflow-github-actions)
8. [Étape 6 — Configuration Xcode (project.pbxproj)](#8-étape-6--configuration-xcode-projectpbxproj)
9. [Erreurs rencontrées et solutions](#9-erreurs-rencontrées-et-solutions)
10. [Checklist complète](#10-checklist-complète)
11. [Où sont stockés les secrets](#11-où-sont-stockés-les-secrets)

---

## 1. Vue d'ensemble

### Ce que fait ce pipeline

À chaque `git push` sur la branche `main`, GitHub Actions :
1. Installe Flutter et compile l'app iOS
2. Se connecte à Apple via une clé API (sans mot de passe, sans 2FA)
3. Crée automatiquement le certificat de distribution s'il n'existe pas
4. Crée automatiquement le profil de provisioning
5. Signe l'app avec ce certificat
6. Upload le fichier `.ipa` sur TestFlight
7. L'app est disponible dans TestFlight ~15 minutes après le push

### Technologies utilisées

| Outil | Rôle |
|-------|------|
| **GitHub Actions** | Orchestration CI/CD (runner macOS) |
| **Fastlane** | Automatisation signature + upload Apple |
| **Fastlane `cert`** | Gestion automatique des certificats de distribution |
| **Fastlane `sigh`** | Gestion automatique des profils de provisioning |
| **App Store Connect API** | Authentification Apple sans mot de passe ni 2FA |

---

## 2. Prérequis

Avant de commencer, il te faut :

- [ ] Un compte **Apple Developer** payant (99$/an) — https://developer.apple.com
- [ ] Un compte **GitHub** avec le repo de ton app
- [ ] L'app enregistrée sur **App Store Connect** (Bundle ID créé)
- [ ] Flutter installé localement (pour tester)

---

## 3. Étape 1 — Préparer Apple Developer Portal

### 3.1 Trouver ton Team ID

1. Va sur https://developer.apple.com/account
2. Connecte-toi
3. En haut à droite, clique sur ton nom → **Membership details**
4. Note le **Team ID** (format : `XXXXXXXXXX`, 10 caractères)

> Ce Team ID sera utilisé comme secret GitHub `APPLE_TEAM_ID`

### 3.2 Enregistrer l'app (Bundle ID)

1. Va sur https://developer.apple.com/account/resources/identifiers/list
2. Clique **+** pour créer un nouvel **App ID**
3. Choisis **App** → Continue
4. Remplis :
   - **Description** : nom de ton app
   - **Bundle ID** : `com.tonentreprise.nomapp` (ex: `com.mentalite.monApp`)
5. Continue → Register

> Ce Bundle ID sera utilisé comme secret GitHub `BUNDLE_ID`

### 3.3 Vérifier les certificats disponibles

Apple limite à **2 certificats de distribution** par compte.

1. Va sur https://developer.apple.com/account/resources/certificates/list
2. Si tu vois 2 certificats "Apple Distribution" ou "iOS Distribution", tu dois en **révoquer** au moins un avant de continuer
3. Pour révoquer : clique sur le certificat → **Revoke** → Confirm

> **Important** : Fastlane va créer automatiquement un nouveau certificat lors du premier run. Si le quota est plein, il échoue avec l'erreur "reached the maximum number of available Distribution certificates".

### 3.4 Créer l'app sur App Store Connect

1. Va sur https://appstoreconnect.apple.com
2. Clique **Mes apps** → **+** → **Nouvelle app**
3. Remplis :
   - **Plateforme** : iOS
   - **Nom** : nom public de ton app
   - **Langue principale** : Français
   - **Bundle ID** : sélectionne celui créé à l'étape 3.2
   - **SKU** : un identifiant unique de ton choix
4. Créer

---

## 4. Étape 2 — Créer la clé API App Store Connect

Cette clé permet à Fastlane de s'authentifier auprès d'Apple **sans mot de passe et sans 2FA**.

### 4.1 Créer la clé

1. Va sur https://appstoreconnect.apple.com/access/integrations/api
2. Clique **Générer une clé API** (ou **+**)
3. Donne-lui un nom (ex: "GitHub Actions CI")
4. Rôle : **App Manager** (suffisant pour TestFlight)
5. Clique **Générer**

### 4.2 Télécharger et noter les informations

Apple affiche la clé **une seule fois** — après tu ne peux plus la télécharger.

- Clique **Télécharger la clé API** → tu obtiens un fichier `AuthKey_XXXXXXXX.p8`
- Note le **Key ID** (8 caractères, visible dans la liste)
- Note le **Issuer ID** (UUID visible en haut de la page)

| Information | Où la trouver | Secret GitHub correspondant |
|-------------|---------------|----------------------------|
| Contenu du fichier `.p8` | Fichier téléchargé (ouvrir avec TextEdit) | `APP_STORE_API_KEY_CONTENT` |
| Key ID | Liste des clés API (colonne "Key ID") | `APP_STORE_KEY_ID` |
| Issuer ID | En haut de la page clés API | `APP_STORE_ISSUER_ID` |

---

## 5. Étape 3 — Configurer les secrets GitHub

Les secrets GitHub sont des variables chiffrées, jamais visibles après saisie. C'est là que sont stockés tous les identifiants sensibles.

### 5.1 Accéder aux secrets

1. Va sur ton repo GitHub
2. Clique **Settings** → **Secrets and variables** → **Actions**
3. Clique **New repository secret** pour chaque secret ci-dessous

### 5.2 Liste des secrets à créer

| Nom du secret | Valeur | Où la trouver |
|---------------|--------|---------------|
| `APP_STORE_KEY_ID` | Le Key ID de ta clé API | App Store Connect → Intégrations → Clés API |
| `APP_STORE_ISSUER_ID` | L'Issuer ID | App Store Connect → Intégrations → Clés API (en haut) |
| `APP_STORE_API_KEY_CONTENT` | Contenu du fichier `.p8` (tout le texte) | Fichier `AuthKey_XXXXXXXX.p8` téléchargé |
| `APPLE_TEAM_ID` | Ton Team ID Apple Developer | developer.apple.com → Membership details |
| `BUNDLE_ID` | Ton Bundle ID (ex: `com.mentalite.monApp`) | App créée sur App Store Connect |

> **Note** : Une fois saisis, ces secrets ne peuvent pas être relus — seulement remplacés. Garde une copie dans un endroit sûr (voir section 11).

---

## 6. Étape 4 — Structure des fichiers Fastlane

### 6.1 Arborescence nécessaire

```
ios/
├── Gemfile                    ← déclare la dépendance Fastlane pour Bundler
├── fastlane/
│   ├── Fastfile               ← script principal (signé, buildé, uploadé)
│   ├── Appfile.example        ← modèle (gitignored, généré en CI)
│   └── README.md              ← documentation locale
└── Runner.xcodeproj/
    └── project.pbxproj        ← config Xcode (signing manuel)
```

### 6.2 `ios/Gemfile`

Ce fichier verrouille la version de Fastlane utilisée en CI.

```ruby
source "https://rubygems.org"
gem "fastlane"
```

**Pourquoi** : Sans Gemfile, `gem install fastlane` installe la dernière version disponible à chaque run, ce qui peut casser si Fastlane sort une version incompatible.

### 6.3 `ios/fastlane/Fastfile`

C'est le cœur du système. Voici le Fastfile complet avec explications :

```ruby
default_platform(:ios)

platform :ios do
  desc "Build, signe et upload vers TestFlight (utilisé par GitHub Actions)"
  lane :release do

    # ÉTAPE 1 — Authentification Apple via clé API (.p8)
    # Utilise les 3 secrets GitHub : APP_STORE_KEY_ID, APP_STORE_ISSUER_ID, APP_STORE_API_KEY_PATH
    # Avantage : pas besoin de mot de passe Apple ni de 2FA en CI
    api_key = app_store_connect_api_key(
      key_id: ENV["APP_STORE_KEY_ID"],
      issuer_id: ENV["APP_STORE_ISSUER_ID"],
      key_filepath: ENV["APP_STORE_API_KEY_PATH"],
      duration: 1200,
      in_house: false,
    )

    # ÉTAPE 2 — Créer un keychain temporaire
    # OBLIGATOIRE en CI : GitHub Actions démarre sans keychain système.
    # Le certificat de distribution doit être installé quelque part.
    # Ce keychain est créé au début du job et détruit automatiquement à la fin.
    keychain_name = "ci_keychain"
    keychain_password = "ci_keychain_password"
    create_keychain(
      name: keychain_name,
      password: keychain_password,
      default_keychain: true,   # en fait le keychain par défaut du système
      unlock: true,              # déverrouillé immédiatement
      timeout: 3600,             # reste déverrouillé 1h (durée du job)
      lock_when_sleeps: false,
    )

    # ÉTAPE 3 — Télécharger/créer le certificat de distribution iOS
    # `cert` cherche d'abord un certificat valide existant dans ton compte Apple.
    # S'il n'en trouve pas, il en crée un nouveau.
    # Le certificat est installé dans le keychain CI créé à l'étape 2.
    # ATTENTION : Apple limite à 2 certificats de distribution par compte.
    cert(
      api_key: api_key,
      team_id: ENV["APPLE_TEAM_ID"],
      keychain_path: "~/Library/Keychains/#{keychain_name}-db",
      keychain_password: keychain_password,
    )

    # ÉTAPE 4 — Télécharger/créer le profil de provisioning
    # `sigh` crée un profil App Store lié à ton Bundle ID et à ton certificat.
    # Après cette étape, ENV["SIGH_UUID"] contient l'UUID du profil téléchargé.
    # force: true = recrée toujours un profil frais (évite les profils expirés)
    sigh(
      api_key: api_key,
      app_identifier: ENV["BUNDLE_ID"],
      team_id: ENV["APPLE_TEAM_ID"],
      force: true,
    )

    # ÉTAPE 5 — Configurer Xcode pour le signing manuel
    # Applique le certificat et le profil au projet Xcode.
    # Passe de "Automatic" à "Manual" signing.
    # Sans cette étape, Xcode essaierait de gérer le signing lui-même
    # (impossible en CI sans compte Apple connecté localement).
    update_code_signing_settings(
      use_automatic_signing: false,
      path: "Runner.xcodeproj",
      team_id: ENV["APPLE_TEAM_ID"],
      bundle_identifier: ENV["BUNDLE_ID"],
      code_sign_identity: "iPhone Distribution",
      profile_uuid: ENV["SIGH_UUID"],   # UUID récupéré automatiquement par sigh
    )

    # ÉTAPE 6 — Incrémenter le build number
    # TestFlight refuse les builds avec le même numéro de version.
    # Cette action lit le numéro actuel et l'incrémente de 1 automatiquement.
    increment_build_number(
      xcodeproj: "Runner.xcodeproj",
    )

    # ÉTAPE 7 — Compiler et signer l'app (.ipa)
    # workspace: utilise le workspace CocoaPods (Runner.xcworkspace)
    # export_method: "app-store" = build signé pour App Store / TestFlight
    # export_options: passe le profil et le signing manuel à xcodebuild
    build_app(
      workspace: "Runner.xcworkspace",
      scheme: "Runner",
      export_method: "app-store",
      export_options: {
        provisioningProfiles: {
          ENV["BUNDLE_ID"] => ENV["SIGH_UUID"],
        },
        signingStyle: "manual",
        teamID: ENV["APPLE_TEAM_ID"],
      },
      output_directory: "./build",
      output_name: "monapp.ipa",
    )

    # ÉTAPE 8 — Upload vers TestFlight
    # skip_waiting_for_build_processing: true = n'attend pas que Apple traite le build
    # Le traitement Apple prend 10-30 minutes. Sans ce flag, le job attendrait.
    upload_to_testflight(
      api_key: api_key,
      ipa: "./build/monapp.ipa",
      skip_waiting_for_build_processing: true,
    )

    UI.success("Build uploadé sur TestFlight avec succès !")
  end
end
```

### 6.4 `ios/fastlane/Appfile.example`

Ce fichier est un modèle. Le vrai `Appfile` est **gitignored** et généré automatiquement en CI par le workflow.

```ruby
# Appfile.example — Copier vers Appfile (gitignored) et remplir les valeurs
# Ne JAMAIS committer le fichier Appfile réel

app_identifier "com.tonentreprise.nomapp"
team_id "XXXXXXXXXX"
```

---

## 7. Étape 5 — Le workflow GitHub Actions

Fichier : `.github/workflows/ios_deploy.yml`

```yaml
name: iOS — Build & Deploy TestFlight

on:
  push:
    branches:
      - main   # Se déclenche à chaque push sur main

jobs:
  deploy:
    name: Build & Upload to TestFlight
    runs-on: macos-latest   # OBLIGATOIRE : seul macOS peut compiler pour iOS

    steps:
      # STEP 1 — Récupérer le code source
      - name: Checkout
        uses: actions/checkout@v4

      # STEP 2 — Installer Flutter
      # Utilise le cache pour éviter de re-télécharger Flutter à chaque run
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.27.0'   # Doit correspondre à la version dans pubspec.yaml
          channel: 'stable'
          cache: true

      # STEP 3 — Installer les packages Dart/Flutter
      - name: Flutter pub get
        run: flutter pub get

      # STEP 4 — Écrire la clé Apple (.p8) sur le disque
      # La clé API est stockée en texte dans le secret GitHub APP_STORE_API_KEY_CONTENT.
      # On la réécrit dans le chemin attendu par Fastlane.
      - name: Write App Store Connect API Key
        run: |
          mkdir -p ~/.appstoreconnect/private_keys
          echo "${{ secrets.APP_STORE_API_KEY_CONTENT }}" > ~/.appstoreconnect/private_keys/AuthKey_${{ secrets.APP_STORE_KEY_ID }}.p8

      # STEP 5 — Créer l'Appfile Fastlane dynamiquement
      # L'Appfile est gitignored (ne doit pas être dans le repo).
      # On le génère en CI à partir des secrets GitHub.
      - name: Create Fastlane Appfile
        run: |
          cat > ios/fastlane/Appfile << EOF
          app_identifier "${{ secrets.BUNDLE_ID }}"
          team_id "${{ secrets.APPLE_TEAM_ID }}"
          EOF

      # STEP 6 — Installer Ruby + dépendances via Gemfile
      # bundler-cache: true = met en cache les gems entre les runs (plus rapide)
      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.2'
          bundler-cache: true
          working-directory: ios   # cherche le Gemfile dans ios/

      # STEP 7 — Installer Fastlane via Bundler
      # "bundle install" lit ios/Gemfile et installe Fastlane à la version verrouillée
      # Toujours utiliser "bundle exec fastlane" ensuite (pas "fastlane" directement)
      - name: Install Fastlane via Bundler
        run: bundle install
        working-directory: ios

      # STEP 8 — Installer les dépendances iOS natives (CocoaPods)
      # Flutter génère un Podfile automatiquement lors du premier build.
      # pod install installe les plugins natifs (url_launcher, etc.)
      - name: Install CocoaPods
        run: |
          cd ios
          pod install --repo-update

      # STEP 9 — Compiler Flutter pour iOS
      # --release = build optimisé
      # --no-codesign = pas de signature ici, Fastlane s'en chargera
      - name: Flutter build iOS
        run: flutter build ios --release --no-codesign

      # STEP 10 — Fastlane : signe + upload TestFlight
      # "bundle exec fastlane" = utilise la version Fastlane du Gemfile (pas la globale)
      # Les ENV vars injectent les secrets dans le Fastfile
      - name: Fastlane release
        run: bundle exec fastlane ios release
        working-directory: ios
        env:
          APP_STORE_KEY_ID: ${{ secrets.APP_STORE_KEY_ID }}
          APP_STORE_ISSUER_ID: ${{ secrets.APP_STORE_ISSUER_ID }}
          APP_STORE_API_KEY_PATH: ~/.appstoreconnect/private_keys/AuthKey_${{ secrets.APP_STORE_KEY_ID }}.p8
          APPLE_TEAM_ID: ${{ secrets.APPLE_TEAM_ID }}
          BUNDLE_ID: ${{ secrets.BUNDLE_ID }}
```

---

## 8. Étape 6 — Configuration Xcode (project.pbxproj)

Le fichier `ios/Runner.xcodeproj/project.pbxproj` doit être configuré pour le **signing manuel** en Release. Sans cela, Xcode tente de gérer le signing automatiquement — ce qui échoue en CI car il n'y a pas de compte Apple connecté.

### Ce qu'il faut modifier

Dans la configuration **Release** du projet (pas de la target) :

```
"CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Distribution";   // ← pas "iPhone Developer"
CODE_SIGN_STYLE = Manual;                                         // ← pas Automatic
```

**Comment le trouver** : Dans `project.pbxproj`, chercher le bloc `97C147041CF9000F /* Release */` (config projet, pas target). C'est là que se définissent les valeurs par défaut héritées par toutes les targets.

> **Note** : `update_code_signing_settings` dans Fastlane applique aussi ces changements au runtime, mais avoir le bon signing dans le fichier évite des conflits.

---

## 9. Erreurs rencontrées et solutions

### Erreur 1 : `flutter pub get` échoue — constraint SDK

```
Because mentalite_site_web_flutter requires SDK version >=3.7.0 ...
```

**Cause** : Le `pubspec.yaml` demande une version Dart trop récente par rapport à Flutter 3.27.0.

**Solution** : Dans `pubspec.yaml`, changer :
```yaml
environment:
  sdk: '>=3.7.0 <4.0.0'   # ← trop récent
```
en :
```yaml
environment:
  sdk: '>=3.5.0 <4.0.0'   # ← compatible Flutter 3.27.0
```

---

### Erreur 2 : Fastlane échoue — pas de keychain

```
error: No signing certificate "iOS Distribution" found
```

**Cause** : GitHub Actions démarre sans keychain système. `cert` ne peut pas installer le certificat.

**Solution** : Ajouter `create_keychain` dans le Fastfile **avant** l'appel à `cert`, et passer `keychain_path` + `keychain_password` à `cert`.

---

### Erreur 3 : Fastlane échoue — trop de certificats

```
Could not create another Distribution certificate,
reached the maximum number of available Distribution certificates.
```

**Cause** : Apple limite à 2 certificats de distribution par compte. Le quota est atteint.

**Solution** :
1. Aller sur https://developer.apple.com/account/resources/certificates/list
2. Révoquer les certificats expirés ou inutilisés (**Revoke**)
3. Relancer le pipeline

---

### Erreur 4 : Fastlane échoue — Appfile manquant

```
No AppFile found at path 'ios/fastlane/Appfile'
```

**Cause** : L'Appfile est gitignored et n'existe pas en CI.

**Solution** : Ajouter un step dans le workflow pour le créer dynamiquement depuis les secrets GitHub (voir Step 5 du workflow ci-dessus).

---

### Erreur 5 : Code signing conflit Automatic/Manual

```
error: Provisioning profile ... doesn't match the entitlements file
```

**Cause** : `CODE_SIGN_STYLE = Automatic` dans `project.pbxproj` entre en conflit avec le signing manuel de Fastlane.

**Solution** : Modifier `project.pbxproj` comme décrit en section 8.

---

## 10. Checklist complète

### Pour une nouvelle app Flutter iOS

- [ ] Compte Apple Developer actif (99$/an)
- [ ] App créée sur App Store Connect (Bundle ID enregistré)
- [ ] Clé API App Store Connect créée (Key ID + Issuer ID + fichier .p8)
- [ ] Team ID noté
- [ ] Quota certificats vérifié (max 2 — en révoquer si plein)
- [ ] Repo GitHub créé
- [ ] 5 secrets GitHub configurés (`APP_STORE_KEY_ID`, `APP_STORE_ISSUER_ID`, `APP_STORE_API_KEY_CONTENT`, `APPLE_TEAM_ID`, `BUNDLE_ID`)
- [ ] `ios/Gemfile` créé
- [ ] `ios/fastlane/Fastfile` configuré (avec keychain + cert + sigh + build + upload)
- [ ] `.github/workflows/ios_deploy.yml` configuré
- [ ] `project.pbxproj` : `CODE_SIGN_STYLE = Manual`, `CODE_SIGN_IDENTITY = "iPhone Distribution"` dans Release
- [ ] Push sur `main` → vérifier que le pipeline passe dans GitHub Actions
- [ ] Vérifier l'app dans App Store Connect → TestFlight (~15 min après le push)

---

## 11. Où sont stockés les secrets

> Cette section référence les emplacements des secrets — jamais leurs valeurs.

| Secret | Emplacement sur le serveur |
|--------|---------------------------|
| Token GitHub (push/pull) | `/home/ubuntu/.git-credentials` dans chaque projet |
| Token Cloudflare API | Variable d'environnement dans `/home/ubuntu/.bashrc` et `/home/ubuntu/.profile` |
| Account ID Cloudflare | Variable d'environnement dans `/home/ubuntu/.bashrc` |
| Secrets Apple + Bundle ID | GitHub → repo → Settings → Secrets and variables → Actions |
| Supabase URL + Anon Key | `/home/ubuntu/mentality-admin/.env` |
| Récapitulatif complet | `/home/ubuntu/mentality-shared/SECRETS.md` |

> Le fichier `/home/ubuntu/mentality-shared/SECRETS.md` est le document central qui liste tous les secrets du projet Mentality. Il n'est dans aucun repo git.

---

## Réutiliser ce pipeline sur une autre app

Pour adapter ce pipeline à un nouveau projet Flutter iOS :

1. Copier `.github/workflows/ios_deploy.yml` → adapter le nom et la version Flutter
2. Copier `ios/Gemfile` → aucun changement nécessaire
3. Copier `ios/fastlane/Fastfile` → changer uniquement `output_name: "monapp.ipa"`
4. Copier `ios/fastlane/Appfile.example` → aucun changement
5. Modifier `ios/Runner.xcodeproj/project.pbxproj` → signing Manuel + iPhone Distribution
6. Créer les 5 secrets GitHub avec les nouvelles valeurs du nouveau projet
7. Push sur `main` → le pipeline se déclenche automatiquement

---

*Rédigé le 2026-04-06 — Pipeline validé et opérationnel sur `alvin971/mentalite-site-web-flutter`*
