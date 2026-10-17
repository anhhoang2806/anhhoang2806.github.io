# andrew-hoang-site

Andrew — this is your site and this file is the manual for it. Read section 1, then
section 2, then pick Route A or Route B in section 3. Everything after that you can
come back to when you need it.

It is a hand-written static site: fourteen pages of HTML, one stylesheet, one small
JavaScript file, a headshot, and your CV and portfolio deck as PDFs. There is no build step, no npm, no
framework, no bundler. What is in this folder is exactly what gets served. That is a
deliberate part of the pitch — the site loads nothing from anyone else's server, and
you can prove it in a Network tab in front of a client.

---


## 0. The site is currently HIDDEN from search engines

This is deliberate, so you can deploy and review on a real URL before anyone
outside sees it. Two things are in place:

- every page except `404.html` carries `<meta name="robots" content="noindex, nofollow">`
- `robots.txt` is `Disallow: /` for all crawlers

Deploy it exactly as it is. Open it on your phone, run PageSpeed Insights against
it, send the URL to whoever needs to approve the ELSA Speak and Uppercut Digital
content. Nothing will be indexed.

### When you are ready to be found

    ./go-live.sh

That flips all 13 pages back to `index, follow` and restores the real `robots.txt`.
The production `robots.txt` is embedded inside the script, so it works on a fresh
clone even though `_source/` is gitignored. `404.html` stays `noindex` — correct,
leave it. Then commit, push, and submit `sitemap.xml` in Google Search Console.

Run it once. Running it twice is harmless: it only touches pages still carrying
the staging marker.

---

## 1. STOP — the `_source/` folder must never be committed

This is the one thing in this repository that can actually hurt you, so it comes first.

`_source/` contains:

- `resume.txt` and `portfolio.txt` — your raw CV and portfolio text
- `content-plan.md` — the internal content plan, including its **"GAPS — ANDREW MUST
  SUPPLY"** section, which lists the open questions about your employment dates
- `seo-plan.md`, `free-stack.md`, `design-direction.md` — the working research

Two specific things in there would be damaging in public: the section listing the
**contradictions between your resume and your portfolio** (five projects where the two
documents state different numbers), and the **unresolved date-overlap analysis** (roles
whose date ranges overlap and have not yet been confirmed). Those are notes-to-self.
They read very differently to a recruiter who finds them at a URL.

**Why this is a live risk rather than a theoretical one.** This repository ships a file
called `.nojekyll`. GitHub Pages normally runs a tool called Jekyll, and Jekyll's default
behaviour is to hide any folder whose name starts with an underscore — which would have
hidden `_source/` for you by accident. `.nojekyll` switches Jekyll off (it makes builds
faster and stops Jekyll from mangling any `{{` or `{%` in code samples). The side effect
is that the underscore rule goes away too. **With `.nojekyll` present and `_source/`
committed, anyone could read `https://your-domain/_source/resume.txt` directly.**

It is solved here in two layers:

1. **`.gitignore` has `_source/` in it.** The folder never enters the repository, so it
   is never uploaded and never served. This is the real protection.
2. **`robots.txt` has `Disallow: /_source/` in every crawler group.** This is the backup.
   Be clear-eyed about what it does: `Disallow` asks a polite crawler not to fetch
   something. It does not restrict access. Anyone with the URL still reads the file.

**Things not to do, ever:**

- Do not delete the `_source/` line from `.gitignore`.
- Do not run `git add -f _source/` (the `-f` overrides the ignore rule — that flag exists
  precisely to do the thing you must not do here).
- Do not drag the `_source/` folder into the GitHub web uploader. The web uploader does
  not read `.gitignore`. If you go the browser route (Route A), you must simply not
  select that folder. Section 3 tells you exactly which items to select.
- Do not paste the contents of those files into an issue, a gist, or a public chat.

**After your first deploy, verify it.** Paste this into Terminal, with your real domain:

```bash
curl -sI https://REPLACE-WITH-YOUR-DOMAIN/_source/resume.txt | head -n 1
```

You want `HTTP/2 404`. If you get `HTTP/2 200`, the folder is live: delete it from the
repository immediately (GitHub web UI → open the file → trash icon → commit), then
re-check. Note that removing it from the current commit does not remove it from the
repository's history — if it was ever pushed, assume it was seen, and consider deleting
the repository and starting a fresh one rather than just deleting the files.

If you want those notes version-controlled and backed up, put them in a **separate
private repository**. That is the right home for them.

---

## 2. What is in here

### Pages — fourteen: the plan's eleven, plus three case studies added since

| # | File | What it is |
|---|---|---|
| 1 | `index.html` | Homepage — who you are, headline results, the full client results table, case notes |
| 2 | `about.html` | About & experience — career since 2017, how you work, stack, education, certifications |
| 3 | `services.html` | Consulting — attribution audits, technical SEO and migrations, AEO/GEO, ASO |
| 4 | `work/index.html` | Work index — eight case studies plus the seventeen-project results table |
| 5 | `work/elsa-speak.html` | Case study — ELSA Speak (includes the attribution correction, anchored at `#attribution`) |
| 6 | `work/mindful-organization.html` | Case study — Mindful Organization |
| 7 | `work/phibious-enterprise-seo.html` | Case study — Phibious (Bridgestone, Cleanipedia, Schneider Electric) |
| 8 | `work/permate.html` | Case study — Permate |
| 9 | `work/inapps-technology.html` | Case study — InApps Technology |
| 10 | `work/uppercut-digital.html` | Case study — Uppercut Digital (Meta and Google paid media) |
| 11 | `work/tomorrow-nutrition.html` | Case study — Tomorrow's Nutrition |
| 12 | `work/craft-hub.html` | Case study — Craft Hub |
| 13 | `contact.html` | Contact — email, phone, LinkedIn, and the build note about there being no form |
| 14 | `404.html` | Not found — `noindex, follow`, not in the sitemap |

The content plan caps the site at eleven pages on purpose, and the site has since gone to
fourteen: Uppercut Digital, Tomorrow's Nutrition and Craft Hub were added as case
studies. The principle behind the cap still holds — a page that is not a case study
should displace one of these rather than be added to them.

### Everything else

| File | What it does |
|---|---|
| `assets/css/site.css` | The one and only stylesheet. No `@import`, no web fonts. |
| `assets/js/site.js` | Small vanilla JS — theme toggle and reveal behaviour. No dependencies. |
| `assets/img/andrew-hoang.png` | Your headshot, 800×800. (`andrew-hoang-64.png` sits beside it and is referenced by nothing — safe to delete.) |
| `assets/andrew-hoang-resume.pdf` | Your CV. Linked in-body from index, about, contact, work/index and work/elsa-speak, and listed in the sitemap. |
| `assets/andrew-hoang-portfolio.pdf` | The 43-page portfolio deck, 17 MB. Linked in-body from index, about, contact and work/index, listed in `llms.txt` and in the sitemap. The largest file in the repository by an order of magnitude. |
| `assets/img/clients/`, `assets/img/stack/` | Client marks and stack logos, inline-referenced by the results table, the case notes and the capability panel. Provenance is documented in `_source/client-logos.md` and `_source/stack-logos.md`. |
| `favicon.ico`, `icon.svg`, `icon-192.png` | Site icons, referenced from every page head and from `site.webmanifest`. |
| `robots.txt` | Tells crawlers everything is open, and disallows `/_source/`. Points at the sitemap. |
| `sitemap.xml` | Every indexable URL, plus the CV and the portfolio deck. Fifteen entries. Excludes `404.html`. |
| `llms.txt` | Curated map of the site for LLM agents. Comprehension, not access control. |
| `site.webmanifest` | Name, icon and theme colours if someone adds the site to a home screen. |
| `humans.txt` | Who built it and what it is made of. A small courtesy, and a convention. |
| `.nojekyll` | Empty file. Switches off Jekyll on GitHub Pages. See section 1. |
| `.gitignore` | Keeps `_source/`, editor and OS junk, and tooling state (`.claude/`, `.omc/`) out of the repository. See section 1. |
| `go-live.sh` | One-shot domain swap: rewrites the placeholder token across every file and verifies each one. See section 4. |
| `staging-server.py` | Local preview server. `python staging-server.py`, or pass a port, or set `$PORT`. Development only — it is not part of what gets published. |
| `_source/` | **Local only. Never committed.** See section 1. |

### The rules the site is built on — please keep them

- **Relative links only.** No `href` or `src` ever starts with `/`. That single rule is
  what lets the site work identically on `username.github.io`, on a project subpath, on a
  custom domain, and from a `file://` path on your laptop. The exceptions that *must* be
  absolute are `<link rel="canonical">`, the Open Graph and Twitter image tags, the
  `<loc>` entries in `sitemap.xml`, the `@id` and `url` values in the JSON-LD, and the
  link targets in `llms.txt`. Those are correct as absolute; the spec requires it.
  - Two files legitimately use root-relative paths: `robots.txt` (`Disallow: /_source/`)
    and the `Sitemap:` line. `robots.txt` paths are URL patterns evaluated at the host
    root — that is the format the standard defines. Do not "fix" them.
- **Zero external network requests at runtime.** No remote fonts, scripts, images or
  beacons. System font stack, inline SVG icons. If you add anything from another domain,
  that claim stops being true — and `index.html` and `contact.html` both say it in
  visible copy, so you would have to edit those too. See sections 7 and 8.
- **Real data only.** Every metric, client name, employer and date on the site traces to
  `_source/resume.txt` or `_source/portfolio.txt`. Nothing was invented. Keep it that way.
- **Two colours do two jobs.** Vermilion (`--accent`) is the resting accent: the dot
  after the masthead, the underline under a link that is just sitting there, the rule at
  the top of a section. Blue (`--hover`, `#1D4ED8` light / `#8AB4FF` dark) is the
  interaction colour and nothing else — every hover and every keyboard focus ring on all
  fourteen pages resolves to it, and `--focus` is an alias of it. If you add a new link
  or control, give its `:hover` `var(--hover)`, never `var(--accent)`. The blue is a
  darkened version of the `#3B82F6` already inside `--grad-accent`; it was darkened
  because the gradient's own blue measures 3.20:1 against the sky tint, under AA.
- **Accessibility.** WCAG 2.2 AA, responsive 320px to 2560px, light and dark themes.

---

## 3. Getting it live on GitHub Pages

I checked your machine before writing this, so these are facts about *this* machine
(Windows 11, Git Bash), not general advice:

- `git` **is** installed (version 2.54.0.windows.1)
- git has **no `user.name` and no `user.email` configured** — it will refuse to commit
  until you set them
- the **GitHub CLI (`gh`) is not installed**
- there are **no SSH keys** on the machine (`~/.ssh` does not exist)
- the shell is Git Bash, so the POSIX commands in this file work as written; PowerShell
  and `cmd.exe` do not take them

That is why **Route A is the recommended path**: it needs none of those things. Route B
is here for when you want it.

### First, one decision that actually matters: user site vs project site

GitHub Pages gives you two kinds of site, and the difference is not cosmetic.

| | **User site** ← pick this | Project site |
|---|---|---|
| Repository name | must be exactly `USERNAME.github.io` | anything, e.g. `andrew-hoang-site` |
| Published at | `https://USERNAME.github.io/` | `https://USERNAME.github.io/andrew-hoang-site/` |
| Served from | the domain root | a subpath |
| Your `robots.txt` | **works** | **is ignored** |

Here is the mechanism, because it is the whole argument. A crawler only ever fetches
`robots.txt` from the host root — `https://host/robots.txt`, never
`https://host/subpath/robots.txt`. On a project site your file lands at
`https://USERNAME.github.io/andrew-hoang-site/robots.txt`, which nothing reads; the file
that actually governs the host is `https://USERNAME.github.io/robots.txt`, and you do not
control it. The same applies to `llms.txt` by convention, and to anything else root-scoped
you might want later. The `Sitemap:` directive in your `robots.txt` is inert too — on a
project site you submit the sitemap directly in Search Console instead.

For a site whose entire pitch is that the technical execution is exemplary, shipping with
an inert `robots.txt` is not the impression you want. **Name the repository
`USERNAME.github.io`.**

(If you attach a custom domain later, a project site becomes the host root and its
`robots.txt` starts working. But the user site is free of that whole problem from day one.)

---

### ROUTE A — browser upload (recommended: no setup, no credentials on this machine)

Nothing to install, nothing to configure, no password or token typed into a terminal.
Ten minutes.

**A1. Create the repository.**

1. Sign in to github.com with your **personal** account — the one on
   `tuananhhoang2811@gmail.com`. Not a work account, not a work email. This site is
   personal; every account involved should be too.
2. Top right **+** → **New repository**.
3. **Repository name**: `USERNAME.github.io`, where `USERNAME` is your GitHub username,
   spelled exactly as GitHub spells it, lowercase. If your username is `andrewhoang`, the
   repository is `andrewhoang.github.io`.
4. **Public**. (Pages needs public on a free account.)
5. **Do not** tick "Add a README file", and leave .gitignore and licence set to None —
   you are uploading your own.
6. **Create repository**.

**A2. Upload the files.**

1. On the empty repository page, click **uploading an existing file**.
2. Open Finder at `/Users/tuananh/Downloads/RESUME/andrew-hoang-site`.
3. Press **⌘ + Shift + .** to show hidden files — you need `.nojekyll` and `.gitignore`,
   and they are invisible until you do this.
4. Select these and drag them into the browser window:

   ```
   index.html   about.html   services.html   contact.html   404.html
   robots.txt   sitemap.xml  llms.txt        humans.txt     site.webmanifest
   README.md    .gitignore   .nojekyll
   assets/      work/
   ```

   **Do NOT select `_source/`.** The web uploader ignores `.gitignore` — it uploads
   whatever you give it. This is the one moment where the protection is you, not the tool.
   Re-read section 1 if you are about to do this quickly.
5. Scroll down, leave the commit message as is or write `Initial commit`, click
   **Commit changes**. Give it a minute; there are a couple of megabytes of PNG and PDF.
6. **Check the file list.** If you see `_source` anywhere in it, click into it, delete
   every file, and commit. Then re-read section 1 about history.

**A3. Turn on Pages.**

1. Repository → **Settings** → **Pages** (left sidebar).
2. **Source**: `Deploy from a branch`.
3. **Branch**: `main`, folder `/ (root)` → **Save**.
4. Wait. The first build can take up to ten minutes; later ones are usually under a
   minute. Refresh the Pages settings page and the live URL appears in a green banner.
5. If nothing appears, look at the **Actions** tab. Pages build failures show up there,
   not in Settings.

**A4. Editing later, still in the browser.** Open the file on github.com → pencil icon →
edit → **Commit changes**. To upload a new version of a file, use **Add file → Upload
files** and drop in the replacement; same filename overwrites. Every commit triggers a
rebuild. Batch your edits — Pages allows ten builds an hour, which is the only limit you
can realistically trip.

---

### ROUTE B — terminal and git

Use this when you are making frequent changes and the browser starts to feel slow. It
needs two one-time setup steps that Route A does not.

**B1. Tell git who you are.** Git will not let you commit without this. Use your
**personal** Gmail — the address that goes into every commit is public forever in a
public repository, and your employer's address must never appear in it:

```bash
git config --global user.name "Andrew Hoang"
git config --global user.email "tuananhhoang2811@gmail.com"
```

Check it took:

```bash
git config --global --get user.name
git config --global --get user.email
```

**B2. Create the repository on github.com first** — exactly as in steps A1.1 to A1.6
above. Public, named `USERNAME.github.io`, with no README, no .gitignore and no licence.
You cannot create it from the terminal, because the GitHub CLI is not installed on this
machine.

**B3. Initialise and push.**

```bash
cd /Users/tuananh/Downloads/RESUME/andrew-hoang-site

git init
git add -A
git status          # <- READ THIS. If _source/ appears, stop and fix .gitignore.
git commit -m "Initial commit: Andrew Hoang personal site"
git branch -M main

git remote add origin https://github.com/USERNAME/USERNAME.github.io.git
git push -u origin main
```

Run `git status` before committing, every time. `.gitignore` should keep `_source/` out
automatically, but checking takes two seconds and the failure mode is permanent.

**B4. About that push — it will ask for a password, and your password will not work.**
GitHub removed password authentication for git over HTTPS in 2021. When the prompt appears:

- **Username**: your GitHub username.
- **Password**: a **Personal Access Token**, not your GitHub password.

Create one at github.com → your avatar → **Settings** → **Developer settings** →
**Personal access tokens** → **Tokens (classic)** → **Generate new token (classic)**.
Give it a name like `macbook-pages`, set an expiry, and tick the **`repo`** scope. Copy
the token when it is shown — GitHub never shows it again. Paste it at the password prompt.

Git for Windows ships Git Credential Manager, which stores the token in Windows
Credential Manager after the first successful push, so you enter it once. If it asks
every time, run `git config --global credential.helper manager` and push again. GCM is
also what puts up the account picker on the first push — which is the moment to check
you are signed in as your personal GitHub account and not a work one.

(SSH is the other way to authenticate, but there are no SSH keys on this machine, so HTTPS
plus a token is fewer steps. If you later want SSH, generate a key with
`ssh-keygen -t ed25519 -C "tuananhhoang2811@gmail.com"` and add the `.pub` file to GitHub
→ Settings → SSH and GPG keys.)

**B5. Turn on Pages** — same as A3.

**B6. Every deploy after that:**

```bash
cd /Users/tuananh/Downloads/RESUME/andrew-hoang-site
git add -A
git status
git commit -m "Update the work page"
git push
```

---

## 4. Swapping in a real domain

The whole site uses one placeholder token for its absolute URLs:

```
https://REPLACE-WITH-YOUR-DOMAIN
```

It appears in the canonical tags, the Open Graph and Twitter tags, the JSON-LD `@id` and
`url` values, `sitemap.xml`, `robots.txt` and `llms.txt`. It appears **nowhere** in an
`href` or a `src` — those are all relative, which is why moving the site is a
find-and-replace and not a rewrite.

**The token is the base URL with no trailing slash.** Every URL is built as
`token` + `/` + the same relative path the HTML uses. So if your domain is
`andrewhoang.com`, the token becomes `https://andrewhoang.com` — not
`https://andrewhoang.com/`, and not with a `www.` unless `www` is the host you choose as
canonical.

**Do it in two steps, one string each time:**

- **Step 1, when you first deploy** — replace `https://REPLACE-WITH-YOUR-DOMAIN` with
  `https://USERNAME.github.io` (user site, no subpath).
- **Step 2, when the custom domain is live** — replace `https://USERNAME.github.io` with
  `https://andrewhoang.com`.

In the terminal, from the project folder. **Note the `--exclude=README.md`** on every
line: this file explains the replacement, so the token appears in it on purpose. Rewriting
it here would destroy the instructions for step 2, which you still need.

```bash
# See what you are about to change, and how many hits, before changing anything
grep -rl "REPLACE-WITH-YOUR-DOMAIN" . \
  --exclude-dir=_source --exclude-dir=.git --exclude=README.md
grep -rho "REPLACE-WITH-YOUR-DOMAIN" . \
  --exclude-dir=_source --exclude-dir=.git --exclude=README.md | wc -l

# Do it. There is no portable `sed -i`: BSD sed (macOS) demands an argument after -i,
# GNU sed (Git Bash, Linux) refuses one. Writing to a temp file and moving it over the
# original works on both, which is what go-live.sh does. Collect the file list BEFORE
# rewriting anything: pipe grep straight into the loop and it can hand you a .tmp file
# the loop created a moment earlier.
files=$(grep -rl "REPLACE-WITH-YOUR-DOMAIN" . \
  --exclude-dir=_source --exclude-dir=.git --exclude=README.md)

printf '%s\n' "$files" | while read -r f; do
  [ -n "$f" ] || continue
  sed "s|https://REPLACE-WITH-YOUR-DOMAIN|https://andrewhoang.com|g" "$f" > "$f.tmp" \
    && mv "$f.tmp" "$f"
done

# Confirm nothing was missed
grep -rn "REPLACE-WITH-YOUR-DOMAIN" . \
  --exclude-dir=_source --exclude-dir=.git --exclude=README.md
```

The last command should print nothing. As built today the token appears roughly 40 times
per HTML page — around 414 hits across the ten content pages, plus `404.html`, plus
`sitemap.xml`, `robots.txt` and `llms.txt`. In the browser route you would edit each file
by hand, so the terminal is genuinely worth it for this one job even if you use Route A
for everything else.

### Buying the domain

There is no good free custom domain any more. Freenom (`.tk`, `.ml`, `.ga`, `.cf`, `.gq`)
exited the free business after Meta sued it in 2023 and relaunched paid-only. `eu.org` is
genuinely free but needs manual human approval that can take weeks, and the shape of the
name reads as "I did not want to spend ten dollars." Budget **$10–12 a year** for a real
one and buy it on your personal account, under `tuananhhoang2811@gmail.com`.

It matters more for you than for most people: your `Person` schema needs a stable `@id`
that anchors the entity, you cannot control anything root-scoped on `github.io`, and
answer engines cite by domain — "according to andrewhoang.com" has an owner in a way that
"according to username.github.io" does not.

### DNS records

At your registrar's DNS panel. **Apex domain** (`andrewhoang.com`) — four A records, all
with host `@`:

```
185.199.108.153
185.199.109.153
185.199.110.153
185.199.111.153
```

Plus four AAAA records for IPv6, same host `@`:

```
2606:50c0:8000::153
2606:50c0:8001::153
2606:50c0:8002::153
2606:50c0:8003::153
```

**`www` subdomain** — one CNAME record, host `www`, value `USERNAME.github.io` (no repo
name, no path; add the trailing dot if your registrar wants one).

Then in the repository: **Settings → Pages → Custom domain** → type the domain → **Save**.
That writes a file called `CNAME` (no extension) into the repository root containing your
domain. Do not hand-edit it, and be aware that a `git push --force` can lose it, which
silently detaches the domain.

**Order of operations that avoids an afternoon of confusion:** add the DNS records
first → wait for propagation (`dig andrewhoang.com +short` returns the four GitHub IPs)
→ *then* set the custom domain in Pages. Doing it the other way round usually leaves you
staring at a greyed-out HTTPS checkbox.

**HTTPS** is free and automatic — GitHub provisions a Let's Encrypt certificate. Tick
**Enforce HTTPS** as soon as it is available; it 301s all HTTP traffic to HTTPS.
Provisioning takes minutes to 24 hours. If the checkbox is still greyed out after a day,
the cause is almost always stray DNS records pointing somewhere other than GitHub's IPs.
Remove them; then remove the custom domain in Settings → Pages, save, re-add it, save.
That re-triggers provisioning and fixes it most of the time. The domain must also be
under 64 characters or the certificate cannot be issued — not a problem for anything
you would plausibly buy.

**Pick one canonical host and let the other redirect.** Set the apex as the custom domain
and add the `www` CNAME; GitHub redirects `www` → apex for you. Do not let both resolve
independently.

### After you move the domain

1. Re-run the find-and-replace above; confirm `grep` returns nothing.
2. Add the new domain as a **new property** in Search Console. The `github.io` property
   does not carry over.
3. Resubmit `sitemap.xml` on the new property.
4. Check that `https://andrewhoang.com/robots.txt` and `/llms.txt` both load.

---

## 5. Editing the content

Open the `.html` file in any text editor. Save. Commit. That is the whole workflow.

A few things to keep true as you edit:

- **One `<h1>` per page**, and do not skip heading levels.
- **Every heading in a case study answers a question** a person would actually ask.
  That is not a style preference — it is what makes a passage retrievable on its own.
- **Every passage must survive being read alone.** A retrieval system pulls a chunk with
  no title, no nav and no byline attached. So write "Andrew Hoang increased ELSA Speak
  app installs 84% within the first three months", not "He increased them 84%". The
  second one is unusable, and if it gets quoted it misattributes.
- **Keep the figures and their sources together.** Every number on the site names the
  client, the comparison window and the source document. If you change a number, change
  it everywhere it appears — the case study, the results table on `work/index.html`, the
  homepage card, `llms.txt`, and the CV PDF. Diff them. A recruiter who finds two
  different numbers for the same project stops reading.
- **Do not add a `<meta name="keywords">` tag.** Ignored since 2009, and it reads as
  amateur to exactly the person you want to impress.
- **`404.html` stays `noindex, follow`** and stays out of `sitemap.xml`.

### Adding a new case study

The site is at fourteen pages against a plan that capped it at eleven, so weigh a ninth
case study against retiring one. Whichever way you go, here is every place a case study
has to be registered — miss one and the site contradicts itself:

1. **Create `work/<slug>.html`** by copying an existing case study, e.g.
   `work/permate.html`. Keep the slug lowercase with hyphens, and keep it stable forever.
2. **Update the `<title>`, `<meta name="description">` and `<link rel="canonical">`.**
   The canonical is `https://REPLACE-WITH-YOUR-DOMAIN/work/<slug>.html` — it must
   byte-match the `<loc>` you are about to add to the sitemap.
3. **Update the JSON-LD.** Each page carries one `<script type="application/ld+json">`
   with a single `@graph`. The sitewide nodes (`#person`, `#occupation`, `#headshot`,
   `#website`, the `#org-*` nodes, `#org-hcmc-open-university`) are identical on every
   page — leave them exactly as they are. Change only the three page-specific nodes at
   the end: `WebPage` (`…/work/<slug>.html#webpage`), `Article`
   (`…/work/<slug>.html#article`) and `BreadcrumbList` (`…/work/<slug>.html#breadcrumb`),
   plus the `headline` (keep it under 110 characters) and `description`. Never change an
   `@id` once it is published — they are the join keys that let an entity graph merge what
   it learns about you across crawls.
4. **Add the card to `work/index.html`**, and a row to the results table there.
5. **Add the `<url><loc>` to `sitemap.xml`** — no `lastmod` unless it is a real date.
6. **Add the bullet to `llms.txt`** under `## Case studies`, with the citable figure in
   the description. `llms.txt` and `sitemap.xml` must always list the same page set.
7. **Consider `index.html`** — the homepage carries eight case notes and the results
   table. A new row in that table needs all four cells filled, **including Period**:
   the column is a date range, and an employer name or a bare duration in it reads as
   a blank. Where the work sat inside an employment, the form is `Employer, dates`.
8. **Check every relative path.** From inside `work/`, the stylesheet is
   `../assets/css/site.css`, the homepage is `../index.html`, the CV is
   `../assets/andrew-hoang-resume.pdf`. Nothing starts with `/`.
9. **Re-run the validators** in section 9.

---

## 6. If you attach the web manifest

`site.webmanifest` is written and valid, but nothing references it yet, because the HTML
was finished before it existed. It only does anything once a page links to it. If you
want it active, add this line inside `<head>` on each page — note the path differs by
depth:

Root pages (`index.html`, `about.html`, `services.html`, `contact.html`, `404.html`):

```html
<link rel="manifest" href="site.webmanifest">
```

Pages inside `work/`:

```html
<link rel="manifest" href="../site.webmanifest">
```

It is genuinely optional. It affects the name and icon if someone adds the site to a
phone home screen, and nothing else. The icon it declares is your headshot at 800×800,
which is the only square image in the repository.

---

## 7. Analytics — opt-in, off by default, and think before you switch it on

**The site currently makes zero third-party requests. Every analytics option breaks
that.** That is the decision, not a footnote. `index.html` and `contact.html` both state
the zero-third-party-requests claim in visible copy on the page. If you add a beacon, you
must edit that copy too, or the site is making a claim its own Network tab disproves —
which is a worse look than having no analytics.

GitHub Pages gives you no server logs, so it really is binary: a third-party beacon, or
no traffic data at all.

**My recommendation: ship with none.** Use **Google Search Console** (section 9) for the
data that actually matters to you — impressions, queries, CTR, position. Add a beacon
only when you have a specific question Search Console cannot answer, like "does anyone
actually click the PDF link."

If you decide to add one, **GoatCounter** is the pick: about 3.5 KB, no cookies, no
fingerprinting, no consent banner, no personal data stored. Caveat worth knowing: it is
one maintainer's donation-funded project with no contractual free tier and no SLA. It is
open source and self-hostable, so the worst case is a migration.

**Paste this exactly, on the line immediately before the closing `</body>` tag, on every
page you want counted** (all fourteen, or just the ones you care about):

```html
<script data-goatcounter="https://MYCODE.goatcounter.com/count"
        async src="https://gc.zgo.at/count.js"></script>
```

Replace `MYCODE` with your GoatCounter subdomain — the one you pick when you sign up at
goatcounter.com. Nothing else in the snippet changes.

(GoatCounter's own documentation shows the `src` as `//gc.zgo.at/count.js` with a
protocol-relative `//`. I have written it as `https://` above on purpose: your site is
HTTPS-only, so there is no reason to leave the protocol ambiguous. Use the version above.)

The alternative worth knowing about is **Cloudflare Web Analytics** — free, no cookies,
needs a free Cloudflare account, and it is the only free option that gives you real-user
Core Web Vitals data. Since Core Web Vitals is a stated expertise of yours, that is a real
argument. The cost is size: its beacon is around 31 KB, roughly nine times GoatCounter's,
on a site whose whole point is that it is fast.

Microsoft Clarity (session recording) and GA4 both exist and are free, and both are the
wrong tool here: Clarity ships individual session recordings to Microsoft and needs a
consent banner in most EU readings, and GA4 is the heaviest script of the lot, needs
cookies and a consent banner, and defaults to two months of data retention that almost
everyone forgets to change to fourteen. Either would undercut the privacy story the rest
of the site tells.

---

## 8. Contact form — built and live

`contact.html` §04 carries a working Web3Forms form. The access key is installed
(`e7c5edbf-…e42e`), so there is nothing left to wire up.

**The key is public HTML on purpose.** It is a routing identifier, not a secret — that is
Web3Forms' own design, and it is what the honeypot and hCaptcha exist to protect. Do not
treat a leak of it as an incident; the worst anyone can do with it is send you mail you
could already send yourself from the form.

**One thing still to do once:** send yourself a real test submission, confirm it arrives,
and whitelist the sender. Web3Forms keeps 30 days of history — it is a delivery pipe, not
an archive, so if the notification email never arrives the submission is simply gone and
you would not know.

Neither `subject` nor `from_name` contains a domain, deliberately. The site has no custom
domain yet, and a hard-coded one would silently go stale the day it gets one — section 4
rewrites `https://REPLACE-WITH-YOUR-DOMAIN`, and these two strings have no `https://` to
match, so they would have been missed.

**What was built, and why it is shaped this way.** The section that used to read
*"There is no contact form, and that is deliberate"* is gone; keeping it beside a working
form would have been the single most obvious self-contradiction on the site. In its place
are two sections: §04 the form, §05 a build note explaining the wiring.

The distinction the copy now rests on, and the one you must not blur: a plain HTML form
makes **zero requests until someone presses submit**. The zero-requests-at-page-load
guarantee survives completely intact, and `llms.txt` was reworded to match. An embedded
form — a Google Form in an iframe is the usual one — would load a third party on **every
render**, set cookies before anyone agreed to anything, and could not be styled to match
the site. That is why this is a `<form action="…">` and not an `<iframe>`. If you ever
swap it for an embed, the claims on `contact.html` §05 and in `llms.txt` both become
false and must be rewritten first.

Free tier: 250 submissions a month, unlimited forms and domains, 30-day history, hCaptcha
spam protection. Eight a day — far more headroom than inbound enquiries will use.

Your access key sits in public HTML. That is by design: it is a routing identifier, not a
secret, which is what the honeypot and hCaptcha are for.

The styling lives in `assets/css/site.css` §5.18c and is built from existing tokens —
`--r-sm` for the field radius, `--rule-mid` for the border, `--hover` for focus and
hover. No new colours. Accessibility, since this page is itself a work sample: every
input has a real `<label for>` and no placeholder-as-label, the `autocomplete`
attributes are a WCAG 2.2 AA requirement (1.3.5 Identify Input Purpose), and the honeypot
is clipped rather than `display:none` and carries `tabindex="-1"` plus `aria-hidden` on
its wrapper so keyboard and screen-reader users never land in it. Most honeypot examples
online omit those and quietly break assistive technology.

<details>
<summary>The original paste-in snippet, kept for reference</summary>

```html
<form action="https://api.web3forms.com/submit" method="POST">
  <input type="hidden" name="access_key" value="YOUR-ACCESS-KEY-HERE">
  <input type="hidden" name="subject" value="New enquiry from andrewhoang.com">
  <input type="hidden" name="from_name" value="andrewhoang.com contact form">

  <!-- Honeypot: bots fill it, humans never see it. Hidden from assistive tech too. -->
  <input type="checkbox" name="botcheck" class="hidden" style="display:none"
         tabindex="-1" aria-hidden="true">

  <div class="field">
    <label for="cf-name">Your name</label>
    <input type="text" id="cf-name" name="name" autocomplete="name" required>
  </div>

  <div class="field">
    <label for="cf-email">Email</label>
    <input type="email" id="cf-email" name="email" autocomplete="email" required>
  </div>

  <div class="field">
    <label for="cf-org">Company <span class="hint">(optional)</span></label>
    <input type="text" id="cf-org" name="company" autocomplete="organization">
  </div>

  <div class="field">
    <label for="cf-message">What can I help with?</label>
    <textarea id="cf-message" name="message" rows="6" required></textarea>
  </div>

  <button type="submit">Send message</button>
</form>
```

</details>

Two things to change and nothing else:

1. Replace `YOUR-ACCESS-KEY-HERE` with the access key Web3Forms emails you.
2. Change `andrewhoang.com` in the two hidden fields to your real domain, so you can tell
   at a glance in your inbox where a message came from.

**About the redirect.** Web3Forms supports a `redirect` hidden field pointing at your own
thank-you page. I have left it out, because a `thanks.html` is a page that carries no
evidence and no argument — the one kind the content plan's cap exists to keep out. Without it, submitters land on Web3Forms'
generic success page — a dead end on someone else's domain. Your call: either accept that,
or build `thanks.html` (with your nav and a route back into the site) and add
`<input type="hidden" name="redirect" value="https://andrewhoang.com/thanks.html">` to the
form, knowing you are going to twelve pages.

Accessibility notes, since this page is itself a work sample: every input has a real
`<label for="…">` and no placeholder-as-label; the `autocomplete` attributes are a WCAG
2.2 AA requirement (1.3.5 Identify Input Purpose); and the honeypot carries
`tabindex="-1"` and `aria-hidden="true"` so keyboard and screen-reader users never land in
it. Most honeypot examples online omit those two attributes and quietly break assistive
technology. Do not copy those.

Things to know: your access key sits in public HTML — that is by design, it is a routing
identifier rather than a secret, which is what the honeypot and hCaptcha are for. The
30-day history means Web3Forms is a delivery pipe, not an archive: if the notification
email does not arrive, the submission is gone after 30 days. Send yourself a real test
submission on day one, confirm it arrives, and whitelist the sender.

**Keep the plain email address visible next to any form.** Senior recruiters and hiring
managers frequently prefer to email you from their own client so the thread lives in their
inbox. Forcing everyone through a form loses you contacts, and showing a real address
reads as confident.

---

## 9. Validate it before you tell anyone it exists

All free. On a site that *is* a work sample, a failing validator is a lost client. Run
them in this order:

| Tool | Where | What it checks |
|---|---|---|
| W3C HTML Validator | validator.w3.org | HTML conformance |
| W3C CSS Validator | jigsaw.w3.org/css-validator | CSS conformance |
| WAVE | wave.webaim.org | Accessibility, contrast, ARIA, heading order |
| Schema Markup Validator | validator.schema.org | Whether the JSON-LD is valid schema.org |
| Rich Results Test | search.google.com/test/rich-results | Whether it is eligible for Google rich results |
| PageSpeed Insights | pagespeed.web.dev | Core Web Vitals, Lighthouse performance / a11y / SEO |
| Google Search Console | search.google.com/search-console | Indexing, queries, CTR, position |
| Bing Webmaster Tools | bing.com/webmasters | Same for Bing |

1. **HTML and CSS validators** → fix every error; use judgement on warnings.
2. **WAVE** → zero errors, zero contrast errors. Then keyboard-test by hand: tab through
   every page, confirm the skip link appears on the first tab, confirm focus is always
   visible. WAVE cannot test focus order or reduced-motion — you have to do that yourself.
3. **Schema Markup Validator** → the JSON-LD should be valid with zero errors.
4. **Rich Results Test** → expect Breadcrumbs on inner pages, Article on case studies,
   and Profile Page on the homepage. It will report **nothing** for `Person`, `WebSite`,
   `Occupation` and `Service`. That is correct, not a failure — Google has no rich result
   for those types, and the two schema tools are not interchangeable. Run both.
   One known false alarm: the Rich Results Test warns that `Article` is missing
   `publisher.logo`. Your publisher is a `Person`, not an `Organization`, so no logo is
   required. Leave it.
5. **PageSpeed Insights**, mobile first. With no framework, no web fonts and no
   third-party requests you should be at or very near 100 across all four categories. If
   you are not, something is wrong — and for your positioning, that screenshot is a sales
   asset.
6. **Search Console** → verify the property (HTML file method on `github.io`, or DNS TXT
   once you have a custom domain), submit `sitemap.xml`, request indexing on the homepage.
7. **Bing Webmaster Tools** → sign in, choose **Import from Google Search Console**,
   authorise, pick the property. Imported sites are auto-verified; it takes under a
   minute. Do not skip it: Bing's index is a retrieval source for Copilot and has fed
   ChatGPT's browsing. Being absent from Bing while selling GEO would be an awkward thing
   to explain.

---

## 10. Pre-launch checklist

### Content — the open questions that are actually blocking

These come from the **"GAPS — ANDREW MUST SUPPLY"** section of
`_source/content-plan.md`. Read that section in full before you launch; this is the
summary. Nothing on the site was invented to paper over any of them, which is why it is
safe to ship as it stands — but each one either weakens the site or is a real risk.

- [ ] **Employment dates.** Resolved in the build, still worth your eye. Every role on
      `about.html` now carries a range, and the overlaps are labelled rather than hidden:
      the intro line says the in-house role, the agency work and the consulting projects
      are concurrent, not sequential. That is the honest reading — Mindful Organization's
      end overlaps the ELSA start by about four months, Phibious overlaps both Mindful
      Organization and Hellobacsi, and the 2017–2024 agency span overlaps everything.
      Read the eight ranges against your CV once and confirm them.
- [ ] **Permission to name clients.** This is the highest-risk item on the site. The ELSA
      Speak internal metrics — the 84% figure, the ~10x attribution correction, the
      ~20,000-URL vector database — are internal operating detail. Check your contract or
      NDA. The Phibious client names (Bridgestone, Cleanipedia, Schneider Electric) were
      agency clients, and agency NDAs commonly survive the engagement. Confirm Permate,
      InApps Technology and DrCom are comfortable being named with their figures. If
      anything comes back restricted, the section can be anonymised by sector without
      losing the mechanism.
- [ ] **Resume vs portfolio contradictions.** Five projects state different numbers in
      your two source documents — Ferrovit, Normagut, marry.vn, Dong Shop Sun and Tinh Lam
      Jewelry. The site currently uses the resume figure in every case. Confirm which is
      right. Two of these have since been settled and the site no longer matches the
      PDFs: **InApps is +116%, not +216%** (Search Console shows 7,094 clicks against
      3,278 — a 2.16x ratio, which is a 116% increase, and 216% was the ratio being read
      as the increase), and **Marry Network is +500%, not 600%**, for the same reason
      (120,000 from 20,000). The site also says organic **clicks** rather than "traffic",
      which is the more precise and more defensible claim.
- [ ] **The 24 Sep portfolio export is broken — do not ship it.**
      `Andrew Hoang Portfolio.pdf` (24 Sep, 49 pages) has the right content: it
      carries 9+ years, 70,075, 12,465, and the corrected wording. But the
      corrections were **added, not applied**. On pages 3 and 24 the new strings
      (+116% Organic click growth, maintained at marrybaby.vn, AUG 2024 – MAR 2026,
      AUG 2024 – JUL 2025) sit at coordinate **x=0, y=11** — the bottom-left corner
      of the page — while the originals stay in place at their real positions. So
      the page still READS 116% Organic traffic growth, built at marrybaby.vn and
      2024 – PRESENT, and text extraction returns both versions at once.
      The site was rolled back to the 43-page deck. Re-export with the fixes applied
      to the source text rather than overlaid, then swap the file and update the
      "43 pages" and "17 MB" wording in index, about, contact, work/index and llms.txt.

- [ ] **The two PDFs contradict the site.** `assets/andrew-hoang-portfolio.pdf` is linked
      from `index.html`, `work/index.html` and `llms.txt`, so a reader can hold both open
      at once. Fix these at the deck and CV source, then re-export — they cannot be
      patched safely inside the PDF:
      - **InApps is over.** Deck p18 and every resume PDF still read `2024 – Present`.
        The engagement ran **Aug 2024 – Mar 2026**, which is what the site now says
        everywhere it dates the engagement.
      - **Marry Network** reads `600%` on deck p18 and in the resume; the site says
        `+500%`. The before/after pair is printed beside it, so the deck refutes itself.
      - **InApps** reads `216%` in the resume; the site says `116%`.
      - **Wording.** `organic traffic growth` should be `organic click growth` — clicks
        are what Search Console actually reports and what the site claims. The `+` is
        missing from `116%`, `285%` and `500%`; without it they read as absolute levels
        rather than increases.
      - **Deck p3** says `2M Monthly traffic built at marrybaby.vn`. It was **maintained**,
        not built — the site and the deck body both describe it as held steady.
      - **Years of experience.** The site now says **nine years** everywhere (13 JSON-LD
        descriptions plus the client-cloud heading). Deck p2 still reads `8+ Years`.
        Nine is the span from the first role, Golden Period in July 2017; 8+ counted
        only the months actually inside a role, which excludes the six-month gap in
        2019. Both were true, which is why they drifted — pick nine and keep it.
        `Andrew Hoang AI.pdf`, `PPC.pdf` and `QA.pdf` already say nine; the shipped
        CV states no figure at all.

- [ ] **"What I would do differently."** Each case study ends with one. Those points are
      conservative inferences from your source material — defensible, but not your words.
      This is the strongest seniority signal on the site and the easiest to be caught out
      on in an interview. Read all of them and approve or replace each one.
- [ ] **Headshot alt text.** Currently "Andrew Hoang, photographed against a plain
      background." If that is not accurate, supply the correct description. Wrong alt text
      is an accessibility failure, not a cosmetic one.
- [ ] **Optional upgrades, if you want them:** testimonials (none exist in the source, and
      this is the single largest available improvement), screenshots as visual evidence,
      consulting rates or availability on `services.html`, language proficiency, work
      authorisation, and team size at ELSA Speak.

### Technical

- [ ] `_source/` is **not** in the repository. Check the GitHub file list with your eyes.
- [ ] `curl -sI https://your-domain/_source/resume.txt` returns `404`.
- [ ] `.nojekyll` is present at the repository root.
- [ ] `.gitignore` still contains `_source/`.
- [ ] No `href="/…"` or `src="/…"` anywhere:
      `grep -rn 'href="/\|src="/' --include="*.html" .` returns nothing.
- [ ] **A test submission from the contact form arrived in the inbox**, and the sender is
      whitelisted. The key itself is already installed. See section 8.
- [ ] Every `REPLACE-WITH-YOUR-DOMAIN` is replaced:
      `grep -rn "REPLACE-WITH-YOUR-DOMAIN" . --exclude-dir=_source --exclude-dir=.git --exclude=README.md`
      returns nothing. (README.md is excluded on purpose — see section 4.)
- [ ] Repository is named `USERNAME.github.io` so `robots.txt` is actually honoured.
- [ ] `robots.txt`, `sitemap.xml`, `llms.txt` and `humans.txt` all load at the site root.
- [ ] `sitemap.xml` and `llms.txt` list the same set of pages.
- [ ] Every `<loc>` in the sitemap byte-matches that page's `<link rel="canonical">`.
- [ ] `404.html` is `noindex, follow` and is not in the sitemap.
- [ ] Site loads. DevTools → Network → **zero** third-party domains.
- [ ] W3C HTML validator: zero errors. CSS validator: zero errors.
- [ ] WAVE: zero errors, zero contrast errors. Tab through every page by hand.
- [ ] validator.schema.org: JSON-LD valid. Rich Results Test: run it.
- [ ] PageSpeed Insights mobile: 100 across the board, or you know exactly why not.
- [ ] Test at 320px and at 2560px — no horizontal scroll at either.
- [ ] Toggle OS dark mode, then the site's own toggle, then reload — the choice persists.
- [ ] Enforce HTTPS is ticked.
- [ ] Search Console: verified, sitemap submitted, homepage indexing requested.
- [ ] Bing Webmaster Tools: imported from Search Console.
- [ ] Buy the domain.

---

## 11. Limits, and things to re-check in six months

GitHub Pages: source repository 1 GB (recommended), published site 1 GB (hard), bandwidth
100 GB/month (soft), builds 10 per hour (soft). "Soft" means GitHub contacts you rather
than cutting you off. Your site is a few megabytes — at that size, 100 GB is roughly
33,000 full page loads a month. The builds limit is the only one you can realistically
trip, and only by pushing eleven commits in an hour while fiddling. Batch your commits.

One clause worth knowing: Pages is not permitted to be used as free hosting for an online
business or anything primarily directed at facilitating commercial transactions. A
consultant's portfolio that *describes* services is squarely fine and is one of the most
common uses of Pages. If you ever add a payment button, a booking checkout or a client
login, you have moved outside the terms and need real hosting. GitHub also says Pages
should not be used for sensitive transactions — do not collect anything sensitive through
it.

**Set a calendar reminder for six months out** to re-verify three things: the Web3Forms
free-tier limit if you added the form (form-backend free tiers get trimmed routinely —
Formspree's is already down to 50 a month), the GoatCounter free tier if you added
analytics, and that the four GitHub Pages IP addresses still match GitHub's documentation
if you are on a custom domain. Ten minutes, and it prevents a silently broken contact form.

---

## 12. Credits

Written and built for Andrew Hoang (Hoang Tuan Anh), Ho Chi Minh City, Vietnam.
Content traces to `_source/resume.txt` and `_source/portfolio.txt`. No metrics,
testimonials, quotes, awards or dates were invented.

Icons are inline SVG. If you add any from a third-party set, keep the licence notice in
source — a comment in the CSS or a line here is enough, e.g.
`/* Icons: Lucide (ISC) — https://lucide.dev */`. Never hotlink an icon set or load an
icon font; it would break the zero-third-party-requests rule.

A note on client logos: putting ELSA, Bridgestone, Cleanipedia or Schneider Electric
*logos* on the site is a trademark question, not a licence question, and it depends on
your agreements with them. Text-only client names in prose — which is what the site does
today — are the safer default.
