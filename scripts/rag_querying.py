from langchain_cohere import ChatCohere
from langchain.prompts import PromptTemplate
from langchain.chains import LLMChain
import os
from langchain_huggingface import HuggingFaceEmbeddings
from pinecone import Pinecone

model_name = "sentence-transformers/all-MiniLM-L6-v2"
embeddings = HuggingFaceEmbeddings(model_name=model_name)

def query_pinecone(query, embeddings, index, top_k=50):
    # Embed the query text
    query_embedding = embeddings.embed_query(query)

    # Perform the search in the Pinecone index
    query_response = index.query(
        vector=query_embedding,  # Query vector
        top_k=top_k,             # Number of top results to return
        include_metadata=True    # Include metadata in the response
    )

    return query_response

def generate_answer(context, query_text, cohere_api_key, grade):
    llm = ChatCohere(cohere_api_key=cohere_api_key)
    
    prompt_template = PromptTemplate(
        input_variables=["grade", "context", "query"],
        template="""
        You are an educational assistant. Based on the following context, query, and the student's grade level, generate four questions with their corresponding answers.

        Grade Level: {grade}
        Context: {context}
        Query: {query}

        Please format your response as follows:
        Question 1: [Question]
        Answer 1: [Answer]
        
        Question 2: [Question]
        Answer 2: [Answer]
        
        Question 3: [Question]
        Answer 3: [Answer]
        
        Question 4: [Question]
        Answer 4: [Answer]
        """
    )
    
    qa_chain = LLMChain(llm=llm, prompt=prompt_template)
    
    qa_output = qa_chain.run(grade=grade, context=context, query=query_text)
    return qa_output

def answer_query(query_text, grade, cohere_api_key,huggingface_api_key,pinecone_api_key):#cohere_api_key="RxSPixDw28aNcvuOvUJivFUiepCOiByY4eBmrY2p", huggingface_api_key="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", pinecone_api_key="2b10e565-5508-4780-9d20-b875898a9d15"):
    os.environ['HUGGINGFACE_TOKEN'] = huggingface_api_key

    # Initialize Pinecone instance
    pc = Pinecone(
        api_key=pinecone_api_key,
        environment="gcp-starter"
    )
    # Access the existing Pinecone index
    index = pc.Index('datahack1')

    query_response = query_pinecone(query_text, embeddings, index)
    combined_context = " ".join([match['metadata']['text'] for match in query_response['matches']])
    
    structured_answer = generate_answer(combined_context, query_text, cohere_api_key, grade)
    return structured_answer

def structure_qa_output(raw_output):
    qa_pairs = []
    qa_blocks = raw_output.strip().split('\n\n')
    for block in qa_blocks:
        lines = block.split('\n')
        if len(lines) >= 2:
            question = lines[0].split(": ", 1)[1]
            answer = lines[1].split(": ", 1)[1]
            qa_pairs.append({"question": question.strip(), "answer": answer.strip()})
    return qa_pairs

def give_flashcard(subject, grade, topic, cohere_api_key):
    llm = ChatCohere(cohere_api_key=cohere_api_key)
    
    prompt_template = PromptTemplate(
        input_variables=["grade", "subject", "topic"],
        template="""
        You are an educational assistant. Based on the following keywords and the student's grade level, generate a few questions with their corresponding answers.
        
        Grade Level: {grade}
        Subject: {subject}
        Topic: {topic}

        Please format your response as follows:
        Question 1: [Question]
        Answer 1: [Answer]
        
        Question 2: [Question]
        Answer 2: [Answer]
        
        Question 3: [Question]
        Answer 3: [Answer]
        
        ...
        """
    )
    
    qa_chain = LLMChain(llm=llm, prompt=prompt_template)
    
    return qa_chain.run(grade=grade, subject=subject, topic=topic)

# # Example usage
# subject = "Chemistry"
# grade = "11"
# topic = "Alcohols"
# cohere_api_key = "RxSPixDw28aNcvuOvUJivFUiepCOiByY4eBmrY2p"

def give_ai_flashcard(subject,grade,topic,cohere_api_key):
    qa_output = give_flashcard(subject, grade, topic, cohere_api_key)
    structured_output = structure_qa_output(qa_output)
    return structured_output

