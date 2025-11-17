--You need to take every word from both tables and count each individual letter that appears in those words.
--The filename column must not be used.
--You must find the three letters that appear the most times across all the text.
--Return the letter and its count, ordered by count in descending order.

CREATE TABLE google_file_store
(
    contents VARCHAR(MAX),
    filename VARCHAR(255)
);

CREATE TABLE google_word_lists
(
    words1 VARCHAR(MAX),
    words2 VARCHAR(MAX)
);
INSERT INTO google_file_store (contents, filename) VALUES
('This is a sample content with some words.', 'file1.txt'),
('Another file with more words and letters.', 'file2.txt'),
('Text for testing purposes with various characters.', 'file3.txt');

INSERT INTO google_word_lists (words1, words2) VALUES
('apple banana cherry', 'dog elephant fox'),
('grape honeydew kiwi', 'lemon mango nectarine'),
('orange papaya quince', 'raspberry strawberry tangerine');



--SQL Query

WITH AllText AS
(
    SELECT contents AS txt
    FROM google_file_store
    UNION ALL
    SELECT words1 FROM google_word_lists
    UNION ALL
    SELECT words2 FROM google_word_lists
),
SplitLetters AS
(
    SELECT 
        LOWER(SUBSTRING(txt, v.number, 1)) AS letter
    FROM AllText
    JOIN master..spt_values v
        ON v.type = 'P'
       AND v.number BETWEEN 1 AND LEN(txt)
),
Filtered AS
(
    SELECT letter
    FROM SplitLetters
    WHERE letter LIKE '[a z]'
),
Counts AS
(
    SELECT letter, COUNT(*) AS total_count
    FROM Filtered
    GROUP BY letter
)
SELECT TOP 3 letter, total_count
FROM Counts
ORDER BY total_count DESC;
