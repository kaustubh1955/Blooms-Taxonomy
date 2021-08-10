import os
import pickle
import re
import shutil
import string
import weakref

import dill
import docx2txt
import keras
import nltk
import numpy as np  # linear algebra
import pandas as pd  # data processing, CSV file I/O (e.g. pd.read_csv)
import pyttsx3
import tensorflow
from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from gtts import gTTS
from keras.layers import LSTM, Dense, Flatten
from keras.layers.embeddings import Embedding
from keras.models import Sequential
from keras.preprocessing.sequence import pad_sequences
from keras.preprocessing.text import Tokenizer, one_hot
from nltk.tokenize import word_tokenize
from numpy import array
from pdfminer.high_level import extract_text
from playsound import playsound
from pydantic import BaseModel
from PyPDF2 import PdfFileReader
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, confusion_matrix
from sklearn.model_selection import train_test_split

app=FastAPI()

db=[]

@app.get('/')
def index():
	return {'key': 'value'}

@app.post('/uploadFile')
async def accept_pdf(myfile: UploadFile = File(...)):
	def pypdf2(pdf_file):
		py_pdf_file = open(pdf_file, 'rb')
		# create PDFFileReader object to read the file
		pdfReader = PdfFileReader(py_pdf_file)
		# obtain no, of pages
		numOfPages = pdfReader.getNumPages()
		# final return text string
		#text = "PDF File name : " + str(pdfReader.getDocumentInfo().title)
		# text list to contain all pdf text 
		text_lst = list()
		# itterate over all pages
		for i in range(0, numOfPages):
			# obtain page no.
			pageObj = pdfReader.getPage(i)
			# append page content to list
			text_lst.append('\n' + pageObj.extractText())
		# close the PDF file object
		py_pdf_file.close()
		# join all pages text into single string variable
		text_temp = " ".join(text_lst)
		#return text + text_temp
		return text_temp


	file_location = f"{myfile.filename}"
	with open(file_location, "wb+") as file_object:
		shutil.copyfileobj(myfile.file, file_object)


	train = pd.read_csv('./Blooms_Train.csv', encoding='latin-1')
	test = pd.read_csv('./Blooms_Test.csv', encoding='latin-1')
	test_app = pd.read_csv('./BLoom_APP_test.csv', encoding='latin-1')

	frames = [train, test]
	data = pd.concat(frames)
	data.info()
	category_count = data['Category'].value_counts()

	question = data['Question']

	question_app = test_app['Question']

	#One-Hot Encoding of the labels
	category = pd.get_dummies(data['Category'])

	category_test = pd.get_dummies(test_app['Category'])
	from nltk.tokenize import word_tokenize

	all_words_app = []
	for sent in question_app:
			print(sent)
			tokenize_word_app = word_tokenize(sent)
			for word in tokenize_word_app:
					all_words_app.append(word)

	from nltk.tokenize import word_tokenize

	all_words = []
	for sent in question:
			print(sent)
			tokenize_word = word_tokenize(sent)
			for word in tokenize_word:
					all_words.append(word)

	unique_words = set(all_words)
	# print(len(unique_words))

	unique_words_app = set(all_words_app)
	vocab_length = 101948
	embedded_sentences = [one_hot(sent, vocab_length) for sent in question]
	# print(embedded_sentences)

	# print(question_app)

	embedded_sentences_app = [one_hot(sent, vocab_length) for sent in question_app]

	# #count number of words
	word_count = lambda sentence: len(word_tokenize(sentence))
	longest_sentence = max(question, key=word_count)
	length_long_sentence = len(word_tokenize(longest_sentence))

	word_count_app = lambda sentence: len(word_tokenize(sentence))
	longest_sentence_app = max(question_app, key=word_count_app)
	length_long_sentence_app = len(word_tokenize(longest_sentence_app))
	padded_sentences = pad_sequences(embedded_sentences, length_long_sentence, padding='post')
	# print(padded_sentences)

	# length_long_sentence

	#Fill the end of each sentence with '0' so that they all have same lenght
	padded_sentences_app = pad_sequences(embedded_sentences_app, length_long_sentence, padding='post')
	# print(padded_sentences_app)

	len(padded_sentences[0])

	#divide the data into Training and Testing

	X_train, X_test, y_train, y_test = train_test_split(padded_sentences, category, train_size=0.9, random_state=42)

	# category_test

	y_train.head(10)

	#Build the Model 
	model = Sequential()
	model.add(Embedding(vocab_length, 20, input_length=length_long_sentence))
	model.add(LSTM(20, return_sequences=True))
	model.add(Dense(100, activation='relu'))
	model.add(Flatten())
	model.add(Dense(6, activation='softmax'))

	#compile model and show summary
	model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['acc'])

	# X_train

	# train the model

	model.fit(X_train, y_train, epochs=10, steps_per_epoch=200, verbose=1)

	text = pypdf2(file_location)
	nltk_tokens = nltk.word_tokenize(text)
	question=[]
	s=""
	for j in range(0,len(nltk_tokens)):
		if(nltk_tokens[j][0]=='Q'):
			start=j
			break
	i=start
	while(i<len(nltk_tokens)):
		if(nltk_tokens[i][0]=='Q' and (nltk_tokens[i+1][0].isdigit()) or (len(nltk_tokens[i])>1 and nltk_tokens[i][1].isdigit())):
			question.append(s[:-1])
			s=""
			while(i<len(nltk_tokens) and nltk_tokens[i]!="."):
				i+=1
			i+=1
		if(i<len(nltk_tokens)):
			s+=nltk_tokens[i]+" "
		i+=1
	question = question[1:]
	all_words = []
	for j in range(0,len(question)):
		sent = question[j]
		for i in range(0,len(sent)):
			if(i < len(sent) and (sent[i]=='\'' or sent[i] == '.' or sent[i] == '?' or sent[i] == ',')):
				sent = sent[:i-1] + sent[i:]
				question[j]=sent
	for sent in question:
		print(sent)
		tokenize_word = word_tokenize(sent)
		for word in tokenize_word:
			all_words.append(word)
	question = np.array(question)
	question = pd.Series(question)
	print(type(question))
	print(question)
	unique_words = set(all_words)
	vocab_length = 101948
	embedded_sentences = [one_hot(sent, vocab_length) for sent in question]
	print(embedded_sentences)
	word_count = lambda sentence: len(word_tokenize(sentence))
	longest_sentence = max(question, key=word_count)
	length_long_sentence = len(word_tokenize(longest_sentence))
	padded_sentences = pad_sequences(embedded_sentences, 43, padding='post')

	# model=keras.models.load_model('modelv7.keras')
	classification=model.predict(padded_sentences)*100

	# model.save("modelv7.keras")
	pred_result = (np.argmax(classification[:20], axis=1))
	print(pred_result)
	print(classification)
	pred_result=classification.tolist()
	print(pred_result)
	return {'file': pred_result}



# @app.delete('/cities')
