from PIL import Image
import pytesseract

def image_to_text(image_file):
    # Open the image file
    img = Image.open(image_file)
    
    # Use pytesseract to do OCR on the image
    text = pytesseract.image_to_string(img)
    
    return text

# # Example usage
# if __name__ == "__main__":
#     image_file = " "
#     print(image_to_text(image_file))