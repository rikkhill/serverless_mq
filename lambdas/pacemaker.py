import boto3
from os import environ
from datetime import datetime

# pacemaker.py

# Writes a timestamped file to S3

def handler(event, context):
	BUCKET_NAME = environ["bucket_name"]
	s3 = boto3.resource("s3")
	bucket = s3.Bucket(BUCKET_NAME)
	path = "heartbeats/%s" % datetime.now().strftime("%Y%m%d-%H%M%S")
	body = "I am alive!"
	bucket.put_object(
		ACL='public-read',
		ContentType='application/text',
		Key=path,
		Body=body)

	return True
