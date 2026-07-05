#!/usr/bin/env python3
import sys
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import subprocess
import urllib.parse

HOST = "0.0.0.0"
PORT = 8080
GENERATOR = Path("/opt/airctl/sub/generator.py")


class SubHandler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        sys.stderr.write("[airctl-sub] " + fmt % args + "\n")

    def send_text(self, code, body, content_type="text/plain; charset=utf-8"):
        data = body.encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path.strip("/").split("/")

        if len(path) != 2 or path[0] != "sub":
            self.send_text(404, "Not Found\n")
            return

        token = path[1].strip()

        if not token:
            self.send_text(400, "Missing token\n")
            return

        try:
            result = subprocess.run(
                [str(GENERATOR), token],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                timeout=5,
            )
        except subprocess.CalledProcessError as e:
            msg = e.stderr.strip() or "Invalid subscription"
            self.send_text(403, msg + "\n")
            return
        except Exception as e:
            self.send_text(500, f"Internal error: {e}\n")
            return

        self.send_text(
            200,
            result.stdout,
            "text/yaml; charset=utf-8",
        )


def main():
    server = ThreadingHTTPServer((HOST, PORT), SubHandler)
    print(f"[airctl-sub] listening on {HOST}:{PORT}", flush=True)
    server.serve_forever()


if __name__ == "__main__":
    main()
