/**
 * Cloudflare Worker — Email de confirmation d'inscription Mental E.T.
 *
 * Reçoit POST {prenom, email, place_number} depuis Flutter
 * → appelle Resend API pour envoyer un email transactionnel
 *
 * Variables d'environnement requises (Cloudflare Secrets) :
 *   RESEND_API_KEY  — clé API Resend.com (https://resend.com/api-keys)
 *   FROM_EMAIL      — ex: "Mental E.T. <bonjour@mental-et.fr>"
 *                     (domaine doit être vérifié dans Resend)
 */

const ALLOWED_ORIGINS = [
  'https://mental-et.pages.dev',
  'https://mentalite-site-web.pages.dev',
  'http://localhost',
];

function corsHeaders(origin) {
  const allowed = ALLOWED_ORIGINS.includes(origin) ? origin : ALLOWED_ORIGINS[0];
  return {
    'Access-Control-Allow-Origin': allowed,
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  };
}

export default {
  async fetch(request, env) {
    const origin = request.headers.get('Origin') ?? '';

    // Preflight CORS
    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers: corsHeaders(origin) });
    }

    if (request.method !== 'POST') {
      return new Response('Method Not Allowed', { status: 405 });
    }

    // Parse body
    let body;
    try {
      body = await request.json();
    } catch {
      return new Response(JSON.stringify({ error: 'Invalid JSON' }), {
        status: 400,
        headers: { 'Content-Type': 'application/json', ...corsHeaders(origin) },
      });
    }

    const { prenom, email, place_number } = body;

    // Validation basique
    if (!prenom || typeof prenom !== 'string') {
      return errorResponse('Champ prenom manquant', origin);
    }
    if (!email || !email.includes('@')) {
      return errorResponse('Email invalide', origin);
    }
    if (typeof place_number !== 'number' || place_number < 1) {
      return errorResponse('place_number invalide', origin);
    }

    const placeFormatted = `#${String(place_number).padStart(4, '0')}`;
    const prenomCapitalized = prenom.charAt(0).toUpperCase() + prenom.slice(1);

    // Appel Resend API
    const resendRes = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${env.RESEND_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        from: env.FROM_EMAIL ?? 'Mental E.T. <bonjour@mental-et.fr>',
        to: [email],
        subject: `Ta place ${placeFormatted} est confirmée, ${prenomCapitalized} 🧠`,
        html: buildEmailHtml(prenomCapitalized, placeFormatted),
        text: buildEmailText(prenomCapitalized, placeFormatted),
      }),
    });

    if (!resendRes.ok) {
      const errText = await resendRes.text();
      console.error('Resend error:', errText);
      return new Response(JSON.stringify({ error: 'Erreur envoi email' }), {
        status: 500,
        headers: { 'Content-Type': 'application/json', ...corsHeaders(origin) },
      });
    }

    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { 'Content-Type': 'application/json', ...corsHeaders(origin) },
    });
  },
};

function errorResponse(message, origin) {
  return new Response(JSON.stringify({ error: message }), {
    status: 400,
    headers: { 'Content-Type': 'application/json', ...corsHeaders(origin) },
  });
}

function buildEmailHtml(prenom, place) {
  return `<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Confirmation Mental E.T.</title>
</head>
<body style="margin:0;padding:0;background:#FAF9F6;font-family:'DM Sans',Arial,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background:#FAF9F6;padding:40px 20px;">
    <tr>
      <td align="center">
        <table width="100%" cellpadding="0" cellspacing="0" style="max-width:560px;">

          <!-- Header -->
          <tr>
            <td style="padding-bottom:32px;">
              <p style="margin:0;font-size:20px;font-weight:700;color:#0B1F17;font-family:Georgia,serif;">
                Mental E.T.
              </p>
            </td>
          </tr>

          <!-- Card -->
          <tr>
            <td style="background:#fff;border:1px solid #E5E0D8;border-radius:12px;padding:40px;">

              <!-- Badge place -->
              <p style="margin:0 0 8px;font-size:11px;letter-spacing:2px;color:#4D7C4A;font-family:'Courier New',monospace;text-transform:uppercase;">
                Place confirmée
              </p>
              <p style="margin:0 0 24px;font-size:48px;font-weight:700;color:#4D7C4A;font-family:'Courier New',monospace;line-height:1;">
                ${place}
              </p>

              <!-- Message principal -->
              <p style="margin:0 0 16px;font-size:22px;color:#0B1F17;font-family:Georgia,serif;">
                Bienvenue, ${prenom} !
              </p>
              <p style="margin:0 0 24px;font-size:15px;color:#3D5248;line-height:1.7;">
                Tu es officiellement inscrit(e) sur la liste d'attente de
                <strong>Mental E.T.</strong> — la première plateforme de psychologie
                complète et gratuite, basée sur le WAIS-IV.
              </p>
              <p style="margin:0 0 32px;font-size:15px;color:#3D5248;line-height:1.7;">
                Nous t'enverrons un email dès que l'accès est ouvert.
                Garde ce message pour retrouver ton numéro de place.
              </p>

              <!-- Ce qui t'attend -->
              <table width="100%" cellpadding="0" cellspacing="0"
                style="background:#F2F5F0;border-radius:8px;padding:20px;margin-bottom:32px;">
                <tr>
                  <td>
                    <p style="margin:0 0 12px;font-size:12px;letter-spacing:1px;color:#4D7C4A;font-family:'Courier New',monospace;">
                      CE QUI T'ATTEND
                    </p>
                    <p style="margin:0 0 8px;font-size:14px;color:#0B1F17;">✓ 12 tests cognitifs validés (WAIS-IV)</p>
                    <p style="margin:0 0 8px;font-size:14px;color:#0B1F17;">✓ Profil cognitif complet avec 4 indices</p>
                    <p style="margin:0 0 8px;font-size:14px;color:#0B1F17;">✓ Accompagnement IA 24h/24</p>
                    <p style="margin:0;font-size:14px;color:#0B1F17;">✓ Supervision par de vrais cliniciens</p>
                  </td>
                </tr>
              </table>

              <!-- CTA -->
              <a href="https://mentalite-site-web.pages.dev"
                style="display:inline-block;background:#4D7C4A;color:#fff;text-decoration:none;
                       padding:14px 28px;border-radius:50px;font-size:14px;font-weight:600;">
                Partager Mental E.T.
              </a>

            </td>
          </tr>

          <!-- Footer email -->
          <tr>
            <td style="padding-top:32px;">
              <p style="margin:0;font-size:12px;color:#7A9488;line-height:1.6;">
                Mental E.T. · Non substitut au diagnostic médical<br>
                Pour toute question : contact@mental-et.fr
              </p>
            </td>
          </tr>

        </table>
      </td>
    </tr>
  </table>
</body>
</html>`;
}

function buildEmailText(prenom, place) {
  return `Bienvenue sur Mental E.T., ${prenom} !

Ta place est confirmée : ${place}

Tu es officiellement inscrit(e) sur la liste d'attente de Mental E.T. — la première plateforme de psychologie complète et gratuite, basée sur le WAIS-IV.

Ce qui t'attend :
- 12 tests cognitifs validés (WAIS-IV)
- Profil cognitif complet avec 4 indices
- Accompagnement IA 24h/24
- Supervision par de vrais cliniciens

Nous t'enverrons un email dès que l'accès est ouvert.

Mental E.T.
contact@mental-et.fr
`;
}
