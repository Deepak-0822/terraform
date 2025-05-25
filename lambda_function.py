import boto3
import os
import psycopg2
import tiktoken
import uuid
import json
import cohere  # ✅ Replace Bedrock with Cohere
from PyPDF2 import PdfReader
from botocore.exceptions import ClientError

# --- Configuration ---
DB_SECRET_NAME = "rds!db-c0833db3-0284-4e98-85a7-0d8558ce9d83"
REGION = "us-east-1"
CHUNK_SIZE = 500
COHERE_API_KEY = os.environ.get("COHERE_API_KEY")  # ✅ Set this in Lambda env vars
COHERE_MODEL_ID = "embed-v4.0"

def lambda_handler(event, context):
    s3_bucket = 'demo-tfstate2'
    s3_key = 'guru/Use-case-7-apigateway-AI-test.pdf'
    s3 = boto3.client('s3')

    # Download file
    tmp_file = f"/tmp/{uuid.uuid4()}.pdf"
    s3.download_file(s3_bucket, s3_key, tmp_file)

    # Process PDF
    text = parse_pdf(tmp_file)
    chunks = chunk_text(text)
    embeddings = get_embeddings(chunks)

    # Store in PostgreSQL
    store_in_postgres(chunks, embeddings)

    return {"statusCode": 200, "body": "Embeddings stored successfully"}

def parse_pdf(file_path):
    reader = PdfReader(file_path)
    return "\n".join(page.extract_text() for page in reader.pages if page.extract_text())

def chunk_text(text):
    tokenizer = tiktoken.get_encoding("cl100k_base")
    tokens = tokenizer.encode(text)
    chunks = [tokens[i:i + CHUNK_SIZE] for i in range(0, len(tokens), CHUNK_SIZE)]
    return [tokenizer.decode(chunk) for chunk in chunks]

def get_embeddings(chunks):
    co = cohere.Client(COHERE_API_KEY)
    response = co.embed(
        texts=chunks,
        model=COHERE_MODEL_ID,
        input_type="search_document"
    )
    return response.embeddings

def store_in_postgres(chunks, embeddings):
    secret_client = boto3.client('secretsmanager')
    secret = json.loads(secret_client.get_secret_value(SecretId=DB_SECRET_NAME)['SecretString'])

    conn = psycopg2.connect(
        dbname=secret['database-1'],
        user=secret['postgres'],
        password=secret['YVLQL>]HN<fMcfno-4ku[mqNB2iY'],
        host=secret['database-1.czews2w6cjln.ap-south-1.rds.amazonaws.com'],
        port=secret['5432']
    )
    cur = conn.cursor()
    for chunk, emb in zip(chunks, embeddings):
        cur.execute("INSERT INTO documents (chunk, embedding) VALUES (%s, %s)", (chunk, emb))
    conn.commit()
    cur.close()
    conn.close()
