#!/usr/bin/env python3
"""staging-server.py - serve this site locally the way GitHub Pages will.

    python staging-server.py [port]        # explicit port
    PORT=9001 python staging-server.py     # port from the environment
    python staging-server.py               # default 8080

Port resolution, in order: the command-line argument, then $PORT, then 8080.
$PORT is how an editor's preview hands over a free port when it is allowed to
pick one; PORT=0 lets the OS choose and the chosen port is printed.

Four differences from `python -m http.server`, each one there for a reason:

  * /_source/ returns 404. That directory is in .gitignore, so it never
    reaches the repository and never gets deployed. A plain file server would
    serve it happily and you would end up reviewing a site that is not the
    site that ships.
  * A missing path renders 404.html with a real 404 status, the same as
    GitHub Pages does. This is the only way to actually test the 404 page.
  * Directory listings are off. GitHub Pages does not generate them, so
    neither should staging.
  * Binds to 127.0.0.1 only. This is a review server, not a host. Nothing
    outside this machine can reach it.

Every page is still noindex and robots.txt still disallows everything, so the
staging posture of the site itself is unchanged. Run ./go-live.sh to reverse
that, but only once the site is on its real domain.
"""

import os
import sys
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer

ROOT = os.path.dirname(os.path.abspath(__file__))

# Paths that exist on disk but are not part of the deployed site.
BLOCKED = ("/_source/", "/.omc/", "/.claude/", "/.git/")


class StagingHandler(SimpleHTTPRequestHandler):
    def send_head(self):
        clean = self.path.split("?", 1)[0].split("#", 1)[0]
        if not clean.startswith("/"):
            clean = "/" + clean
        if any(clean.startswith(prefix) for prefix in BLOCKED):
            self.send_error(404)
            return None
        return super().send_head()

    def end_headers(self):
        # Staging must never serve a stale asset. Without this the browser
        # keeps an edited stylesheet cached and you review the previous
        # version while believing you are looking at the current one.
        self.send_header("Cache-Control", "no-store, must-revalidate")
        super().end_headers()

    def list_directory(self, path):
        # No index.html here. On GitHub Pages that is a 404, not a listing.
        self.send_error(404)
        return None

    def send_error(self, code, message=None, explain=None):
        if code == 404:
            page = os.path.join(ROOT, "404.html")
            if os.path.isfile(page):
                with open(page, "rb") as fh:
                    body = fh.read()
                self.send_response(404)
                self.send_header("Content-Type", "text/html; charset=utf-8")
                self.send_header("Content-Length", str(len(body)))
                self.end_headers()
                if self.command != "HEAD":
                    self.wfile.write(body)
                return
        super().send_error(code, message, explain)


class StagingServer(ThreadingHTTPServer):
    # http.server sets allow_reuse_address for the usual reason: so a restart
    # is not blocked by the previous socket sitting in TIME_WAIT. On Windows
    # SO_REUSEADDR means something else entirely — it lets a second process
    # bind a port another process is actively serving, and requests then land
    # on whichever instance the OS feels like. Two staging servers disagreeing
    # about what the site looks like is worse than a refusal, so on Windows
    # the port has to be genuinely free.
    allow_reuse_address = os.name != "nt"


def resolve_port():
    """An explicit argument beats $PORT, which beats the default.

    The argument comes first because typing a port is an instruction, not a
    preference. $PORT comes next because that is how a preview assigns a free
    one. A bad value is worth failing on loudly rather than silently falling
    back to 8080 and binding somewhere the caller is not looking.
    """
    if len(sys.argv) > 1:
        source, raw = "argument", sys.argv[1]
    elif os.environ.get("PORT", "").strip():
        source, raw = "$PORT", os.environ["PORT"].strip()
    else:
        return 8080, "default"
    try:
        port = int(raw)
    except ValueError:
        sys.exit("staging: %s is not a number: %r" % (source, raw))
    if not 0 <= port <= 65535:
        sys.exit("staging: %s out of range: %d" % (source, port))
    return port, source


def main():
    port, source = resolve_port()
    handler = partial(StagingHandler, directory=ROOT)
    # Threading matters: a single page pulls CSS, JS and images over several
    # sockets at once, and a single-threaded server serialises them and stalls.
    try:
        server = StagingServer(("127.0.0.1", port), handler)
    except OSError as exc:
        sys.exit("staging: cannot bind port %d (%s): %s" % (port, source, exc))
    # With port 0 the OS picks one, so report what was actually bound rather
    # than what was asked for. The printed URL is then always a working URL.
    port = server.server_address[1]
    print("staging: http://127.0.0.1:%d/  (port from %s, root: %s)" % (port, source, ROOT))
    print("_source/ is blocked, 404.html is live, listings are off")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nstaging server stopped")


if __name__ == "__main__":
    main()
