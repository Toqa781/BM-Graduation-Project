# Use a lightweight Python image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /api

# Install necessary system dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
       gcc \
       pkg-config \
       libssl-dev \
       libsasl2-dev \
       default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the dependencies file first for better Docker caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Expose the port on which the Flask app runs
EXPOSE 5001

# Set the default command to run the application
CMD ["python", "app.py"]
