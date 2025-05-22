import json
import base64
import os
import fitz  # PyMuPDF
import boto3
import tempfile

def llm_output(img_bytes, base64_content, question):
    if not base64_content:
        img_base64 = base64.b64encode(img_bytes).decode('utf-8')
    else:
        img_base64 = img_bytes

    client = boto3.client('bedrock-runtime', region_name='us-east-1')
    model_id = "anthropic.claude-3-5-sonnet-20240620-v1:0"

    response = client.invoke_model(
        contentType='application/json',
        body=json.dumps({
            "anthropic_version": "bedrock-2023-05-31",
            "max_tokens": 8500,
            "messages": [
                {
                    "role": "user",
                    "content": [
                        {"type": "image", "source": {"type": "base64", "media_type": "image/jpeg", "data": img_base64}},
                        {"type": "text", "text": question}
                    ]
                }
            ],
            "temperature": 0
        }),
        modelId=model_id
    )

    result = json.loads(response['body'].read().decode('utf-8'))
    return result['content'][0]['text']

def image_to_base64(image_path):
    with open(image_path, "rb") as f:
        return base64.b64encode(f.read()).decode('utf-8')

def pdf_to_llm_summaries(pdf_path, question):
    pdf_document = fitz.open(pdf_path)
    result = ""
    for i, page in enumerate(pdf_document):
        pix = page.get_pixmap(matrix=fitz.Matrix(2, 2), colorspace=fitz.csRGB)
        with tempfile.NamedTemporaryFile(suffix=".png", delete=False) as tmp_img:
            pix.save(tmp_img.name)
            img_base64 = image_to_base64(tmp_img.name)
            summary = llm_output(img_base64, True, question)
            result += f"\n\nPage {i+1}:\n{summary}"
            os.remove(tmp_img.name)
    return result

def lambda_handler(event, context):
    try:
        bucket = 'demo-tfstate2'
        key = 'guru/Use-case-7-apigateway-AI-test.pdf'
        question = 'project overview'

        s3 = boto3.client('s3')
        file_name = key.split("/")[-1]
        local_path = f"/tmp/{file_name}"

        # Download file from S3
        s3.download_file(bucket, key, local_path)

        ext = file_name.split('.')[-1].lower()
        if ext == 'pdf':
            message = pdf_to_llm_summaries(local_path, question)
            page_count = fitz.open(local_path).page_count
        else:
            with open(local_path, "rb") as f:
                img_bytes = f.read()
            message = llm_output(img_bytes, False, question)
            page_count = 1

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": message.strip(),
                "page_count": page_count
            })
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
