#!/bin/sh
# go-live.sh — point the site at a real domain and open it to search engines.
#
#   ./go-live.sh yourdomain.com
#   ./go-live.sh                 # only if the domain is already substituted
#
# The production robots.txt is embedded below, so it travels with the
# repository. Nothing outside this file is needed.
set -e
cd "$(dirname "$0")"

DOMAIN="$1"
# On a re-run the placeholder is already gone from the pages, but the robots.txt
# heredoc below still carries it, so the domain has to come from somewhere.
# The canonical on the homepage is the site's own statement of what it is.
if [ -z "$DOMAIN" ] && [ -f index.html ]; then
  DOMAIN=$(sed -n 's|.*<link rel="canonical" href="https://\([^/"]*\).*||p' index.html | head -1)
  case "$DOMAIN" in REPLACE-WITH-YOUR-DOMAIN|"") DOMAIN="" ;; esac
fi
LIVE='<meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">'
PLACEHOLDER='REPLACE-WITH-YOUR-DOMAIN'

# `sed -i ''` is BSD syntax. GNU sed reads the '' as the SCRIPT and then
# treats the real expression as a filename, so on Linux and on Git Bash the
# previous version of this script replaced nothing at all. Writing through a
# temp file behaves the same everywhere and needs no -i.
edit() {
  f=$1; shift
  tmp="$f.golive.tmp"
  sed "$@" "$f" > "$tmp"
  mv "$tmp" "$f"
}

die() { echo "go-live: $1" >&2; exit 1; }

# ---------------------------------------------------------------- domain ---
# Canonicals, og:url, the sitemap and llms.txt all carry the domain. Opening
# the site to crawlers while those still say REPLACE-WITH-YOUR-DOMAIN would
# publish a set of canonical URLs that resolve nowhere, which is worse than
# staying closed. So this refuses rather than half-finishing.
left=$(grep -rl "$PLACEHOLDER" . --include='*.html' --include='*.txt' --include='*.xml' 2>/dev/null | wc -l | tr -d ' ')
if [ "$left" -gt 0 ]; then
  [ -n "$DOMAIN" ] || die "$left files still say $PLACEHOLDER.
  Run:  ./go-live.sh yourdomain.com"
  case "$DOMAIN" in
    http*|*/*) die "pass a bare host, not a URL: ./go-live.sh example.com" ;;
    *.*) : ;;
    *) die "'$DOMAIN' does not look like a domain" ;;
  esac
  d=0
  for f in $(grep -rl "$PLACEHOLDER" . --include='*.html' --include='*.txt' --include='*.xml' 2>/dev/null); do
    edit "$f" "s|$PLACEHOLDER|$DOMAIN|g"
    grep -q "$PLACEHOLDER" "$f" && die "substitution failed in $f"
    d=$((d+1))
  done
  echo "domain: $PLACEHOLDER -> $DOMAIN in $d files"
fi

# ---------------------------------------------------------------- indexing ---
# 404.html is deliberately skipped: it carries "noindex, follow", not
# "noindex, nofollow", so the pattern below cannot match it.
n=0
for f in *.html work/*.html; do
  [ -f "$f" ] || continue
  grep -q 'STAGING: site is hidden from search engines' "$f" || continue
  edit "$f" \
    -e '/<!-- STAGING: site is hidden from search engines/d' \
    -e "s|<meta name=\"robots\" content=\"noindex, nofollow\">|$LIVE|"
  # Verify rather than assume. A deploy script that reports success it did
  # not achieve is the one failure mode that cannot be caught later.
  grep -q 'content="index, follow' "$f" || die "$f was not opened to indexing"
  grep -q 'noindex, nofollow' "$f" && die "$f still carries noindex"
  n=$((n+1))
done
[ "$n" -gt 0 ] || die "no staging pages found — has this already been run?"

cat > robots.txt <<'ROBOTS_EOF'
# robots.txt — Andrew Hoang (Hoang Tuan Anh)
# https://REPLACE-WITH-YOUR-DOMAIN/
#
# Posture: open. This site exists to be crawled, read, quoted and cited —
# by search engines and by AI answer engines alike. Nothing here is gated.
# Attribution requested: "Andrew Hoang".
#
# One directory is closed: /_source/ holds raw working notes and is not
# published. See the note at the bottom of this file.
#
# NOTE ON THE REPEATED Disallow LINES: robots.txt groups do not inherit.
# A crawler that matches a named group ignores the "User-agent: *" group
# completely, so the Disallow has to be restated inside every group.
# That is why it appears more than once below. This is correct, not a typo.


# --- Default: every crawler not named below --------------------------------
User-agent: *
Allow: /
Disallow: /_source/


# --- Search engine crawlers ------------------------------------------------
User-agent: Googlebot
User-agent: Googlebot-Image
User-agent: Bingbot
User-agent: Slurp
User-agent: DuckDuckBot
User-agent: Applebot
User-agent: YandexBot
User-agent: Baiduspider
User-agent: Coccocbot
Allow: /
Disallow: /_source/


# --- AI training and AI answer-engine crawlers: explicitly welcome ---------
# These are the crawlers behind ChatGPT, Claude, Gemini, Perplexity, Copilot
# and the open training corpora. A site about answer-engine optimisation that
# blocked them would be refuting its own argument.
User-agent: GPTBot
User-agent: OAI-SearchBot
User-agent: ChatGPT-User
User-agent: ClaudeBot
User-agent: Claude-User
User-agent: Claude-SearchBot
User-agent: anthropic-ai
User-agent: Google-Extended
User-agent: Applebot-Extended
User-agent: PerplexityBot
User-agent: Perplexity-User
User-agent: CCBot
User-agent: Meta-ExternalAgent
User-agent: Meta-ExternalFetcher
User-agent: Amazonbot
User-agent: Bytespider
User-agent: DuckAssistBot
User-agent: MistralAI-User
User-agent: cohere-ai
User-agent: YouBot
User-agent: Diffbot
User-agent: ImagesiftBot
User-agent: Timpibot
User-agent: AI2Bot
Allow: /
Disallow: /_source/


# --- SEO tooling crawlers: allowed, this site is a public work sample ------
User-agent: AhrefsBot
User-agent: SemrushBot
User-agent: Screaming Frog SEO Spider
User-agent: rogerbot
User-agent: dotbot
Allow: /
Disallow: /_source/


# --- Sitemap ---------------------------------------------------------------
Sitemap: https://REPLACE-WITH-YOUR-DOMAIN/sitemap.xml


# --- About /_source/ -------------------------------------------------------
# /_source/ holds raw resume and portfolio extracts and internal planning
# notes. It is excluded from git (.gitignore) so it is never pushed to the
# repository and therefore never served. The Disallow above is a second layer,
# not the primary defence — Disallow asks politely, it does not restrict
# access. If /_source/ is ever committed by accident, anyone with the URL can
# read it. Keep it out of the repo.
#
# Machine-readable companions to this file:
#   /sitemap.xml       — every indexable URL
#   /llms.txt          — curated site map for LLM agents (comprehension, not access)
#   /humans.txt        — who built this
ROBOTS_EOF

# The heredoc above is single-quoted on purpose — nothing inside it should
# expand — which means it writes the placeholder back. Substitute it here.
[ -n "$DOMAIN" ] || die "no domain known; run ./go-live.sh yourdomain.com"
edit robots.txt "s|$PLACEHOLDER|$DOMAIN|g"
grep -q "$PLACEHOLDER" robots.txt && die "robots.txt still carries the placeholder"
grep -q "Sitemap: https://$DOMAIN/sitemap.xml" robots.txt || die "robots.txt has no correct Sitemap line"

echo
echo "opened $n pages to indexing and restored the production robots.txt"
echo "404.html stays noindex. That is correct — leave it."
echo
echo "Still to do by hand:"
echo "  1. bump dateModified in the JSON-LD — it still reads 2026-09-13/14"
echo "  2. git add -A && git commit -m 'Open site to search engines' && git push"
echo "  3. Google Search Console -> submit https://$DOMAIN/sitemap.xml"
echo "  4. Bing Webmaster Tools -> import from Search Console"
