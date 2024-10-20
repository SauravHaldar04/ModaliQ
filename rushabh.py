import os
from flask import Flask, request, jsonify
import cohere

# Set up Cohere API key (replace with your actual key)
os.environ['COHERE_API_KEY'] = 'VBWR0jG1SJt7xLtnYzwPbSq2TuL94WlnT6tZZtOk'
co = cohere.Client(os.environ['COHERE_API_KEY'])

app = Flask(__name__)

def generate_question(grade, subject, topic, difficulty):
    # Create a prompt with more explicit instructions
    prompt = f"""Generate a multiple-choice question for a student in grade {grade} about {subject} and {topic}. 
    The difficulty level of the question should be {difficulty}.
    Provide the question in the following format:
    
    Question: [Question text]
    A. [Option A]
    B. [Option B]
    C. [Option C]
    D. [Option D]
    Correct Answer: [A, B, C, or D]

    Ensure that the question and answers are all distinct and that there is one correct answer clearly indicated.
    """

    try:
        # Call the Cohere API
        response = co.generate(
            model='command-xlarge-nightly',  # You can choose a different model if needed
            prompt=prompt,
            max_tokens=150,  # Adjust as needed
            temperature=0.7,  # Adjust for creativity vs. accuracy
            stop_sequences=["\n\n"]  # Stops at a double new line
        )

        # Get the generated text
        result = response.generations[0].text.strip()
        return result
    
    except Exception as e:
        print(f"Error generating question: {e}")
        return f"Error: {str(e)}"

def generate_multiple_questions(grade, subject, topic, difficulty, count):
    questions = []
    for _ in range(count):
        question = generate_question(grade, subject, topic, difficulty)
        questions.append(question)
    return questions

def generate_question_dictionary(grade, subject, topic, counts):
    question_dict = {}
    
    for difficulty, count in counts.items():
        questions = generate_multiple_questions(grade, subject, topic, difficulty, count)
        question_dict[difficulty] = questions
    
    return question_dict

@app.route('/generate_questions', methods=['POST'])
def generate_questions():
    data = request.json
    
    # Extract fields from the JSON request
    grade = data.get('grade')
    subject = data.get('subject')
    topic = data.get('topic')
    
    counts = {
        "easy": data.get('easy_count', 10),  # Default to 10 if not provided
        "medium": data.get('medium_count', 10),  # Default to 10 if not provided
        "hard": data.get('hard_count', 10)  # Default to 10 if not provided
    }

    if not grade or not subject or not topic:
        return jsonify({'error': 'Missing grade, subject, or topic'}), 400

    # Generate questions
    question_dictionary = generate_question_dictionary(grade, subject, topic, counts)

    # Return the dictionary as a JSON response
    return jsonify(question_dictionary), 200

if __name__ == "__main__":
    app.run(debug=True)  # Set debug=False in production
