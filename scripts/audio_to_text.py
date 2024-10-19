import whisper

def audio_to_text(audio_file):
    model = whisper.load_model("base")
    result = model.transcribe(audio_file)
    return result["text"]

# # Usage
# audio_file = "/kaggle/input/audiofordatahack/audio_file.wav"
# text = audio_to_text(audio_file)
# print(text)