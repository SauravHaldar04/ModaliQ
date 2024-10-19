import io
from pdf2image import convert_from_path
import pytesseract
from PIL import Image

def pdf_to_text(pdf_file):
    text = ""
    try:
        # Convert PDF to list of images
        images = convert_from_path(pdf_file)
        
        for i, image in enumerate(images):
            # Perform OCR on each image
            text += pytesseract.image_to_string(image) + "\n\n"
            
            # Print progress
            print(f"Processed page {i+1}/{len(images)}")
    
    except Exception as e:
        print(f"An error occurred: {str(e)}")
    
    return text

# # Usage
# pdf_file = "/kaggle/input/datasetforpdftotext/NCERT-Class-11-Chemistry-Part-1.pdf"
# text = pdf_to_text(pdf_file)

# # Print first 1000 characters to preview
# print(text[:1000])

# # Save the entire text to a file
# with io.open("extracted_text.txt", "w", encoding="utf-8") as f:
#     f.write(text)

# print(f"Full text has been saved to 'extracted_text.txt'")