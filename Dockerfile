# Use python 3.12-slim as the base image
FROM python:3.12-slim-bullseye

# Create a virtual environment
RUN python -m venv /opt/venv

# Set the virtual environment as the current location
ENV PATH=/opt/venv/bin:$PATH

# Upgrade pip
RUN pip install --upgrade pip

# Install system dependencies for WeasyPrint and other libraries
RUN apt-get update && apt-get install -y \
    # WeasyPrint dependencies (provides libgobject-2.0-0)
    libglib2.0-0 \
    libcairo2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgdk-pixbuf2.0-0 \
    libffi-dev \
    shared-mime-info \
    # Other dependencies
    libpq-dev \
    libjpeg-dev \
    gcc \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set Python-related environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create and set the working directory
RUN mkdir -p /code
WORKDIR /code

# Copy the requirements file and install Python dependencies
COPY requirements.txt /tmp/requirements.txt
COPY requirements_railway.txt /tmp/requirements_railway.txt
RUN pip install --no-cache-dir -r /tmp/requirements_railway.txt

# Copy the project code
COPY ./src /code

ARG DJANGO_SECRET_KEY
ENV DJANGO_SECRET_KEY=${DJANGO_SECRET_KEY}

ARG DJANGO_DEBUG=0
ENV DJANGO_DEBUG=${DJANGO_DEBUG}

# database isn't available during build
# run only commands that do not need the database. can remove when we use s3
RUN python manage.py vendor_pull
RUN python manage.py collectstatic --noinput

# Define Django project name
ARG PROJ_NAME="arvmain"

# Create a bash script to run the Django project
RUN printf "#!/bin/bash\n" > ./paracord_runner.sh && \
    printf "RUN_PORT=\"\${PORT:-8000}\"\n\n" >> ./paracord_runner.sh && \
    printf "python manage.py migrate --no-input\n" >> ./paracord_runner.sh && \
    printf "gunicorn ${PROJ_NAME}.wsgi:application --bind \"[::]:\$RUN_PORT\"\n" >> ./paracord_runner.sh

# Make the bash script executable
RUN chmod +x paracord_runner.sh

# This is the final CMD instruction. It will override any previous ones.
CMD ["./paracord_runner.sh"]