import os
import streamlit as st
from langchain_openai import ChatOpenAI
from langchain_community.utilities import SQLDatabase
from langchain.callbacks import StreamlitCallbackHandler
from langchain_community.agent_toolkits import create_sql_agent
from gtts import gTTS
import io
import base64
from dotenv import load_dotenv

os.environ["OPENAI_API_KEY"] = os.getenv("OPENAI_API_KEY")


st.title('SQL Bot 🤖')


def init_database(user: str, password: str, host: str, port: str, database: str) -> SQLDatabase:
    db_uri = f"mysql+mysqlconnector://{user}:{password}@{host}:{port}/{database}"
    return SQLDatabase.from_uri(db_uri)


def create_sql_agent_with_database(temperature, db, query):
    st.write("Temperature:", temperature)
    llm = ChatOpenAI(model="gpt-3.5-turbo-16k", temperature=temperature, verbose=True)
    agent_executor = create_sql_agent(llm, db=db, agent_type="openai-tools")
    return agent_executor, query


def text_to_speech(text):
    tts = gTTS(text=text, lang='en')
    audio_io = io.BytesIO()
    tts.write_to_fp(audio_io)
    return audio_io.getvalue()


with st.sidebar:
    st.subheader("Settings")
    st.write("This is a simple chat application using MySQL. Connect to the database and start chatting.")
    
    host = st.text_input("Host", value="127.0.0.1")
    port = st.text_input("Port", value="3306")
    user = st.text_input("User", value="root")
    password = st.text_input("Password", type="password", value="8008528123")
    database = st.text_input("Database", value="salesorderschema")
    
    if st.button("Connect"):
        with st.spinner("Connecting to database..."):
            db = init_database(user, password, host, port, database)
            st.session_state.db = db
            st.success("Connected to database!")
    
    
    temperature = st.slider(
        "Select temperature",
        0.0, 1.0, 0.5, step=0.01)


user_query = st.text_area("Enter your SQL-related query:", "List Top 10 Employees by Salary?")

if st.button('Submit'):
    if user_query:
        st.write("User Query 🤔💭:", user_query)
        if 'db' in st.session_state:
            agent_executor, query = create_sql_agent_with_database(temperature, st.session_state.db, user_query)
            with st.spinner("Thinking..."):
                response = agent_executor.run(user_query)
                st.write("Response 🤖 :", response)
                if response:
                    audio_data = text_to_speech(response)
                    st.write("🔊")
                    st.audio(audio_data, format='audio/wav')
        else:
            st.error("Please connect to the database first.")