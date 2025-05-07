import boto3
from PIL import Image
import io
import os

sns = boto3.client('sns')
s3 = boto3.client('s3')

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key    = event['Records'][0]['s3']['object']['key']
    
    download_path = f'/tmp/{key}'
    s3.download_file(bucket, key, download_path)
    
    with Image.open(download_path) as img:
        img = img.resize((128, 128))
        resized_path = f'/tmp/resized-{key}'
        img.save(resized_path)
        
    s3.upload_file(resized_path, bucket, f'resized/{key}')
    
    sns.publish(
        TopicArn=os.environ['SNS_TOPIC_ARN'],
        Message=f"Image {key} has been resized and uploaded to resized/{key}"
    )
