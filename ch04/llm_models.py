import os

from dotenv import load_dotenv
from langchain_google_genai import ChatGoogleGenerativeAI

load_dotenv()  # A
api_key = os.getenv("GEMINI_API_KEY")  # B


def get_llm():  # C
    return ChatGoogleGenerativeAI(
        api_key=api_key,
        model="gemini-flash-latest",
    )


# A Load the environment variables from the .env file
# B Get the OpenAI API key from the environment variables
# C Instantiate and return the ChatGoogleGenerativeAI model
