import moviepy.editor as mp
import whisper
import os

def video_to_text(video_file):
    # Extract audio from video
    video = mp.VideoFileClip(video_file)
    audio_file = "temp_audio.wav"
    video.audio.write_audiofile(audio_file)
    
    # Use Whisper to transcribe the audio
    model = whisper.load_model("base")
    result = model.transcribe(audio_file)
    text = result["text"]
    
    # Clean up: remove the temporary audio file
    os.remove(audio_file)
    
    return text

# Usage
video_file = "/content/1. while Loop and do..while Loop.mp4"
text = video_to_text(video_file)
print(text)