import uuid
import boto3
import os
from PIL import Image

# AWS SDK clients
s3_client = boto3.client('s3')
sns_client = boto3.client('sns', region_name='ap-south-1') # Specify region for SNS client

# Required environment variables
DEST_BUCKET = os.environ.get('DEST_BUCKET')
sns_topic_arn = 'arn:aws:sns:ap-south-1:380183619747:image-process-topic'

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
        if 'Records' in event and len(event['Records']) > 0 and 's3' in event['Records'][0] and 'bucket' in event['Records'][0]['s3'] and 'name' in event['Records'][0]['s3']['bucket'] and 'object' in event['Records'][0]['s3'] and 'key' in event['Records'][0]['s3']['object']:
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
            sns_client.publish(TopicArn=sns_topic_arn, Message=message)

            return {
                'statusCode': 200,
                'body': message
            }
        else:
            # Log an error message if the event record structure is unexpected
            print("Error: Invalid S3 event record structure")
            return {
                'statusCode': 400,
                'body': "Error: Invalid S3 event record structure"
            }

    except Exception as e:
        print(f"Error processing S3 event: {str(e)}")
        # Send SNS notification (Failure)
        failure_message = f"Error processing image '{file_name}': {str(e)}" if 'file_name' in locals() else f"Error processing S3 event: {str(e)}"
        sns_client.publish(TopicArn=sns_topic_arn, Message=failure_message)
        return {
            'statusCode': 500,
            'body': f"Error processing S3 event: {str(e)}"
        }