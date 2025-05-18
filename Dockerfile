FROM python:3.13-slim AS builder
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Copy only the requirements file first to leverage Docker cache
COPY pyproject.toml ./

# Install dependencies using the copied UV
RUN uv pip install --system --no-cache -r pyproject.toml


# ---- Runner Stage ----
FROM python:3.13-slim AS runner

WORKDIR /app

# Create a dedicated group and user for your application
ARG APP_USER=django_user
ARG APP_GROUP=django_user
RUN groupadd --gid 1000 $APP_GROUP && \
    useradd --uid 1000 --gid $APP_GROUP --shell /bin/bash $APP_USER

   

COPY --from=builder /usr/local/lib/python3.13/site-packages/ /usr/local/lib/python3.13/site-packages/

COPY --chown=django_user:django_user . /app

RUN chmod +x /app/entrypoint.sh
RUN mkdir -p /app/staticfiles /app/volume && chown django_user:django_user /app/staticfiles /app/volume


USER django_user 

EXPOSE 8000

# Set the entrypoint script
#ENTRYPOINT ["/app/entrypoint.sh"]

#CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]