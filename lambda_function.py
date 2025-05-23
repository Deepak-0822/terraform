import json
import boto3
import fitz  # PyMuPDF
import os
import tempfile

def extract_text_from_pdf(pdf_path):
    text = ""
    pdf_doc = fitz.open(pdf_path)
    for page in pdf_doc:
        text += page.get_text()
    return text

def ask_claude(text, question):
    client = boto3.client("bedrock-runtime", region_name="us-east-1")
    model_id = "anthropic.claude-3-5-sonnet-20240620-v1:0"

    prompt = f"""You are a helpful assistant. Use the following document content to answer the question.

Document:
{text}

Question: {question}
Answer:"""

    response = client.invoke_model(
        contentType="application/json",
        body=json.dumps({
            "anthropic_version": "bedrock-2023-05-31",
            "max_tokens": 1000,
            "temperature": 0.5,
            "messages": [{"role": "user", "content": prompt}]
        }),
        modelId=model_id
    )

    result = json.loads(response['body'].read())
    return result["content"][0]["text"]

def lambda_handler(event, context):
    try:
        body = {}
        if event and "body" in event and event["body"]:
            body = json.loads(event["body"])

        question = body.get("question")
        bucket = 'demo-tfstate2'
        key = 'guru/Use-case-7-apigateway-AI-test.pdf'

        if not all([bucket, key, question]):
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing bucket, key, or question"})
            }

        s3 = boto3.client("s3")
        file_name = key.split("/")[-1]
        local_path = f"/tmp/{file_name}"
        s3.download_file(bucket, key, local_path)

        text = extract_text_from_pdf(local_path)
        answer = ask_claude(text, question)

        return {
            "statusCode": 200,
            "body": json.dumps({"answer": answer})
        }

    except Exception as e:
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}
