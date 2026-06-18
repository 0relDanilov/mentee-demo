FROM python:3.11-slim

WORKDIR /app

ARG APP_VERSION=dev
ENV APP_VERSION=${APP_VERSION}

EXPOSE 8080

COPY hello_world.py .

CMD ["python", "hello_world.py"]
