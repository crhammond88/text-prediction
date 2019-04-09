Text Prediction Shiny App
========================================================
author: Chris Hammond
autosize: true

<br/>

The application predicts the next word, or sequence of words, in a given text sequence using a simple backoff algorithm. It also
contains a word suggestion algorithm that matches letters from a given text sequence to find similar words.

The application was created for the [Data Science Capstone](https://www.coursera.org/learn/data-science-project/) from Johns Hopkins University and Coursera in cooperation with SwiftKey.


How to Use the App
========================================================
right: 70% 

<br/>
![Control Panel](controlPanel.JPG)
***
The Control Panel on the left allows you to change four variables:

1. The text that will be used to make the predictions.
2. The data model used to make the predictions.
4. The maximum number of words used from the input text to make the predictions.
3. The maximum number of words predicted for each tool.



Tools
========================================================

#####     Next Word

* Displays the next word predicted, based on the current text input, on the bottom-right of the app. A word cloud displays other 
potential predictions.

#####     More Words

* Press the "Next Words" button to rapidly predict a sequence of words. The button can be pressed repeatedly to continue 
predicting words in the sequence.

#####     Word Suggestion

* Displays a list of words with letter groupings that match the last word entered in the text input. Similar to spellcheck or "Did you mean ________?" features.


Models & Algorithms
========================================================
There are four data models to explore in the app. The data was cleaned and filtered then tokenized into separate grams of one to five words. The frequency of each gram was then calculated to use as a statistical basis for predicting the most likely word in a sequence.

The next word prediction algorithm uses one to four words to predict the next word by searching for matching word sequences in the corresponding model. The algorithm will begin by trying to match the longest sequence of words possible, then reduces its search by one word at a time until a match is found. If multiple matches are found with the same number of search words, the match with the highest frequency is then selected as the primary prediciton. If no match is found, the most frequent individual words in the current model are used as a default.


Accuracy
========================================================
![Validation Screenshot](validationResults.JPG)

An independent dataset of news articles was used for validating the models for a more unbiased result. The results show that predictions are most accurate when using two words to predict a third. 

The context of the source text is also very important to the accuracy of the predictions. The news model achieved the highest performance due to the similarity of writing style in the validation set of news articles. The twitter model performed particularly poorly. The combination model achieved nearly as high of an accuracy rating as the news model, and it's expected to produce the best results across different types of text. 







