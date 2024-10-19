# import requests
# from bs4 import BeautifulSoup

# # def get_image(search_query):
# #     # Construct the search URL
# #     url = f"https://www.google.com/search?hl=en&tbm=isch&q={search_query}"
    
# #     # Set headers to mimic a real browser request
# #     headers = {
# #         'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
# #     }
    
# #     # Send a request to the URL
# #     response = requests.get(url, headers=headers)

# #     # Check if the request was successful
# #     if response.status_code == 200:
# #         # Parse the HTML content
# #         soup = BeautifulSoup(response.content, 'html.parser')
        
# #         # Find all image elements
# #         img_elements = soup.find_all('img')

# #         # Check if there are any images found
# #         if img_elements:
# #             img_url = img_elements[1]['src']  # Get the first image URL (index 1 as index 0 is a placeholder)
            
# #             try:
# #                 # Download the image
# #                 img_data = requests.get(img_url).content
# #                 print(f'Downloaded image from: {img_url}')
# #                 return img_data
# #             except Exception as e:
# #                 print(f"Could not download image: {e}")
# #                 return None
# #         else:
# #             print("No images found.")
# #             return None
# #     else:
# #         print("Failed to retrieve the webpage.")
# #         return None

# import requests
# from bs4 import BeautifulSoup
# import time

# def get_image(search_query):
#     # Construct the search URL
#     url = f"https://www.google.com/search?hl=en&tbm=isch&q={search_query}"
    
#     # Set headers to mimic a real browser request
#     headers = {
#         'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
#     }

#     for attempt in range(3):  # Retry up to 3 times
#         try:
#             # Send a request to the URL with a timeout
#             response = requests.get(url, headers=headers, timeout=10)

#             # Check if the request was successful
#             if response.status_code == 200:
#                 # Parse the HTML content
#                 soup = BeautifulSoup(response.content, 'html.parser')
                
#                 # Find all image elements
#                 img_elements = soup.find_all('img')

#                 # Check if there are any images found
#                 if img_elements:
#                     img_url = img_elements[1]['src']  # Get the first image URL (index 1 as index 0 is a placeholder)
                    
#                     try:
#                         # Download the image
#                         img_data = requests.get(img_url).content
#                         print(f'Downloaded image from: {img_url}')
#                         return img_data
#                     except Exception as e:
#                         print(f"Could not download image: {e}")
#                         return None
#                 else:
#                     print("No images found.")
#                     return None
#             else:
#                 print("Failed to retrieve the webpage.")
#                 return None
            
#         except requests.exceptions.Timeout:
#             print("Request timed out, retrying...")
#             time.sleep(2)  # Wait before retrying
#         except requests.exceptions.RequestException as e:
#             print(f"An error occurred: {e}")
#             return None

    
# def get_video_link(search_query):
#     api_key = "AIzaSyBkyTVGU3hKEYCgaY4HfU6Qq161b8Q_yr4"  # Replace with your actual API key
#     url = f"https://www.googleapis.com/youtube/v3/search?q={search_query}&key={api_key}&part=id&type=video"
    
#     response = requests.get(url)
#     data = response.json()
    
#     # Check if 'items' is in the response and has at least one item
#     if "items" in data and len(data["items"]) > 0:
#         video_id = data["items"][0]["id"].get("videoId")  # Use .get() to avoid KeyError
#         if video_id:  # Check if video_id is not None
#             video_link = f"https://www.youtube.com/watch?v={video_id}"
#             return video_link
#         else:
#             return "No videoId found in the response."
#     else:
#         return "No videos found for the given search query."

# # search_query = "abdul bari c++ course"
# # video_link = get_video_link(search_query)
# # print(video_link)

import requests
from bs4 import BeautifulSoup
import time

def get_image(search_query):
    # Construct the search URL
    url = f"https://www.google.com/search?hl=en&tbm=isch&q={search_query}"
    
    # Set headers to mimic a real browser request
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
    }

    for attempt in range(3):  # Retry up to 3 times
        try:
            # Send a request to the URL with a timeout
            response = requests.get(url, headers=headers, timeout=10)

            # Check if the request was successful
            if response.status_code == 200:
                # Parse the HTML content
                soup = BeautifulSoup(response.content, 'html.parser')
                
                # Find all image elements
                img_elements = soup.find_all('img')

                # Check if there are any images found
                if img_elements:
                    img_url = img_elements[1]['src']  # Get the first image URL (index 1 as index 0 is a placeholder)
                    
                    try:
                        # Download the image
                        img_data = requests.get(img_url).content
                        print(f'Downloaded image from: {img_url}')
                        return img_data
                    except Exception as e:
                        print(f"Could not download image: {e}")
                        return None
                else:
                    print("No images found.")
                    return None
            else:
                print("Failed to retrieve the webpage.")
                return None
            
        except requests.exceptions.Timeout:
            print("Request timed out, retrying...")
            time.sleep(2)  # Wait before retrying
        except requests.exceptions.RequestException as e:
            print(f"An error occurred: {e}")
            return None

def get_video_link(search_query):
    api_key = "YOUR_API_KEY"  # Replace with your actual API key
    url = f"https://www.googleapis.com/youtube/v3/search?q={search_query}&key={api_key}&part=id&type=video"
    
    for attempt in range(3):  # Retry up to 3 times
        try:
            response = requests.get(url, timeout=10)
            response.raise_for_status()  # Raise an error for bad responses
            
            data = response.json()
            
            # Check if 'items' is in the response and has at least one item
            if "items" in data and len(data["items"]) > 0:
                video_id = data["items"][0]["id"].get("videoId")  # Use .get() to avoid KeyError
                if video_id:  # Check if video_id is not None
                    video_link = f"https://www.youtube.com/watch?v={video_id}"
                    return video_link
                else:
                    return "No videoId found in the response."
            else:
                return "No videos found for the given search query."
        
        except requests.exceptions.Timeout:
            print("Request timed out, retrying...")
            time.sleep(2)  # Wait before retrying
        except requests.exceptions.RequestException as e:
            print(f"An error occurred: {e}")
            return None

# Example usage of both functions:
if __name__ == "__main__":
    search_query_image = "cats"
    search_query_video = "abdul bari c++ course"

    image_data = get_image(search_query_image)
    print(f"Image Data: {image_data[:100]}...")  # Print first 100 bytes of image data

    video_link = get_video_link(search_query_video)
    print(f"Video Link: {video_link}")