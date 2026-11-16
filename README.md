# Follovia — starter project

This is the first interactive prototype for Follovia, a lightweight customer inquiry and follow-up SaaS.

## Included in this prototype
- Overview dashboard and pipeline metrics
- Customer create/edit workflow
- Search and status filtering
- Follow-up queue
- Template-based reply studio with copy button
- CSV export
- Browser-local persistence using localStorage
- Responsive desktop/mobile layout

## Important limitation
This is a **front-end prototype**, not yet a production SaaS. Customer records are stored only in the current browser on the current device. There is no real authentication, shared database, email delivery, billing, or team collaboration yet. Do not enter real sensitive customer information. The Supabase schema in `supabase/schema.sql` is the planned next backend step; it is not connected yet.

## Run locally (no installation)
1. Extract the ZIP.
2. Open `index.html` in Chrome, Edge, or Firefox.
3. Try adding, editing, searching, and exporting demo customers.

## Publish for free with GitHub + Cloudflare Pages
1. Create a GitHub account at https://github.com/.
2. Create a new **public** repository named `follovia`.
3. Upload `index.html`, `README.md`, and the `supabase` folder.
4. In Cloudflare, open Workers & Pages → Create → Pages → Connect to Git.
5. Select the `follovia` repository.
6. For a plain HTML site, use no build command and set the output directory to `/` (or follow the current Cloudflare Pages UI prompts).
7. Deploy. Cloudflare will provide a temporary `*.pages.dev` address. A custom domain is optional and usually costs money.

## Next build milestone
Connect Supabase Auth + Postgres, apply `supabase/schema.sql`, add row-level security, and replace browser-local storage with authenticated per-workspace data. Only after that should real customer data be used.
