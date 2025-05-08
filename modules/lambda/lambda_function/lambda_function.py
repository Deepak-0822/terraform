import uuid
import boto3
import os
from PIL import Image

s3_client = boto3.client('s3')

def resize_image(image_path, resized_path):
    with Image.open(image_path) as image:
        image = image.resize((1024, 1024))
        image.save(resized_path, image.format)

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key    = event['Records'][0]['s3']['object']['key']
    
    # Get only the file name
    file_name = os.path.basename(key)
    
    # Create temp paths
    download_path = f'/tmp/{uuid.uuid4()}_{file_name}'
    upload_path = f'/tmp/resized-{file_name}'
    
    # Download, resize, upload
    s3_client.download_file(bucket, key, download_path)
    resize_image(download_path, upload_path)
    s3_client.upload_file(upload_path, bucket, f'resized/{file_name}')
    return {
        'statusCode': 200,
        'body': 'Image resized successfully!'
    }