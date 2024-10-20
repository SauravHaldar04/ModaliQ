# # import numpy as np
# # import tensorflow as tf
# # import string
# # import nltk 
# # from nltk.tokenize import word_tokenize
# # from nltk.stem import WordNetLemmatizer
# # from tensorflow import keras
# # import transformers
# # from transformers import DistilBertTokenizer, TFDistilBertModel
# # import keras_ocr


# # def image_to_text(img_path):
# #     # Initialize the OCR pipeline
# #     pipeline = keras_ocr.pipeline.Pipeline()

# #     # Read the image
# #     image = keras_ocr.tools.read(img_path)
    
# #     # Perform OCR on the image
# #     predictions = pipeline.recognize([image])

# # # Extract and print the text from the predictions
# #     text=''
# #     for text_result in predictions[0]:
# #         text=text+text_result[0]+" "
# #     return text

# # nltk.download('punkt')
# # nltk.download('stopwords')
# # nltk.download('wordnet')

# # stopwords = nltk.corpus.stopwords.words('english')
# # lemmatizer = WordNetLemmatizer()

# # custom_objects = {
# #     'DistilBertTokenizer': DistilBertTokenizer,
# #     'TFDistilBertModel': TFDistilBertModel
# # }
# # def clean_text(text):
# #     text=str(text)
# #     tokens = word_tokenize(text)
# #     tokens[0]=tokens[0][2:]
# #     cleaned_text=[lemmatizer.lemmatize(word.lower()) for word in tokens if word.lower() not in stopwords and word not in string.punctuation]
# #     return ' '.join(cleaned_text)

# # tokenizer_bert = transformers.DistilBertTokenizer.from_pretrained('distilbert-base-uncased')
# # model=keras.models.load_model('/home/yuvraj/Coding/OverloadOblivion_Datahack/models/best_model_lstm.h5',custom_objects=custom_objects,compile=False)

# # def predict(text):
# #     tokenized_text=tokenizer_bert(clean_text(text), padding='max_length', max_length = 512, truncation=True)['input_ids']
# #     prediction=model.predict(tokenized_text)
# #     print(np.argmax(prediction[0]))
# #     return np.argmax(prediction[0])


# # text='''
# # All boys putting up their suggestions to make their night more of fun and memorable. Rohan suggested “Let’s go to the cinema and watch the latest movie ”. Rohit interrupted “No, No i dont want to waste this night by sitting on a chair for 3 hours and watching that romantic film” . Aryan then commented “ How about watching a thriller in the room itself.” Rohit agreed by telling that he wont mind watching a thriller .Mohit and Chirag were still not satisfied and were constantly giving a bored look to each other. Then suddenly there was a brightening sparkle on Mohit’s face . Mohit discussed his plan with Chirag and then both came up with a suggestion “ We both will agree to join you guys on 1 condition that if we could hangout that night somewhere outside the room after we are done with the thriller .Rohit , Rohan and Aryan agreed with no option left with them.

# # Finally it was 9 pm , all of the boys were excited ,turning off all the lights , drawing off all the curtains and all took their seats with a bowl of popcorn. The horror film started and all of them staring at the screen , seemed as if their eyeballs would pop out. All of them took a deep breath during the 2 minute interval in the movie. Rohit went to the kitchen to drink water and suddenly he heard a voice from the bathroom , opposite the kitchen as if someone had left the tap open and a bucket under it. The sound was turning out to be shriller and shriller so Rohit rushed to the bathroom to close the tap and guess what he saw ? He saw that all taps were closed and all the buckets were put upside down . This worried Rohit , he called all his friends and told them about this incident but no on believed him . Rohan said “ the horror film has got into your head , its better you go to sleep now”. Mohit and Chirag giggled. Aryan did not speak anything at the moment as he was not able to jump to any conclusions at the moment.
# # '''






# # # print(predict(text))


# # def pipeline(data,flag):
# #     text=''
# #     if(flag==0):        #image
# #         text=image_to_text(data)
# #     else:
# #         text=clean_text(data)
# #     label=predict(text)
# #     return label
    
        
# # print(pipeline('/home/yuvraj/Coding/OverloadOblivion_Datahack/data/image.png',0))

# import numpy as np
# import tensorflow as tf
# import string
# import nltk 
# from nltk.tokenize import word_tokenize
# from nltk.stem import WordNetLemmatizer
# from tensorflow import keras
# import transformers
# from transformers import DistilBertTokenizer, TFDistilBertModel
# import pytesseract
# from PIL import Image
# import cv2
# import matplotlib.pyplot as plt
# import logging
# from lime.lime_text import LimeTextExplainer
# import os

# # Set up logging
# logging.basicConfig(level=logging.INFO)
# logger = logging.getLogger(__name__)

# class TextClassificationPipeline:
#     def __init__(self, model_path):
#         # Initialize NLTK downloads
#         self._download_nltk_resources()
        
#         # Initialize components
#         self.stopwords = nltk.corpus.stopwords.words('english')
#         self.lemmatizer = WordNetLemmatizer()
#         self.tokenizer_bert = transformers.DistilBertTokenizer.from_pretrained('distilbert-base-uncased')
#         self.max_length = 500  # Set to match model's expected input length
        
#         # Load the model
#         custom_objects = {
#             'DistilBertTokenizer': DistilBertTokenizer,
#             'TFDistilBertModel': TFDistilBertModel
#         }
#         self.model = keras.models.load_model(model_path, custom_objects=custom_objects, compile=False)
        
#         # Initialize LIME explainer
#         self.explainer = LimeTextExplainer(class_names=['class_0', 'class_1'])

#     def _download_nltk_resources(self):
#         """Download required NLTK resources."""
#         resources = ['punkt', 'stopwords', 'wordnet']
#         for resource in resources:
#             try:
#                 nltk.download(resource, quiet=True)
#             except Exception as e:
#                 logger.error(f"Failed to download NLTK resource {resource}: {str(e)}")

#     def preprocess_image(self, image_path):
#         """Preprocess image for better OCR results."""
#         try:
#             # Read image using opencv
#             img = cv2.imread(image_path)
            
#             # Convert to grayscale
#             gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
            
#             # Apply thresholding to preprocess the image
#             gray = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)[1]
            
#             # Apply dilation to connect text components
#             kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3,3))
#             gray = cv2.dilate(gray, kernel, iterations=1)
            
#             # Write the grayscale image to disk as a temporary file
#             cv2.imwrite("temp_processed_image.png", gray)
            
#             return "temp_processed_image.png"
            
#         except Exception as e:
#             logger.error(f"Error in preprocess_image: {str(e)}")
#             raise

#     def image_to_text(self, img_path):
#         """Convert image to text using Tesseract OCR."""
#         try:
#             # Check if file exists
#             if not os.path.exists(img_path):
#                 raise FileNotFoundError(f"Image file not found: {img_path}")
            
#             # Preprocess the image
#             processed_image_path = self.preprocess_image(img_path)
            
#             # Perform OCR
#             text = pytesseract.image_to_string(Image.open(processed_image_path))
            
#             # Clean up temporary file
#             if os.path.exists("temp_processed_image.png"):
#                 os.remove("temp_processed_image.png")
            
#             if not text.strip():
#                 logger.warning("No text detected in the image")
#                 return ""
                
#             return text
            
#         except Exception as e:
#             logger.error(f"Error in image_to_text: {str(e)}")
#             raise

#     def clean_text(self, text):
#         """Clean and preprocess text."""
#         try:
#             text = str(text)
#             tokens = word_tokenize(text)
            
#             # Remove special characters and lemmatize
#             cleaned_text = [
#                 self.lemmatizer.lemmatize(word.lower()) 
#                 for word in tokens 
#                 if word.lower() not in self.stopwords 
#                 and word not in string.punctuation
#             ]
            
#             return ' '.join(cleaned_text)
#         except Exception as e:
#             logger.error(f"Error in clean_text: {str(e)}")
#             raise

#     def tokenize_text(self, text):
#         """Tokenize text with correct padding length."""
#         try:
#             # Tokenize with correct max_length
#             tokenized = self.tokenizer_bert(
#                 text,
#                 padding='max_length',
#                 max_length=self.max_length,
#                 truncation=True,
#                 return_tensors='tf'
#             )
#             return tokenized['input_ids']
#         except Exception as e:
#             logger.error(f"Error in tokenize_text: {str(e)}")
#             raise

#     def predict(self, text):
#         """Make prediction with the model."""
#         try:
#             # Tokenize with correct length
#             tokenized_text = self.tokenize_text(text)
            
#             # Make prediction
#             prediction = self.model.predict(tokenized_text, verbose=0)
#             return np.argmax(prediction[0])
#         except Exception as e:
#             logger.error(f"Error in predict: {str(e)}")
#             raise

#     def explain_prediction(self, text):
#         """Generate LIME explanation for the prediction."""
#         try:
#             # Define prediction function for LIME
#             def predict_proba(texts):
#                 predictions = []
#                 for t in texts:
#                     tokenized = self.tokenize_text(t)
#                     pred = self.model.predict(tokenized, verbose=0)
#                     predictions.append(pred[0])
#                 return np.array(predictions)

#             # Generate explanation
#             exp = self.explainer.explain_instance(
#                 text,
#                 predict_proba,
#                 num_features=10,
#                 num_samples=100
#             )
            
#             return exp
            
#         except Exception as e:
#             logger.error(f"Error in explain_prediction: {str(e)}")
#             raise

#     def visualize_explanation(self, explanation, save_path=None):
#         """Visualize LIME explanation."""
#         try:
#             # Get the words and their importance scores
#             words_importance = dict(explanation.as_list())
            
#             # Create visualization
#             plt.figure(figsize=(12, 6))
#             plt.barh(range(len(words_importance)), 
#                     list(words_importance.values()),
#                     align='center')
#             plt.yticks(range(len(words_importance)), 
#                       list(words_importance.keys()))
#             plt.xlabel('Feature Importance')
#             plt.title('Words Contributing to Prediction')
            
#             if save_path:
#                 plt.savefig(save_path)
#                 plt.close()
#             else:
#                 plt.show()
                
#         except Exception as e:
#             logger.error(f"Error in visualize_explanation: {str(e)}")
#             raise

#     def pipeline(self, data, is_text=True):
#         """Complete pipeline for processing and explaining predictions."""
#         try:
#             # Get text from input
#             if is_text:
#                 text = data
#             else:
#                 text = self.image_to_text(data)
#                 if not text:
#                     raise ValueError("No text could be extracted from the image")
            
#             # Clean text
#             cleaned_text = self.clean_text(text)
            
#             # Make prediction
#             label = self.predict(cleaned_text)
            
#             # Generate explanation
#             explanation = self.explain_prediction(cleaned_text)
            
#             return {
#                 'original_text': text,
#                 'cleaned_text': cleaned_text,
#                 'prediction': label,
#                 'explanation': explanation
#             }
            
#         except Exception as e:
#             logger.error(f"Error in pipeline: {str(e)}")
#             raise


# # Install required packages first:
# # pip install pytesseract
# # sudo apt-get install tesseract-ocr  # For Ubuntu/Debian

# # Initialize the pipeline
# classifier = TextClassificationPipeline('/home/yuvraj/Coding/OverloadOblivion_Datahack/models/best_model_lstm.h5')

# # Process text
# # result = classifier.pipeline("Your text here", is_text=True)

# # Process image
# result = classifier.pipeline("/home/yuvraj/Coding/OverloadOblivion_Datahack/data/image.png", is_text=False)

# # Visualize explanation
# classifier.visualize_explanation(result['explanation'], 'explanation.png')


# import numpy as np
# import tensorflow as tf
# from tensorflow import keras
# import transformers
# from transformers import DistilBertTokenizer, TFDistilBertModel
# from PIL import Image
# import pytesseract
# from lime.lime_text import LimeTextExplainer
# import logging
# import re
# import matplotlib.pyplot as plt
# import seaborn as sns
# from sklearn.metrics import confusion_matrix, classification_report
# import shap
# from collections import Counter
# import pandas as pd

# logging.basicConfig(level=logging.INFO)
# logger = logging.getLogger(__name__)

# class XAITextClassificationPipeline:
#     def _init_(self, model_path):
#         self.tokenizer_bert = transformers.DistilBertTokenizer.from_pretrained('distilbert-base-uncased')
#         self.max_length = 512
        
#         custom_objects = {
#             'DistilBertTokenizer': DistilBertTokenizer,
#             'TFDistilBertModel': TFDistilBertModel
#         }
#         self.model = keras.models.load_model(model_path, custom_objects=custom_objects, compile=False)
#         self.lime_explainer = LimeTextExplainer(class_names=['class_0', 'class_1'])
#         self.shap_explainer = None
        
#     def image_to_text(self, image_path):
#         try:
#             img = Image.open(image_path)
#             text = pytesseract.image_to_string(img)
#             return text.strip()
#         except Exception as e:
#             logger.error(f"Error in image_to_text: {str(e)}")
#             return ""

#     def clean_text(self, text):
#         text = text.lower()
#         text = re.sub(r'[^\w\s]', '', text)
#         return ' '.join(text.split())

#     def predict(self, text):
#         tokenized = self.tokenizer_bert(
#             text,
#             padding='max_length',
#             max_length=self.max_length,
#             truncation=True,
#             return_tensors='tf'
#         )
#         prediction = self.model.predict(tokenized['input_ids'], verbose=0)
#         return prediction[0]

#     def explain_lime(self, text):
#         def predict_proba(texts):
#             return np.array([self.predict(t) for t in texts])
        
#         exp = self.lime_explainer.explain_instance(text, predict_proba, num_features=10, num_samples=100)
#         return exp

#     def explain_shap(self, text):
#         if self.shap_explainer is None:
#             background_dataset = [""] * 100
#             tokenized_background = self.tokenizer_bert(
#                 background_dataset,
#                 padding='max_length',
#                 max_length=self.max_length,
#                 truncation=True,
#                 return_tensors='tf'
#             )
#             self.shap_explainer = shap.KernelExplainer(
#                 self.predict,
#                 tokenized_background['input_ids']
#             )
        
#         tokenized = self.tokenizer_bert(
#             text,
#             padding='max_length',
#             max_length=self.max_length,
#             truncation=True,
#             return_tensors='tf'
#         )
#         shap_values = self.shap_explainer.shap_values(tokenized['input_ids'])
#         return shap_values

#     def plot_feature_importance(self, text):
#         lime_exp = self.explain_lime(text)
#         features = pd.DataFrame(lime_exp.as_list(), columns=['Feature', 'Importance'])
        
#         plt.figure(figsize=(10, 6))
#         sns.barplot(data=features, x='Importance', y='Feature')
#         plt.title('Feature Importance')
#         plt.tight_layout()
#         return plt

#     def plot_attention_weights(self, text):
#         tokenized = self.tokenizer_bert(
#             text,
#             padding='max_length',
#             max_length=self.max_length,
#             truncation=True,
#             return_tensors='tf'
#         )
        
#         tokens = self.tokenizer_bert.convert_ids_to_tokens(tokenized['input_ids'][0])
#         attention = np.random.rand(len(tokens), len(tokens))  # Placeholder for actual attention
        
#         plt.figure(figsize=(12, 8))
#         sns.heatmap(attention, xticklabels=tokens, yticklabels=tokens)
#         plt.title('Attention Weights')
#         plt.xticks(rotation=45)
#         plt.yticks(rotation=45)
#         plt.tight_layout()
#         return plt

#     def _calculate_explanation_stability(self, text, num_samples=5):
#         """
#         Calculate stability of LIME explanation for a given text
#         """
#         # Generate multiple explanations for the same text
#         explanations = []
#         for _ in range(num_samples):
#             exp = self.explain_lime(text)
#             features = set([feat[0] for feat in exp.as_list()])
#             explanations.append(features)
        
#         # Calculate pairwise Jaccard similarities
#         similarities = []
#         for i in range(len(explanations)):
#             for j in range(i + 1, len(explanations)):
#                 intersection = len(explanations[i] & explanations[j])
#                 union = len(explanations[i] | explanations[j])
#                 similarity = intersection / union if union > 0 else 0
#                 similarities.append(similarity)
        
#         return np.mean(similarities)

#     def generate_xai_report(self, text, is_text=True):
#         try:
#             if not is_text:
#                 text = self.image_to_text(text)
            
#             cleaned_text = self.clean_text(text)
#             prediction = self.predict(cleaned_text)
            
#             # Generate explanations
#             lime_exp = self.explain_lime(cleaned_text)
            
#             # Calculate explanation stability
#             stability_score = self._calculate_explanation_stability(cleaned_text)
            
#             # Create visualizations
#             feature_importance_plot = self.plot_feature_importance(cleaned_text)
#             attention_plot = self.plot_attention_weights(cleaned_text)
            
#             # Prepare explanation data
#             word_importance = pd.DataFrame(lime_exp.as_list(), columns=['word', 'importance'])
#             word_importance = word_importance.sort_values('importance', ascending=False)
            
#             return {
#                 'text': cleaned_text,
#                 'prediction': prediction,
#                 'word_importance': word_importance,
#                 'explanation_stability': stability_score,
#                 'visualizations': {
#                     'feature_importance': feature_importance_plot,
#                     'attention_weights': attention_plot
#                 },
#                 'lime_explanation': lime_exp
#             }
            
#         except Exception as e:
#             logger.error(f"Error in XAI analysis: {str(e)}")
#             raise

#     def evaluate_explanations(self, texts, labels):
#         """
#         Evaluate explanation stability and consistency
#         """
#         metrics = []
#         for text, label in zip(texts, labels):
#             stability = self._calculate_explanation_stability(text)
#             predicted_label = np.argmax(self.predict(text))
            
#             metrics.append({
#                 'text': text,
#                 'true_label': label,
#                 'predicted_label': predicted_label,
#                 'explanation_stability': stability
#             })
        
#         return pd.DataFrame(metrics)

# # Initialize the pipeline
# classifier = XAITextClassificationPipeline('/home/yuvraj/Coding/OverloadOblivion_Datahack/models/best_model_lstm.h5')

# # Example usage
# sample_text = '''
# # All boys putting up their suggestions to make their night more of fun and memorable. Rohan suggested "Let's go to the cinema and watch the latest movie ". Rohit interrupted "No, No i dont want to waste this night by sitting on a chair for 3 hours and watching that romantic film" . Aryan then commented " How about watching a thriller in the room itself." Rohit agreed by telling that he wont mind watching a thriller .Mohit and Chirag were still not satisfied and were constantly giving a bored look to each other. Then suddenly there was a brightening sparkle on Mohit's face . Mohit discussed his plan with Chirag and then both came up with a suggestion " We both will agree to join you guys on 1 condition that if we could hangout that night somewhere outside the room after we are done with the thriller .Rohit , Rohan and Aryan agreed with no option left with them.

# # Finally it was 9 pm , all of the boys were excited ,turning off all the lights , drawing off all the curtains and all took their seats with a bowl of popcorn. The horror film started and all of them staring at the screen , seemed as if their eyeballs would pop out. All of them took a deep breath during the 2 minute interval in the movie. Rohit went to the kitchen to drink water and suddenly he heard a voice from the bathroom , opposite the kitchen as if someone had left the tap open and a bucket under it. The sound was turning out to be shriller and shriller so Rohit rushed to the bathroom to close the tap and guess what he saw ? He saw that all taps were closed and all the buckets were put upside down . This worried Rohit , he called all his friends and told them about this incident but no on believed him . Rohan said " the horror film has got into your head , its better you go to sleep now". Mohit and Chirag giggled. Aryan did not speak anything at the moment as he was not able to jump to any conclusions at the moment.
# '''
# results = classifier.generate_xai_report(sample_text)

# # Print results
# print(f"Prediction: {results['prediction']}")
# print(f"\nExplanation Stability Score: {results['explanation_stability']:.3f}")
# print("\nTop important words:")
# print(results['word_importance'].head())

# # Show visualizations
# for plot_name, plot in results['visualizations'].items():
#     plot.show()


# import numpy as np
# import tensorflow as tf
# from tensorflow import keras
# import transformers
# from transformers import DistilBertTokenizer, TFDistilBertModel
# from PIL import Image
# import pytesseract
# from lime.lime_text import LimeTextExplainer
# import logging
# import re
# import matplotlib.pyplot as plt
# import seaborn as sns
# from sklearn.metrics import confusion_matrix, classification_report
# import shap
# from collections import Counter
# import pandas as pd

# logging.basicConfig(level=logging.INFO)
# logger = logging.getLogger(__name__)

# def calculate_item_frequencies(arr):
#     """
#     Replacement for scipy.stats.itemfreq
#     Returns a 2D array of unique items and their frequencies
#     """
#     if isinstance(arr, np.ndarray):
#         arr = arr.flatten()
#     counts = Counter(arr)
#     unique_items = np.array(list(counts.keys()))
#     frequencies = np.array(list(counts.values()))
#     return np.column_stack((unique_items, frequencies))

# class XAITextClassificationPipeline:
#     def _init_(self, model_path):
#         self.tokenizer_bert = transformers.DistilBertTokenizer.from_pretrained('distilbert-base-uncased')
#         self.max_length = 512
        
#         custom_objects = {
#             'DistilBertTokenizer': DistilBertTokenizer,
#             'TFDistilBertModel': TFDistilBertModel
#         }
#         self.model = keras.models.load_model(model_path, custom_objects=custom_objects, compile=False)
#         self.lime_explainer = LimeTextExplainer(class_names=['class_0', 'class_1'])
#         self.shap_explainer = None
        
#     def image_to_text(self, image_path):
#         try:
#             img = Image.open(image_path)
#             text = pytesseract.image_to_string(img)
#             return text.strip()
#         except Exception as e:
#             logger.error(f"Error in image_to_text: {str(e)}")
#             return ""

#     def clean_text(self, text):
#         text = text.lower()
#         text = re.sub(r'[^\w\s]', '', text)
#         return ' '.join(text.split())

#     def predict(self, text):
#         tokenized = self.tokenizer_bert(
#             text,
#             padding='max_length',
#             max_length=self.max_length,
#             truncation=True,
#             return_tensors='tf'
#         )
#         prediction = self.model.predict(tokenized['input_ids'], verbose=0)
#         return prediction[0]

#     def explain_lime(self, text):
#         def predict_proba(texts):
#             return np.array([self.predict(t) for t in texts])
        
#         exp = self.lime_explainer.explain_instance(text, predict_proba, num_features=10, num_samples=100)
#         return exp

#     def explain_shap(self, text):
#         if self.shap_explainer is None:
#             background_dataset = [""] * 100  # Empty background dataset
#             tokenized_background = self.tokenizer_bert(
#                 background_dataset,
#                 padding='max_length',
#                 max_length=self.max_length,
#                 truncation=True,
#                 return_tensors='tf'
#             )
#             self.shap_explainer = shap.KernelExplainer(
#                 self.predict,
#                 tokenized_background['input_ids']
#             )
        
#         tokenized = self.tokenizer_bert(
#             text,
#             padding='max_length',
#             max_length=self.max_length,
#             truncation=True,
#             return_tensors='tf'
#         )
#         shap_values = self.shap_explainer.shap_values(tokenized['input_ids'])
#         return shap_values

#     def plot_feature_importance(self, text):
#         """
#         Plot feature importance based on LIME explanation
#         """
#         lime_exp = self.explain_lime(text)
#         features = pd.DataFrame(lime_exp.as_list(), columns=['Feature', 'Importance'])
        
#         plt.figure(figsize=(10, 6))
#         sns.barplot(data=features, x='Importance', y='Feature')
#         plt.title('Feature Importance')
#         plt.tight_layout()
#         return plt

#     def plot_attention_weights(self, text):
#         """
#         Plot attention weights heatmap
#         """
#         tokenized = self.tokenizer_bert(
#             text,
#             padding='max_length',
#             max_length=self.max_length,
#             truncation=True,
#             return_tensors='tf'
#         )
        
#         # Get model attention (assuming attention is available in the model output)
#         tokens = self.tokenizer_bert.convert_ids_to_tokens(tokenized['input_ids'][0])
#         attention = np.random.rand(len(tokens), len(tokens))  # Placeholder for actual attention
        
#         plt.figure(figsize=(12, 8))
#         sns.heatmap(attention, xticklabels=tokens, yticklabels=tokens)
#         plt.title('Attention Weights')
#         plt.xticks(rotation=45)
#         plt.yticks(rotation=45)
#         plt.tight_layout()
#         return plt

#     def generate_xai_report(self, text, is_text=True):
#         try:
#             if not is_text:
#                 text = self.image_to_text(text)
            
#             cleaned_text = self.clean_text(text)
#             prediction = self.predict(cleaned_text)
            
#             # Generate explanations
#             lime_exp = self.explain_lime(cleaned_text)
            
#             # Create visualizations
#             feature_importance_plot = self.plot_feature_importance(cleaned_text)
#             attention_plot = self.plot_attention_weights(cleaned_text)
            
#             # Prepare explanation data
#             word_importance = pd.DataFrame(lime_exp.as_list(), columns=['word', 'importance'])
#             word_importance = word_importance.sort_values('importance', ascending=False)
            
#             return {
#                 'text': cleaned_text,
#                 'prediction': prediction,
#                 'word_importance': word_importance,
#                 'visualizations': {
#                     'feature_importance': feature_importance_plot,
#                     'attention_weights': attention_plot
#                 },
#                 'lime_explanation': lime_exp
#             }
            
#         except Exception as e:
#             logger.error(f"Error in XAI analysis: {str(e)}")
#             raise

#     def evaluate_explanations(self, texts, labels):
#         """
#         Evaluate explanation stability and consistency
#         """
#         metrics = []
#         for text, label in zip(texts, labels):
#             exp = self.explain_lime(text)
#             stability = self._calculate_explanation_stability(exp)
#             metrics.append({
#                 'text': text,
#                 'true_label': label,
#                 'predicted_label': np.argmax(self.predict(text)),
#                 'explanation_stability': stability
#             })
        
#         return pd.DataFrame(metrics)

#     def _calculate_explanation_stability(self, explanation):
#         """
#         Calculate stability of LIME explanation
#         """
#         features = [feat[0] for feat in explanation.as_list()]
#         repeated_explanations = [
#             set([feat[0] for feat in self.explain_lime(explanation.text).as_list()])
#             for _ in range(5)
#         ]
        
#         # Calculate Jaccard similarity between explanations
#         similarities = []
#         for i in range(len(repeated_explanations)):
#             for j in range(i + 1, len(repeated_explanations)):
#                 intersection = len(repeated_explanations[i] & repeated_explanations[j])
#                 union = len(repeated_explanations[i] | repeated_explanations[j])
#                 similarities.append(intersection / union if union > 0 else 0)
        
#         return np.mean(similarities)


# # Initialize the pipeline
# classifier = XAITextClassificationPipeline('/home/yuvraj/Coding/OverloadOblivion_Datahack/models/best_model_lstm.h5')

# # Example usage
# sample_text ='''
# # All boys putting up their suggestions to make their night more of fun and memorable. Rohan suggested “Let’s go to the cinema and watch the latest movie ”. Rohit interrupted “No, No i dont want to waste this night by sitting on a chair for 3 hours and watching that romantic film” . Aryan then commented “ How about watching a thriller in the room itself.” Rohit agreed by telling that he wont mind watching a thriller .Mohit and Chirag were still not satisfied and were constantly giving a bored look to each other. Then suddenly there was a brightening sparkle on Mohit’s face . Mohit discussed his plan with Chirag and then both came up with a suggestion “ We both will agree to join you guys on 1 condition that if we could hangout that night somewhere outside the room after we are done with the thriller .Rohit , Rohan and Aryan agreed with no option left with them.

# # Finally it was 9 pm , all of the boys were excited ,turning off all the lights , drawing off all the curtains and all took their seats with a bowl of popcorn. The horror film started and all of them staring at the screen , seemed as if their eyeballs would pop out. All of them took a deep breath during the 2 minute interval in the movie. Rohit went to the kitchen to drink water and suddenly he heard a voice from the bathroom , opposite the kitchen as if someone had left the tap open and a bucket under it. The sound was turning out to be shriller and shriller so Rohit rushed to the bathroom to close the tap and guess what he saw ? He saw that all taps were closed and all the buckets were put upside down . This worried Rohit , he called all his friends and told them about this incident but no on believed him . Rohan said “ the horror film has got into your head , its better you go to sleep now”. Mohit and Chirag giggled. Aryan did not speak anything at the moment as he was not able to jump to any conclusions at the moment.
# # '''
# results = classifier.generate_xai_report(sample_text)

# # Print results
# print(f"Prediction: {results['prediction']}")
# print("\nTop important words:")
# print(results['word_importance'].head())

# # Show visualizations
# for plot_name, plot in results['visualizations'].items():
#     plot.show()

# # Example of explanation evaluation
# test_texts = ["sample text 1", "sample text 2"]
# test_labels = [0, 1]
# evaluation_results = classifier.evaluate_explanations(test_texts, test_labels)
# print("\nExplanation evaluation:")
# print(evaluation_results)



import numpy as np
import tensorflow as tf
from tensorflow import keras
import transformers
from transformers import DistilBertTokenizer, TFDistilBertModel
from PIL import Image
import pytesseract
from lime.lime_text import LimeTextExplainer
import logging
import re
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.metrics import confusion_matrix, classification_report
import shap
from collections import Counter
import pandas as pd

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class XAITextClassificationPipeline:
    def __init__(self, model_path):
        self.tokenizer_bert = transformers.DistilBertTokenizer.from_pretrained('distilbert-base-uncased')
        self.max_length = 512
        
        custom_objects = {
            'DistilBertTokenizer': DistilBertTokenizer,
            'TFDistilBertModel': TFDistilBertModel
        }
        self.model = keras.models.load_model(model_path, custom_objects=custom_objects, compile=False)
        self.lime_explainer = LimeTextExplainer(class_names=['class_0', 'class_1'])
        self.shap_explainer = None
        
    def image_to_text(self, image_path):
        try:
            img = Image.open(image_path)
            text = pytesseract.image_to_string(img)
            return text.strip()
        except Exception as e:
            logger.error(f"Error in image_to_text: {str(e)}")
            return ""

    def clean_text(self, text):
        text = text.lower()
        text = re.sub(r'[^\w\s]', '', text)
        return ' '.join(text.split())

    def predict(self, text):
        tokenized = self.tokenizer_bert(
            text,
            padding='max_length',
            max_length=self.max_length,
            truncation=True,
            return_tensors='tf'
        )
        prediction = self.model.predict(tokenized['input_ids'], verbose=0)
        return prediction[0]

    def explain_lime(self, text):
        def predict_proba(texts):
            return np.array([self.predict(t) for t in texts])
        
        exp = self.lime_explainer.explain_instance(text, predict_proba, num_features=10, num_samples=100)
        return exp

    def explain_shap(self, text):
        if self.shap_explainer is None:
            background_dataset = [""] * 100
            tokenized_background = self.tokenizer_bert(
                background_dataset,
                padding='max_length',
                max_length=self.max_length,
                truncation=True,
                return_tensors='tf'
            )
            self.shap_explainer = shap.KernelExplainer(
                self.predict,
                tokenized_background['input_ids']
            )
        
        tokenized = self.tokenizer_bert(
            text,
            padding='max_length',
            max_length=self.max_length,
            truncation=True,
            return_tensors='tf'
        )
        shap_values = self.shap_explainer.shap_values(tokenized['input_ids'])
        return shap_values

    def plot_feature_importance(self, text):
        lime_exp = self.explain_lime(text)
        features = pd.DataFrame(lime_exp.as_list(), columns=['Feature', 'Importance'])
        
        plt.figure(figsize=(10, 6))
        sns.barplot(data=features, x='Importance', y='Feature')
        plt.title('Feature Importance')
        plt.tight_layout()
        return plt

    def plot_attention_weights(self, text):
        tokenized = self.tokenizer_bert(
             text,
            padding='max_length',
            max_length=self.max_length,
            truncation=True,
            return_tensors='tf'
        )
        
        tokens = self.tokenizer_bert.convert_ids_to_tokens(tokenized['input_ids'][0])
        attention = np.random.rand(len(tokens), len(tokens))  # Placeholder for actual attention
        
        plt.figure(figsize=(12, 8))
        sns.heatmap(attention, xticklabels=tokens, yticklabels=tokens)
        plt.title('Attention Weights')
        plt.xticks(rotation=45)
        plt.yticks(rotation=45)
        plt.tight_layout()
        return plt

    def _calculate_explanation_stability(self, text, num_samples=5):
        """
        Calculate stability of LIME explanation for a given text
        """
        # Generate multiple explanations for the same text
        explanations = []
        for _ in range(num_samples):
            exp = self.explain_lime(text)
            features = set([feat[0] for feat in exp.as_list()])
            explanations.append(features)
        
        # Calculate pairwise Jaccard similarities
        similarities = []
        for i in range(len(explanations)):
            for j in range(i + 1, len(explanations)):
                intersection = len(explanations[i] & explanations[j])
                union = len(explanations[i] | explanations[j])
                similarity = intersection / union if union > 0 else 0
                similarities.append(similarity)
        
        return np.mean(similarities)

    def generate_xai_report(self, text, is_text=True):
        try:
            if not is_text:
                text = self.image_to_text(text)
            
            cleaned_text = self.clean_text(text)
            prediction = self.predict(cleaned_text)
            
            # Generate explanations
            lime_exp = self.explain_lime(cleaned_text)
            
            # Calculate explanation stability
            stability_score = self._calculate_explanation_stability(cleaned_text)
            
            # Create visualizations
            feature_importance_plot = self.plot_feature_importance(cleaned_text)
            attention_plot = self.plot_attention_weights(cleaned_text)
            
            # Prepare explanation data
            word_importance = pd.DataFrame(lime_exp.as_list(), columns=['word', 'importance'])
            word_importance = word_importance.sort_values('importance', ascending=False)
            
            return {
                'text': cleaned_text,
                'prediction': prediction,
                'word_importance': word_importance,
                'explanation_stability': stability_score,
                'visualizations': {
                    'feature_importance': feature_importance_plot,
                    'attention_weights': attention_plot
                },
                'lime_explanation': lime_exp
            }
            
        except Exception as e:
            logger.error(f"Error in XAI analysis: {str(e)}")
            raise

    def evaluate_explanations(self, texts, labels):
        """
        Evaluate explanation stability and consistency
        """
        metrics = []
        for text, label in zip(texts, labels):
            stability = self._calculate_explanation_stability(text)
            predicted_label = np.argmax(self.predict(text))
            
            metrics.append({
                'text': text,
                'true_label': label,
                'predicted_label': predicted_label,
                'explanation_stability': stability
            })
        
        return pd.DataFrame(metrics)

# if __name__ == "__main__":
#     # Initialize the pipeline
#     classifier = XAITextClassificationPipeline('/home/yuvraj/Coding/OverloadOblivion_Datahack/models/best_model.h5')
    
#     # Example usage
#     sample_text = '''
#     # All boys putting up their suggestions to make their night more of fun and memorable. Rohan suggested "Let's go to the cinema and watch the latest movie ". Rohit interrupted "No, No i dont want to waste this night by sitting on a chair for 3 hours and watching that romantic film" . Aryan then commented " How about watching a thriller in the room itself." Rohit agreed by telling that he wont mind watching a thriller .Mohit and Chirag were still not satisfied and were constantly giving a bored look to each other. Then suddenly there was a brightening sparkle on Mohit's face . Mohit discussed his plan with Chirag and then both came up with a suggestion " We both will agree to join you guys on 1 condition that if we could hangout that night somewhere outside the room after we are done with the thriller .Rohit , Rohan and Aryan agreed with no option left with them.

#     # Finally it was 9 pm , all of the boys were excited ,turning off all the lights , drawing off all the curtains and all took their seats with a bowl of popcorn. The horror film started and all of them staring at the screen , seemed as if their eyeballs would pop out. All of them took a deep breath during the 2 minute interval in the movie. Rohit went to the kitchen to drink water and suddenly he heard a voice from the bathroom , opposite the kitchen as if someone had left the tap open and a bucket under it. The sound was turning out to be shriller and shriller so Rohit rushed to the bathroom to close the tap and guess what he saw ? He saw that all taps were closed and all the buckets were put upside down . This worried Rohit , he called all his friends and told them about this incident but no on believed him . Rohan said " the horror film has got into your head , its better you go to sleep now". Mohit and Chirag giggled. Aryan did not speak anything at the moment as he was not able to jump to any conclusions at the moment.
#     '''
#     results = classifier.generate_xai_report(sample_text)
    
#     # Print results
#     print(f"Prediction: {results['prediction']}")
#     print(f"\nExplanation Stability Score: {results['explanation_stability']:.3f}")
#     print("\nTop important words:")
#     print(results['word_importance'].head())
    
#     # Show visualizations
#     for plot_name, plot in results['visualizations'].items():
#         plot.show()