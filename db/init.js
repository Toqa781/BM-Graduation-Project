-- Create quotes table in the quotesdb database
CREATE TABLE IF NOT EXISTS quotes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    quote TEXT NOT NULL,
    author VARCHAR(255) NOT NULL
);

-- Insert a sample quote
INSERT INTO quotes (quote, author) VALUES
    ("The only limit to our realization of tomorrow is our doubts of today.", "Franklin D. Roosevelt"),
    ("Do not go where the path may lead, go instead where there is no path and leave a trail.", "Ralph Waldo Emerson");
