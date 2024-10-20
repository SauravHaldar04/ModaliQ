# import random

# class Question:
#     def __init__(self, text, options, correct_option):
#         self.text = text
#         self.options = options
#         self.correct_option = correct_option

# class CAT:
#     def __init__(self):
#         self.questions = {
#             'easy': [
#                 {"question": "What is 2 + 2?", "options": ["1", "2", "3", "4"], "correct": "4"},
#                 {"question": "What color is the sky?", "options": ["Blue", "Green", "Red", "Yellow"], "correct": "Blue"}
#             ],
#             'medium': [
#                 {"question": "What is the capital of France?", "options": ["Berlin", "Madrid", "Paris", "Rome"], "correct": "Paris"},
#                 {"question": "What is 5 * 6?", "options": ["30", "32", "28", "25"], "correct": "30"}
#             ],
#             'hard': [
#                 {"question": "What is the integral of x dx?", "options": ["x^2/2 + C", "x^3/3 + C", "ln(x) + C", "x + C"], "correct": "x^2/2 + C"},
#                 {"question": "What is the square root of 256?", "options": ["14", "16", "18", "20"], "correct": "16"}
#             ]
#         }
#         self.score = 0
#         self.total_questions = 10
#         self.asked_questions = 0
#         self.current_difficulty = 'easy'
#         self.asked_questions_set = set()  # To keep track of asked questions
#         self.difficulty_count = {'easy': 0, 'medium': 0, 'hard': 0}

#     def ask_question(self):
#         if self.asked_questions >= self.total_questions:
#             print("Quiz finished!")
#             return None
        
#         # Select a question based on current difficulty that hasn't been asked yet
#         available_questions = [q for q in self.questions[self.current_difficulty] if q["question"] not in self.asked_questions_set]

#         if not available_questions:
#             print("No more questions available at this difficulty level.")
#             return None

#         question_data = random.choice(available_questions)
#         question = Question(question_data["question"], question_data["options"], question_data["correct"])
        
#         # Mark this question as asked
#         self.asked_questions_set.add(question.text)

#         # Print the current difficulty level
#         print(f"\nDifficulty Level: {self.current_difficulty.capitalize()}")
#         print(f"Question: {question.text}")
        
#         for idx, option in enumerate(question.options):
#             print(f"{idx + 1}. {option}")

#         # Simulate user input (in a real scenario, you'd get this from user input)
#         user_answer_index = int(input("Select the correct option number: ")) - 1
        
#         # Check if the answer is correct
#         if question.options[user_answer_index] == question.correct_option:
#             print("Correct answer!")
#             reward = self.get_reward(self.current_difficulty)
#             self.score += reward
#             self.difficulty_count[self.current_difficulty] += 1
#             print(f"You earned {reward} point(s)!")
#             self.update_difficulty(correct=True)
#         else:
#             print("Incorrect answer!")
#             self.update_difficulty(correct=False)

#         self.asked_questions += 1

#     def get_reward(self, difficulty):
#         """Return reward based on difficulty."""
#         if difficulty == 'easy':
#             return 1
#         elif difficulty == 'medium':
#             return 2
#         elif difficulty == 'hard':
#             return 3

#     def update_difficulty(self, correct):
#         if correct:
#             if self.current_difficulty == 'easy':
#                 self.current_difficulty = 'medium'
#             elif self.current_difficulty == 'medium':
#                 self.current_difficulty = 'hard'
#         else:
#             if self.current_difficulty == 'hard':
#                 self.current_difficulty = 'medium'
#             elif self.current_difficulty == 'medium':
#                 self.current_difficulty = 'easy'

#     def start_quiz(self):
#         while self.asked_questions < self.total_questions:
#             self.ask_question()
        
#         print(f"\nQuiz finished! Your total score: {self.score}/{self.total_questions * 3}")
#         print(f"Questions answered - Easy: {self.difficulty_count['easy']}, Medium: {self.difficulty_count['medium']}, Hard: {self.difficulty_count['hard']}")

# # Create an instance of CAT and start the quiz
# cat_quiz = CAT()
# cat_quiz.start_quiz()

# import asyncio
# import websockets
# import json
# import random

# class Question:
#     def _init_(self, text, options, correct_option):
#         self.text = text
#         self.options = options
#         self.correct_option = correct_option

# class CAT:
#     def _init_(self):
#         self.questions = {
#             'easy': [
#                 {"question": "What is 2 + 2?", "options": ["1", "2", "3", "4"], "correct": "4"},
#                 {"question": "What color is the sky?", "options": ["Blue", "Green", "Red", "Yellow"], "correct": "Blue"}
#             ],
#             'medium': [
#                 {"question": "What is the capital of France?", "options": ["Berlin", "Madrid", "Paris", "Rome"], "correct": "Paris"},
#                 {"question": "What is 5 * 6?", "options": ["30", "32", "28", "25"], "correct": "30"}
#             ],
#             'hard': [
#                 {"question": "What is the integral of x dx?", "options": ["x^2/2 + C", "x^3/3 + C", "ln(x) + C", "x + C"], "correct": "x^2/2 + C"},
#                 {"question": "What is the square root of 256?", "options": ["14", "16", "18", "20"], "correct": "16"}
#             ]
#         }
#         self.score = 0
#         self.total_questions = 10
#         self.asked_questions = 0
#         self.current_difficulty = 'easy'
#         self.asked_questions_set = set()
#         self.difficulty_count = {'easy': 0, 'medium': 0, 'hard': 0}

#     async def ask_question(self, websocket):
#         if self.asked_questions >= self.total_questions:
#             await websocket.send(json.dumps({"message": "Quiz finished!", "score": self.score}))
#             return
        
#         available_questions = [q for q in self.questions[self.current_difficulty] if q["question"] not in self.asked_questions_set]

#         if not available_questions:
#             await websocket.send(json.dumps({"message": f"No more questions available at {self.current_difficulty} level."}))
#             return

#         question_data = random.choice(available_questions)
#         question = Question(question_data["question"], question_data["options"], question_data["correct"])
        
#         self.asked_questions_set.add(question.text)

#         await websocket.send(json.dumps({
#             "difficulty": self.current_difficulty,
#             "question": question.text,
#             "options": question.options
#         }))

#     async def handle_answer(self, websocket, answer):
#         if answer == self.current_question.correct_option:
#             reward = self.get_reward(self.current_difficulty)
#             self.score += reward
#             self.difficulty_count[self.current_difficulty] += 1
#             await websocket.send(json.dumps({"message": f"Correct answer! You earned {reward} point(s)!"}))
#             self.update_difficulty(correct=True)
#         else:
#             await websocket.send(json.dumps({"message": f"Incorrect answer!"}))
#             self.update_difficulty(correct=False)

#         self.asked_questions += 1

#     def get_reward(self, difficulty):
#         if difficulty == 'easy':
#             return 1
#         elif difficulty == 'medium':
#             return 2
#         elif difficulty == 'hard':
#             return 3

#     def update_difficulty(self, correct):
#         if correct:
#             if self.current_difficulty == 'easy':
#                 self.current_difficulty = 'medium'
#             elif self.current_difficulty == 'medium':
#                 self.current_difficulty = 'hard'
#         else:
#             if self.current_difficulty == 'hard':
#                 self.current_difficulty = 'medium'
#             elif self.current_difficulty == 'medium':
#                 self.current_difficulty = 'easy'

#     async def main(self, websocket, path):
#         while True:
#             await self.ask_question(websocket)
#             try:
#                 answer = await websocket.recv()
#                 await self.handle_answer(websocket, answer)
#             except websockets.exceptions.ConnectionClosed:
#                 break

# start_server = websockets.serve(CAT().main, '0.0.0.0', 8765)

# asyncio.get_event_loop().run_until_complete(start_server)
# asyncio.get_event_loop().run_forever()

# import asyncio
# import websockets
# import json
# import random
# import sys

# class Question:
#     def __init__(self, text, options, correct_option):
#         self.text = text
#         self.options = options
#         self.correct_option = correct_option

# class CAT:
#     def __init__(self, questions):

#         # Define questions based on input (dummy example)
#         self.questions = questions
#         self.score = 0
#         self.total_questions = 10
#         self.asked_questions = 0
#         self.current_difficulty = 'easy'
#         self.asked_questions_set = set()

#     async def ask_question(self, websocket):
#         if self.asked_questions >= self.total_questions:
#             await websocket.send(json.dumps({"message": "Quiz finished!", "score": self.score}))
#             return

#         available_questions = [q for q in self.questions[self.current_difficulty] if q["question"] not in self.asked_questions_set]

#         if not available_questions:
#             await websocket.send(json.dumps({"message": f"No more questions available at {self.current_difficulty} level."}))
#             return

#         question_data = random.choice(available_questions)
#         question = Question(question_data["question"], question_data["options"], question_data["correct"])
#         self.asked_questions_set.add(question.text)

#         await websocket.send(json.dumps({
#             "difficulty": self.current_difficulty,
#             "question": question.text,
#             "options": question.options
#         }))
#         self.current_question = question

#     async def handle_answer(self, websocket, answer):
#         if answer == self.current_question.correct_option:
#             reward = self.get_reward(self.current_difficulty)
#             self.score += reward
#             await websocket.send(json.dumps({"message": f"Correct answer! You earned {reward} point(s)!"}))
#             self.update_difficulty(correct=True)
#         else:
#             await websocket.send(json.dumps({"message": f"Incorrect answer!"}))
#             self.update_difficulty(correct=False)

#         self.asked_questions += 1

#     def get_reward(self, difficulty):
#         if difficulty == 'easy':
#             return 1
#         elif difficulty == 'medium':
#             return 2
#         elif difficulty == 'hard':
#             return 3

#     def update_difficulty(self, correct):
#         if correct:
#             if self.current_difficulty == 'easy':
#                 self.current_difficulty = 'medium'
#             elif self.current_difficulty == 'medium':
#                 self.current_difficulty = 'hard'
#         else:
#             if self.current_difficulty == 'hard':
#                 self.current_difficulty = 'medium'
#             elif self.current_difficulty == 'medium':
#                 self.current_difficulty = 'easy'

#     async def main(self, websocket, path):
#         while True:
#             await self.ask_question(websocket)
#             try:
#                 answer = await websocket.recv()
#                 await self.handle_answer(websocket, answer)
#             except websockets.exceptions.ConnectionClosed:
#                 break

# if __name__ == '__main__':
#     grade = sys.argv[1]
#     subject = sys.argv[2]
#     topic = sys.argv[3]

#     print(f"Starting quiz for Grade: {grade}, Subject: {subject}, Topic: {topic}")
#     quiz = CAT(grade, subject, topic)
    
#     start_server = websockets.serve(quiz.main, '0.0.0.0', 8765)
#     asyncio.get_event_loop().run_until_complete(start_server)
#     asyncio.get_event_loop().run_forever()


import random

class Question:
    def __init__(self, text, options, correct_option):
        self.text = text
        self.options = options
        self.correct_option = correct_option

class CAT:
    def __init__(self, questions,score=0,total_questions=10,asked_questions=0,current_difficulty='easy',asked_questions_set=set(),current_question=None):
        self.questions = questions
        self.score = score
        self.total_questions = total_questions
        self.asked_questions = asked_questions
        self.current_difficulty = current_difficulty
        self.asked_questions_set = asked_questions_set
        self.current_question = current_question

    def get_question(self):
        if self.asked_questions >= self.total_questions:
            return {"message": "Quiz finished!", "score": self.score}
        
        # Get available questions that haven't been asked yet
        available_questions = [
            q for q in self.questions[self.current_difficulty]
            if q["question"] not in self.asked_questions_set
        ]

        if not available_questions:
            return {"message": f"No more questions available at {self.current_difficulty} level."}
        
        # Select a random question
        question_data = random.choice(available_questions)
        question = Question(question_data["question"], question_data["options"], question_data["correct"])
        self.asked_questions_set.add(question.text)
        self.current_question = question

        # Return the question details
        return {
            "difficulty": self.current_difficulty,
            "question": question.text,
            "options": question.options,
            "score": self.score
        }

    def handle_answer(self, answer):
        # Check if the answer is correct
        if answer == self.current_question.correct_option:
            reward = self.get_reward(self.current_difficulty)
            self.score += reward
            response = {"message": f"Correct answer! You earned {reward} point(s)!", "score": self.score}
            self.update_difficulty(correct=True)
        else:
            response = {"message": "Incorrect answer!", "score": self.score}
            self.update_difficulty(correct=False)
        
        self.asked_questions += 1
        return response

    def get_reward(self, difficulty):
        # Reward points based on difficulty level
        return {"easy": 1, "medium": 2, "hard": 3}[difficulty]

    def update_difficulty(self, correct):
        # Adapt the difficulty based on the correctness of the answer
        if correct:
            if self.current_difficulty == 'easy':
                self.current_difficulty = 'medium'
            elif self.current_difficulty == 'medium':
                self.current_difficulty = 'hard'
        else:
            if self.current_difficulty == 'hard':
                self.current_difficulty = 'medium'
            elif self.current_difficulty == 'medium':
                self.current_difficulty = 'easy'
