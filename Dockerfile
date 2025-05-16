FROM python:3.13-slim as builder
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Copy only the requirements file first to leverage Docker cache
COPY pyproject.toml ./

# Install dependencies using the copied UV
RUN uv pip install --system --no-cache -r pyproject.toml

# ---- Runner Stage ----
FROM python:3.13-slim as runner

WORKDIR /app

RUN groupadd -r django_user && useradd -r -g django_user django_user

COPY --from=builder /usr/local/lib/python3.13/site-packages/ /usr/local/lib/python3.13/site-packages/

COPY --chown=django_user:django_user . /app

RUN chmod +x /app/entrypoint.sh
RUN mkdir -p /app/staticfiles && chown django_user:django_user /app/staticfiles

USER django_user

EXPOSE 8000

# Set the entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]