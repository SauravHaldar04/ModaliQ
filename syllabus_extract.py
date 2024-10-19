import fitz  # PyMuPDF
import google.generativeai as genai

# Configure the Gemini API
genai.configure(api_key='')

def extract_text_from_pdf(pdf_path):
    text = ""
    with fitz.open(pdf_path) as doc:
        for page in doc:
            text += page.get_text()
    return text

def process_syllabus_with_gemini(syllabus_text):
    model = genai.GenerativeModel('gemini-pro')
    
    prompt = f"""
    Given the following syllabus text, extract and organize the information into a structured format.
    For each subject, list ALL the main topics covered. Do not limit the number of topics.
    Ignore any irrelevant information like faculty names, class years, or administrative details.
    Present the information in the following format:

    Subject Name:
    - Topic 1
    - Topic 2
    - Topic 3
    ...

    Ensure that ALL relevant topics for each subject are included, no matter how many there are.

    Syllabus text:
    {syllabus_text}
    """

    response = model.generate_content(prompt)
    return response.text

# Usage
pdf_path = '/kaggle/input/syllabusdatahack/Third Year Syllabus Term Test -1.pdf'
syllabus_text = extract_text_from_pdf(pdf_path)
structured_syllabus = process_syllabus_with_gemini(syllabus_text)

print(structured_syllabus)