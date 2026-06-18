import os
from http.server import BaseHTTPRequestHandler, HTTPServer

APP_VERSION = os.getenv("APP_VERSION", "dev")
PORT = int(os.getenv("PORT", "8080"))

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.end_headers()
        message = f"Hello from CI/CD!\nApp version: {APP_VERSION}\n"
        self.wfile.write(message.encode())

    def log_message(self, format, *args):
        print(f"{self.address_string()} - {format % args}")

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", PORT), Handler)
    print(f"Hello from CI/CD! Serving on port {PORT}, version {APP_VERSION}")
    server.serve_forever()
