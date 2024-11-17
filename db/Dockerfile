# Use the official MySQL image from Docker Hub
FROM mysql:latest

# Set environment variables for the MySQL database
ENV MYSQL_DATABASE=quotesdb \
    MYSQL_ROOT_PASSWORD=root \
    MYSQL_USER=user \
    MYSQL_PASSWORD=password

# Copy your SQL initialization script into the container
COPY init.sql /docker-entrypoint-initdb.d/

# Expose the default MySQL port
EXPOSE 3306
