import requests
from bs4 import BeautifulSoup
import re
from urllib.parse import urlparse
from googleapiclient.discovery import build
from youtube_transcript_api import YouTubeTranscriptApi

# Replace with your own API key
YOUTUBE_API_KEY = " "

def get_youtube_transcript(url):
    try:
        # Extract video ID from URL
        video_id = urlparse(url).query[2:] if 'v=' in url else url.split('/')[-1]

        # Use YouTube Data API to get video details
        youtube = build('youtube', 'v3', developerKey=YOUTUBE_API_KEY)
        video_response = youtube.videos().list(
            part='snippet',
            id=video_id
        ).execute()

        if not video_response['items']:
            return "Error: Video not found or is unavailable."

        # Get video title
        video_title = video_response['items'][0]['snippet']['title']

        # Use YouTubeTranscriptApi to get transcript
        transcript = YouTubeTranscriptApi.get_transcript(video_id)
        
        # Combine transcript text
        full_transcript = f"Title: {video_title}\n\n"
        full_transcript += " ".join([entry['text'] for entry in transcript])

        return full_transcript
    except Exception as e:
        return f"An error occurred while processing the YouTube video: {str(e)}"

def get_webpage_text(url):
    try:
        headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'}
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.text, 'html.parser')
        
        for script in soup(["script", "style", "nav", "footer", "aside"]):
            script.decompose()
        
        text = soup.get_text(separator='\n', strip=True)
        
        lines = (line.strip() for line in text.splitlines())
        chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
        text = '\n'.join(chunk for chunk in chunks if chunk)
        
        text = re.sub(r'\n\s*\n', '\n\n', text)
        
        return text
    except Exception as e:
        return f"An error occurred while fetching the webpage: {str(e)}"

def url_to_text(url):
    parsed_url = urlparse(url)
    
    if 'youtube.com' in parsed_url.netloc or 'youtu.be' in parsed_url.netloc:
        return get_youtube_transcript(url)
    else:
        return get_webpage_text(url)

# Usage
urls = [
    "https://www.youtube.com/watch?v=hiOjTJgl6GU",
    # "https://www.example.com"  # Add a non-YouTube URL for testing
]

for url in urls:
    print(f"Processing URL: {url}")
    text = url_to_text(url)
    print(text[:500])  # Print the first 500 characters as a preview
    print("\n" + "="*50 + "\n")