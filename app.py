# from flask import Flask, request, jsonify
# from flask_cors import CORS
# from werkzeug.utils import secure_filename
# import os
# import asyncio
# import base64
# from scripts import custom_flashcard
# from scripts import syllabus_extract
# from scripts import quiz_generation
# import subprocess

# app = Flask(__name__)
# CORS(app)

# # Configure upload folder
# UPLOAD_FOLDER = 'uploads'
# app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# # Ensure the upload folder exists
# os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# def encode_bytes(obj):
#     if isinstance(obj, bytes):
#         return base64.b64encode(obj).decode('utf-8')
#     elif isinstance(obj, dict):
#         return {key: encode_bytes(value) for key, value in obj.items()}
#     elif isinstance(obj, list):
#         return [encode_bytes(item) for item in obj]
#     else:
#         return obj


# @app.route('/generate_flashcard', methods=['POST'])
# async def generate_flashcard():
#     if 'file' not in request.files:
#         return jsonify({'error': 'No file part in the request'}), 400
    
#     file = request.files['file']
#     filetype = request.form.get('filetype')
#     grade = request.form.get('grade')
    
#     if file.filename == '':
#         return jsonify({'error': 'No file selected'}), 400
    
#     if not all([filetype, grade]):
#         return jsonify({'error': 'Missing filetype or grade'}), 400
    
#     if filetype not in ['img', 'pdf', 'audio', 'video', 'url', 'text', 'ppt']:
#         return jsonify({'error': 'Unsupported file type'}), 400
    
#     try:
#         # Save the file temporarily
#         filename = secure_filename(file.filename)
#         filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
#         file.save(filepath)
        
#         # Generate flashcards
#         generator = custom_flashcard.CustomFlashcardGenerator()
#         flashcards = await generator.give_flashcards(filepath, filetype, grade)
        
#         # Clean up: remove the temporary file
#         os.remove(filepath)
        
#         # Encode any bytes objects in the flashcards
#         encoded_flashcards = encode_bytes(flashcards)
        
#         print(encoded_flashcards)
#         return jsonify({'flashcards': encoded_flashcards}), 200
    
#     except Exception as e:
#         return jsonify({'error': str(e)}), 500

# @app.route('/generate_syllabus', methods=['POST'])
# async def generate_syllabus():
#     if 'file' not in request.files:
#         return jsonify({'error': 'No file part in the request'}), 400
    
#     file = request.files['file']
    
#     if file.filename == '':
#         return jsonify({'error': 'No file selected'}), 400
    
#     if not file.filename.lower().endswith('.pdf'):
#         return jsonify({'error': 'Only PDF files are supported'}), 400
    
#     try:
#         # Save the file temporarily
#         filename = secure_filename(file.filename)
#         filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
#         file.save(filepath)
        
#         # Extract and process syllabus
#         structured_syllabus = syllabus_extract.extract_and_process_syllabus(filepath)
        
#         # Clean up: remove the temporary file
#         os.remove(filepath)
        
#         return jsonify({'syllabus': structured_syllabus}), 200
    
#     except Exception as e:
#         return jsonify({'error': str(e)}), 500

# # @app.route('/start_quiz', methods=['POST'])
# # def start_quiz():
# #     data = request.json
# #     grade = data['grade']
# #     subject = data['subject']
# #     topic = data['topic']

# #     print(grade,subject,topic)
# #     # Validate inputs
# #     if not grade or not subject or not topic:
# #         return jsonify({'error': 'Missing grade, subject or topic'}), 400
    
# #     counts = {
# #     "easy": 10,
# #     "medium": 10,
# #     "hard": 10
# #     }
# #     print(grade,subject,topic)
    
# #     questions=quiz_generation.generate_question_dictionary(grade,subject,topic,counts)
# #     print(questions)

# #     # Start the WebSocket server using the RL simulation
# #     try:
# #         subprocess.Popen(["python3", "rl_simulation.py", questions])
# #         return jsonify({'message': 'Quiz started!'}), 200
# #     except Exception as e:
# #         return jsonify({'error': str(e)}), 500

# @app.route('/start_quiz', methods=['POST'])
# def start_quiz():
#     data = request.json
#     grade = data.get('grade')
#     subject = data.get('subject')
#     topic = data.get('topic')

#     print(grade,subject,topic)
#     # Validate inputs
#     if not all([grade, subject, topic]):
#         return jsonify({'error': 'Missing grade, subject or topic'}), 400
    
#     counts = {
#         "easy": 5,
#         "medium": 5,
#         "hard": 5
#     }
#     try:
#         questions = quiz_generation.generate_question_dictionary(grade, subject, topic, counts)
#     except:
#         questions=None
    

# if __name__ == '__main__':
#     # app.run(debug=True)
#     import asyncio
#     from hypercorn.asyncio import serve
#     from hypercorn.config import Config

#     config = Config()
#     config.bind = ["localhost:5000"]
#     asyncio.run(serve(app, config))




# import os
# import json
# from flask import Flask,jsonify, request
# from celery import Celery
# import subprocess
# from scripts import quiz_generation

# app = Flask(__name__)
# celery = Celery(app.name, broker='redis://localhost:6379/0')
# celery.conf.update(app.config)

# @app.route('/start_quiz', methods=['POST'])
# def start_quiz():
#     data = request.json
#     grade = data.get('grade')
#     subject = data.get('subject')
#     topic = data.get('topic')

#     print(grade,subject,topic)
#     # Validate inputs
#     if not all([grade, subject, topic]):
#         return jsonify({'error': 'Missing grade, subject or topic'}), 400
    
#     counts = {
#         "easy": 5,
#         "medium": 5,
#         "hard": 5
#     }
    
#     try:
#         questions = quiz_generation.generate_question_dictionary(grade, subject, topic, counts)
        
#         # Start the RL simulation as a Celery task
#         task = start_rl_simulation.delay(questions)
        
#         return jsonify({'message': 'Quiz started!', 'task_id': task.id}), 202
#     except Exception as e:
#         app.logger.error(f"Error starting quiz: {str(e)}")
#         return jsonify({'error': 'Internal server error'}), 500

# @celery.task(name='start_rl_simulation')
# def start_rl_simulation(questions):
#     try:
#         # Convert questions to JSON-serializable format if necessary
#         questions_json = json.dumps(questions)
        
#         # Use absolute path to the RL simulation script
#         script_path = os.path.join(os.path.dirname(__file__), 'rl_simulation.py')
        
#         # Run the RL simulation
#         result = subprocess.run(["python3", script_path, questions_json], 
#                                 capture_output=True, text=True, check=True)
        
#         return result.stdout
#     except subprocess.CalledProcessError as e:
#         app.logger.error(f"RL simulation failed: {e.stderr}")
#         raise
#     except Exception as e:
#         app.logger.error(f"Error in RL simulation: {str(e)}")
#         raise

# if __name__ == '__main__':
#     app.run(debug=True)


from flask import Flask, request, jsonify
from flask_cors import CORS
from werkzeug.utils import secure_filename
import os
import asyncio
import base64
from scripts import custom_flashcard
from scripts import syllabus_extract
from scripts import quiz_generation
from scripts import rag_querying
import subprocess
import dotenv

dotenv.load_dotenv()

youtube_api_key=os.getenv("YOUTUBE_API_KEY")
cohere_api_key=os.getenv("COHERE_API_KEY")
gemini_api_key=os.getenv("GEMINI_API_KEY")
huggigface_api_key=os.getenv("HUGGINGFACE_API_KEY")
pinecone_api_key=os.getenv("PINECONE_API_KEY")

app = Flask(__name__)
CORS(app)

# Configure upload folder
UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Ensure the upload folder exists
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

def encode_bytes(obj):
    if isinstance(obj, bytes):
        return base64.b64encode(obj).decode('utf-8')
    elif isinstance(obj, dict):
        return {key: encode_bytes(value) for key, value in obj.items()}
    elif isinstance(obj, list):
        return [encode_bytes(item) for item in obj]
    else:
        return obj

@app.route('/generate_flashcard', methods=['POST'])
async def generate_flashcard():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part in the request'}), 400
    
    file = request.files['file']
    filetype = request.form.get('filetype')
    grade = request.form.get('grade')
    
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400
    
    if not all([filetype, grade]):
        return jsonify({'error': 'Missing filetype or grade'}), 400
    
    if filetype not in ['img', 'pdf', 'audio', 'video', 'url', 'text', 'ppt']:
        return jsonify({'error': 'Unsupported file type'}), 400
    
    try:
        # Save the file temporarily
        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)
        
        # Generate flashcards
        generator = custom_flashcard.CustomFlashcardGenerator(youtube_api_key,cohere_api_key)
        flashcards = await generator.give_flashcards(filepath, filetype, grade)
        
        # Clean up: remove the temporary file
        os.remove(filepath)
        
        # Encode any bytes objects in the flashcards
        encoded_flashcards = encode_bytes(flashcards)
        
        print(encoded_flashcards)
        return jsonify({'flashcards': encoded_flashcards}), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/generate_syllabus', methods=['POST'])
async def generate_syllabus():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part in the request'}), 400
    
    file = request.files['file']
    
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400
    
    if not file.filename.lower().endswith('.pdf'):
        return jsonify({'error': 'Only PDF files are supported'}), 400
    
    try:
        # Save the file temporarily
        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)
        
        # Extract and process syllabus
        structured_syllabus = syllabus_extract.extract_and_process_syllabus(filepath,gemini_api_key)
        
        # Clean up: remove the temporary file
        os.remove(filepath)
        
        return jsonify({'syllabus': structured_syllabus}), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/start_quiz', methods=['POST'])
def start_quiz():
    data = request.json
    grade = data.get('grade')
    subject = data.get('subject')
    topic = data.get('topic')

    print(grade, subject, topic)

    # Validate inputs
    if not all([grade, subject, topic]):
        return jsonify({'error': 'Missing grade, subject or topic'}), 400
    
    counts = {
        "easy": 5,
        "medium": 5,
        "hard": 5
    }

    try:
        questions = quiz_generation.generate_question_dictionary(grade, subject, topic, counts)
        
        # Here you can send questions back to the frontend directly.
        return jsonify({'questions': questions}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500
    
@app.route('/ai_flashcard', methods=['POST'])
async def ai_flashcard():
    # Check for required fields in the request
    subject = request.form.get('subject')
    grade = request.form.get('grade')
    topic = request.form.get('topic')
    cohere_api_key = request.form.get('cohere_api_key')

    if not all([subject, grade, topic, cohere_api_key]):
        return jsonify({'error': 'Missing subject, grade, topic, or cohere_api_key'}), 400

    try:
        # Generate flashcards using the provided parameters
        qa_output = rag_querying.give_ai_flashcard(subject,grade,topic,cohere_api_key=cohere_api_key)

        return jsonify({'flashcards': qa_output}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500



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
import flask
import io
import base64
from flask import Flask, request, jsonify

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def calculate_item_frequencies(arr):
    """ Replacement for scipy.stats.itemfreq """
    if isinstance(arr, np.ndarray):
        arr = arr.flatten()
    counts = Counter(arr)
    unique_items = np.array(list(counts.keys()))
    frequencies = np.array(list(counts.values()))
    return np.column_stack((unique_items, frequencies))

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
        "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"
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
        
        exp = self.lime_explainer.explain_instance(text, predict_proba, num_features=3, num_samples=20)
        return exp

    def plot_feature_importance(self, text):
        """
        Plot feature importance based on LIME explanation
        """
        lime_exp = self.explain_lime(text)
        features = pd.DataFrame(lime_exp.as_list(), columns=['Feature', 'Importance'])
        
        plt.figure(figsize=(10, 6))
        sns.barplot(data=features, x='Importance', y='Feature')
        plt.title('Feature Importance')
        plt.tight_layout()
        
        # Save plot to base64 string
        buf = io.BytesIO()
        plt.savefig(buf, format='png')
        buf.seek(0)
        plt.close()
        base64_image = base64.b64encode(buf.getvalue()).decode('utf-8')
        return base64_image

    def generate_xai_report(self, text):
        try:
            cleaned_text = self.clean_text(text)
            prediction = self.predict(cleaned_text)
            
            # Generate explanations
            lime_exp = self.explain_lime(cleaned_text)
            
            # Create visualizations
            feature_importance_plot = self.plot_feature_importance(cleaned_text)
            
            # Prepare explanation data
            word_importance = pd.DataFrame(lime_exp.as_list(), columns=['word', 'importance'])
            word_importance = word_importance.sort_values('importance', ascending=False)
            
            return {
                'text': cleaned_text,
                'prediction': prediction.tolist(),
                'word_importance': word_importance.to_dict(orient='records'),
                'feature_importance_plot': feature_importance_plot
            }
            
        except Exception as e:
            logger.error(f"Error in XAI analysis: {str(e)}")
            return {"error": str(e)}

# Initialize the pipeline with your model path
classifier = XAITextClassificationPipeline('/home/yuvraj/Coding/OverloadOblivion_Datahack/models/best_model.h5')

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    if 'text' not in data:
        return jsonify({"error": "No text provided"}), 400
    
    text = data['text']
    report = classifier.generate_xai_report(text)
    return jsonify(report)




if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
