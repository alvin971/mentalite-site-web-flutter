#!/usr/bin/env python3
"""
Script d'envoi de notifications push Firebase (FCM) aux inscrits Mental E.T.

Usage:
  python3 send_notification.py --all --title "Bonne nouvelle !" --body "L'app est disponible !"
  python3 send_notification.py --email jean@example.com --title "Votre accès" --body "Bienvenue !"

Prérequis:
  pip3 install google-auth requests --break-system-packages
"""

import argparse
import json
import sys
import requests
import google.oauth2.service_account
import google.auth.transport.requests

SERVICE_ACCOUNT_FILE = '/home/ubuntu/mentality-shared/firebase-service-account.json'
PROJECT_ID = 'mentalet-64b83'
FCM_URL = f'https://fcm.googleapis.com/v1/projects/{PROJECT_ID}/messages:send'

SUPABASE_URL = 'https://supabase.0for0.com'
SUPABASE_KEY = 'eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9.eyJyb2xlIjogImFub24iLCAiaXNzIjogInN1cGFiYXNlIiwgImlhdCI6IDE3NzM5NjE0NTIsICJleHAiOiAyMDg5MzIxNDUyfQ.zU4lqg55i1aUG-SEIz_SeVCdMI5twUyqK4W1eyVMXYo'


def get_access_token():
    credentials = google.oauth2.service_account.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE,
        scopes=['https://www.googleapis.com/auth/firebase.messaging']
    )
    credentials.refresh(google.auth.transport.requests.Request())
    return credentials.token


def get_tokens_from_supabase(email=None):
    """Récupère les tokens FCM depuis Supabase."""
    headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f'Bearer {SUPABASE_KEY}',
    }
    url = f'{SUPABASE_URL}/rest/v1/inscriptions?select=email,prenom,fcm_token&fcm_token=not.is.null'
    if email:
        url += f'&email=eq.{email}'

    resp = requests.get(url, headers=headers, timeout=10)
    if resp.status_code != 200:
        print(f'Erreur Supabase: {resp.status_code} {resp.text}')
        return []
    return resp.json()


def send_notification(token, title, body, access_token):
    """Envoie une notification FCM à un token donné."""
    headers = {
        'Authorization': f'Bearer {access_token}',
        'Content-Type': 'application/json',
    }
    payload = {
        'message': {
            'token': token,
            'notification': {
                'title': title,
                'body': body,
            },
        }
    }
    resp = requests.post(FCM_URL, headers=headers, json=payload, timeout=10)
    return resp.status_code == 200, resp.text


def main():
    parser = argparse.ArgumentParser(description='Envoyer des notifications push Mental E.T.')
    parser.add_argument('--all', action='store_true', help='Envoyer à tous les inscrits')
    parser.add_argument('--email', help='Envoyer à un email spécifique')
    parser.add_argument('--title', required=True, help='Titre de la notification')
    parser.add_argument('--body', required=True, help='Contenu de la notification')
    args = parser.parse_args()

    if not args.all and not args.email:
        print('Erreur: utilise --all ou --email jean@example.com')
        sys.exit(1)

    print('Authentification Firebase...')
    access_token = get_access_token()

    print('Récupération des tokens depuis Supabase...')
    inscrits = get_tokens_from_supabase(email=args.email)

    if not inscrits:
        print('Aucun token trouvé.')
        return

    print(f'{len(inscrits)} destinataire(s) trouvé(s).\n')
    success, fail = 0, 0

    for inscrit in inscrits:
        token = inscrit.get('fcm_token')
        email = inscrit.get('email')
        prenom = inscrit.get('prenom', '')
        if not token:
            continue
        ok, response = send_notification(token, args.title, args.body, access_token)
        if ok:
            print(f'  ✓ {prenom} ({email})')
            success += 1
        else:
            print(f'  ✗ {prenom} ({email}) — {response}')
            fail += 1

    print(f'\nRésultat: {success} envoyé(s), {fail} échec(s).')


if __name__ == '__main__':
    main()
