import os

APP_VERSION = os.getenv("APP_VERSION", "dev")

print("Hello from CI/CD!")
print("Pipeline demo - auto-trigger working.")
print(f"App version: {APP_VERSION}")
