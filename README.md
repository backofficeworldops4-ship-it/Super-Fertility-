# SuperFertility Platform — Phase 1 Demo

A responsive, synthetic-data demonstration of the SuperFertility Standard private-consult pathway. Built with Next.js, React, TypeScript, Tailwind CSS v4, and Lucide icons.

> **DEMO ONLY — NOT FOR CLINICAL USE.** All records are fictional. This demo does not make clinical decisions, process real payments, create legally binding signatures, or contact external services. State is stored in the current browser's localStorage and is not a shared multi-user backend.

## What is implemented

- Five role-switchable experiences: Patient, Psychiatrist, GP, Internal / QC, Administration.
- Case overview, search, case manager, audit trail, pathway progress, appointments, reports, operational monitoring, and integration configuration views.
- Create single-applicant or two-applicant partner demo cases; partner case uses one shared case and distinct applicant consent/signature/report expiry fields.
- Local state persistence and reset-to-fixture control.
- Demo workflow actions for payment, intake/consent, QC 1, practitioner progression/signing, QC 2, report release, no-show and rebooking-fee gates.
- Report release is blocked unless QC 2 passed and every applicant has both practitioner reports signed.
- Downloadable synthetic report text for released cases.
- Demo integration adapter boundary for payments, AI polishing, scheduling, telehealth, SMS, email, Xero, Freshsales and signing.
- Supabase PostgreSQL migration foundation and environment-variable template.

## Run locally

Requirements: Node.js 20.9+ (Node 22 recommended) and npm.

```bash
cp .env.example .env.local
npm install
npm run dev
```

Open `http://localhost:3000`. No credentials are required for demo mode.

## Checks

```bash
npm run typecheck
npm test
npm run build
```

## Demo walkthrough

1. Select **Internal / QC** in the top-right role switcher.
2. Open **Cases**, select `SF-1042`, then approve **QC 1**. This fixture has completed intake and consent.
3. Switch to **Psychiatrist** and open the same case. Complete the consultation and sign the report.
4. Switch to **GP** and complete the GP consultation and report signing.
5. Switch to **Internal / QC**, open the case, approve **QC 2**, then release the final reports.
6. Switch to **Patient** and open **Reports & documents** to download an available synthetic report.

The preloaded fixtures are intentionally in different stages to make the dashboard presentation realistic. Some role-specific views filter the fixtures. New cases created in the demo are fictional records; use `.example.test` addresses.

## Production architecture boundaries

The demo UI state is intentionally separated from integration adapters and the proposed Supabase schema. Do not treat browser-side role switching or localStorage as production authorization. Production must enforce identity, role and applicant/partner-specific authorization on the server and through audited database policies. Review the SQL migration and add tested RLS policies before storing any real information.

### Required client access before production integration

- Supabase project, region confirmation (proposal recommends Sydney), Auth configuration, storage buckets, database owner and approved retention/security policy.
- OpenAI API account/billing, approved data-processing terms and decision on Australian-only inference requirements.
- Cal.com Teams account and practitioner/team setup; final selection and API permissions.
- Whereby Embedded or approved alternative account and production domain configuration.
- Twilio account, verified Australian sender/number and messaging compliance details.
- Resend account, verified sending domain and approved templates.
- Xero tenant and OAuth app with least-privilege scopes.
- AMS Freshsales account, API access and approved one-way assistance-handover field mapping.
- One approved payment provider, test/live accounts, webhook signing secret and agreed no-show/rebooking rules.
- Approved psychiatrist/GP templates, report rules, clinical wording, intake/consent content, ATO forms and signing method.
- Confirmed partner appointment model (shared or separate), cross-partner permissions, cancellation window, rebooking fee and waiver rules.
- Vercel team/project access and GitHub repository access for deployment ownership.

## Environment variables

See `.env.example`. Never commit `.env.local`, service-role keys, OAuth secrets or API tokens. Only public Supabase URL/anon key may be exposed in the browser, and only after proper RLS policies are tested. Production API calls must run server-side.

## Deployment

Connect the repository to Vercel, set the project root to the repository root, and use the default Next.js build. The demo can run without environment variables. Set `NEXT_PUBLIC_APP_MODE=demo`. Do not add production credentials until the client has approved data-processing and security requirements.

## Known limitations

- No real Supabase Auth/database wiring or server-side role enforcement yet.
- LocalStorage state is browser-specific and can be edited by the visitor; it is not suitable for real patient data.
- All external integrations and practitioner signatures are simulations.
- Report downloads are explicitly labelled synthetic text files, not ATO/PDF output or medical reports.
- Appointment calendar, notifications, AI generation, fee calculations and Xero/Freshsales sync are illustrative.
- Final legal, privacy, healthcare and ATO signing acceptability must be confirmed by the client and its advisers.
