FROM denoland/deno:latest

EXPOSE 8000

WORKDIR /app

# Set an environment variable for the URL
# override env with -e or .env
ENV DENO_URL="https://raw.githubusercontent.com/evbogue/deno-mini-chat/master/serve.js"

USER deno

# Use shell form to allow variable substitution
CMD sh -c "deno run --allow-all --unstable $DENO_URL"

# this is now built as bitovi/deno-demo:latest