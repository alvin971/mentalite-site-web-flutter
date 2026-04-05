# Déploiement App Store — Fastlane

## Setup initial (une seule fois)

### 1. Installer Fastlane
```bash
sudo gem install fastlane
```

### 2. Créer le fichier Appfile (gitignored)
```bash
cp fastlane/Appfile.example fastlane/Appfile
# Éditer fastlane/Appfile avec tes vraies valeurs
```

### 3. Configurer la clé API App Store Connect
1. Aller sur https://appstoreconnect.apple.com → Utilisateurs et accès → Clés API
2. Créer une clé avec le rôle **App Manager**
3. Télécharger le fichier `.p8`
4. Le placer dans : `~/.appstoreconnect/private_keys/AuthKey_XXXXXXXX.p8`

### 4. Définir les variables d'environnement (dans ~/.zshrc ou ~/.bash_profile)
```bash
export APP_STORE_KEY_ID="XXXXXXXX"
export APP_STORE_ISSUER_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
export APP_STORE_API_KEY_PATH="$HOME/.appstoreconnect/private_keys/AuthKey_XXXXXXXX.p8"
```

---

## Déploiement

```bash
cd /home/ubuntu/mentalite_site_web_flutter/ios
fastlane ios release    # Build + upload TestFlight
fastlane ios build      # Build local uniquement
```

---

## Sécurité

- Le fichier `Appfile` est gitignored (contient Apple ID et Team ID)
- Les fichiers `.p8` sont gitignored (clé privée API)
- Ne jamais partager ni committer ces fichiers
