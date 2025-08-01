# Use python 3.12-slim as the base image
FROM python:3.12-slim-bullseye

# Install system dependencies for WeasyPrint and other libraries
# THIS IS THE CRITICAL STEP THAT REPLACES THE NIXPACKS VARIABLE
# It tells the Docker builder to use the container's package manager
# to install the required system libraries.
RUN apt-get update && apt-get install -y \
    libcairo2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgdk-pixbuf2.0-0 \
    libffi-dev \
    shared-mime-info \
    libgobject-2.0-0 \
    libpq-dev \
    libjpeg-dev \
    gcc \
    # Good practice to clean up apt cache in a single command
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# The rest of your Dockerfile, simplified and corrected
# ... (removed the unnecessary virtual environment setup and NIXPACKS_PKGS lines)

# Set Python-related environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create and set the working directory
WORKDIR /code

# Copy the requirements file and install Python dependencies
COPY requirements.txt requirements_railway.txt ./
# The --no-cache-dir flag helps keep image size small
RUN pip install --no-cache-dir -r requirements_railway.txt

# Copy the project code
COPY ./src /code

# Define Django project name
ARG PROJ_NAME="arvmain"

# Create a bash script to run the Django project
# The original script is fine, so we will keep it.
RUN printf "#!/bin/bash\n" > ./paracord_runner.sh && \
    printf "RUN_PORT=\"\${PORT:-8000}\"\n\n" >> ./paracord_runner.sh && \
    printf "python manage.py migrate --no-input\n" >> ./paracord_runner.sh && \
    printf "gunicorn ${PROJ_NAME}.wsgi:application --bind \"[::]:\$RUN_PORT\"\n" >> ./paracord_runner.sh

# Make the bash script executable
RUN chmod +x paracord_runner.sh

# This is the final CMD instruction. It will override any previous ones.
CMD ["./paracord_runner.sh"]