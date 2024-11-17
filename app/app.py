from flask import Flask, render_template, request, redirect, url_for
import requests
import os

app = Flask(__name__)

# API URL configuration: Default to Docker's API service, or use environment variable for deployment
API_URL = os.environ.get("API_URL", "http://api:5001")


@app.route("/", methods=["GET", "POST"])
def index():
    """
    Main route for the frontend.
    Handles displaying quotes and adding new ones.
    """
    if request.method == "POST":
        # Capture quote and author from the form
        quote = request.form.get("quote")
        author = request.form.get("author")

        if not quote or not author:
            return "Error: Both quote and author fields are required.", 400

        try:
            # POST request to the API to add a new quote
            response = requests.post(f"{API_URL}/api/quotes", json={"quote": quote, "author": author})
            if response.status_code == 201:
                return redirect(url_for("index"))
            else:
                return f"Error: Unable to save quote. API responded with status code {response.status_code}.", 500
        except requests.exceptions.RequestException as e:
            # Handle API connection errors
            print(f"Error connecting to API: {e}")
            return "Error: Unable to connect to the API.", 500

    else:
        try:
            # GET request to fetch all quotes from the API
            response = requests.get(f"{API_URL}/api/quotes")
            if response.status_code == 200:
                quotes = response.json()
            else:
                quotes = []
                print(f"Error: API responded with status code {response.status_code}")
        except requests.exceptions.RequestException as e:
            # Handle API connection errors
            quotes = []
            print(f"Error connecting to API: {e}")

        # Render the main page with quotes
        return render_template("index.html", quotes=quotes)


if __name__ == "__main__":
    # Use the PORT environment variable, defaulting to 5002 for local development
    port = int(os.environ.get("PORT", 5002))
    app.run(host="0.0.0.0", port=port)
