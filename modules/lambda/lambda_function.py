import uuid
import boto3
import os
from PIL import Image
 
# Clients
s3_client = boto3.client('s3')
sns_client = boto3.client('sns')
 
# Environment variables
DEST_BUCKET = os.environ.get('DEST_BUCKET')
SNS_TOPIC_ARN = os.environ.get('SNS_TOPIC_ARN')
 
def resize_image(image_path, resized_path):
    try:
        with Image.open(image_path) as image:
            image = image.convert('RGB')  # ensure format compatibility
            image = image.resize((1024, 1024))
            image.save(resized_path, format='JPEG')
    except Exception as e:
        raise Exception(f"Image resize failed: {str(e)}")
 
def lambda_handler(event, context):
    try:
        # Get event details
        bucket = event['Records'][0]['s3']['bucket']['name']
        key    = event['Records'][0]['s3']['object']['key']
        file_name = os.path.basename(key)
 
        # Paths
        download_path = f'/tmp/{uuid.uuid4()}_{file_name}'
        upload_path = f'/tmp/resized-{file_name}'
 
        # Download from source bucket
        s3_client.download_file(bucket, key, download_path)
 
        # Resize
        resize_image(download_path, upload_path)
 
        # Upload to destination bucket
        s3_client.upload_file(upload_path, DEST_BUCKET, f'resized/{file_name}')
 
        # Send SNS notification
        message = f"The image '{file_name}' has been resized and uploaded to '{DEST_BUCKET}/resized/{file_name}'."
        sns_client.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject="Image Resize Success",
            Message=message
        )
 
        return {
            'statusCode': 200,
            'body': message
        }
 
    except Exception as e:
        # Send SNS failure message
        error_msg = f"Image processing failed: {str(e)}"
        if SNS_TOPIC_ARN:
            sns_client.publish(
                TopicArn=SNS_TOPIC_ARN,
                Subject="Image Resize Failed",
                Message=error_msg
            )
        return {
            'statusCode': 500,
            'body': error_msg
        }
    response = sns_client.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject="Image Resize Success",
        Message=message
    )
    print("SNS publish response:", response)
 