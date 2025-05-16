#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Echo commands
# set -x # Uncomment for debugging

# It's good practice to wait for the database to be ready, especially in production-like setups.
# This is a simple example; for robust production setups, consider a more advanced wait script.
# Example for PostgreSQL (requires psql client, which might not be in your slim image):
# until PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c '\q'; do
#  >&2 echo "Postgres is unavailable - sleeping"
#  sleep 1
# done
# >&2 echo "Postgres is up - continuing"

# Apply database migrations
echo "Applying database migrations..."
python manage.py migrate --noinput

# Collect static files
# The --noinput flag prevents Django from prompting for input.
# The --clear flag clears the existing static files before collecting.
echo "Collecting static files..."
python manage.py collectstatic --noinput --clear

# Then exec the container's main process (what's specified as CMD in Dockerfile or command in docker-compose.yml)
# This replaces the shell with the command, allowing it to receive signals correctly.
echo "Starting server..."
exec "$@"
