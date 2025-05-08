import uuid
import boto3
import os
from PIL import Image
 
# AWS SDK clients
s3_client = boto3.client('s3')
sns_client = boto3.client('sns')
 
# Required environment variables
DEST_BUCKET = os.environ.get('DEST_BUCKET')
SNS_TOPIC_ARN = os.environ.get('SNS_TOPIC_ARN')
 
def resize_image(image_path, resized_path):
    try:
        with Image.open(image_path) as image:
            image = image.convert('RGB')  # Ensure format is JPEG-compatible
            image = image.resize((1024, 1024))
            image.save(resized_path, format='JPEG')
    except Exception as e:
        raise Exception(f"Image resize failed: {str(e)}")
 
def lambda_handler(event, context):
    try:
        bucket = event['Records'][0]['s3']['bucket']['name']
        key = event['Records'][0]['s3']['object']['key']
        file_name = os.path.basename(key)
 
        download_path = f'/tmp/{uuid.uuid4()}_{file_name}'
        upload_path = f'/tmp/resized-{file_name}'
 
        # Download the image from source bucket
        s3_client.download_file(bucket, key, download_path)
 
        # Resize the image
        resize_image(download_path, upload_path)
 
        # Upload to destination bucket
        s3_client.upload_file(upload_path, DEST_BUCKET, f'resized/{file_name}')
 
        # Send SNS notification (Success)
        message = f"The image '{file_name}' was successfully resized and uploaded to '{DEST_BUCKET}/resized/{file_name}'."
        sns.publish(TopicArn=SNS_TOPIC_ARN, Message=message)
        else:
                # Log an error message if the event record structure is unexpected
                print("Error: Invalid S3 event record structure")
 
 
        return {
            'statusCode': 200,
            'body': message
        }
 
    except Exception as e:
        # Send SNS notification (Failure)
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