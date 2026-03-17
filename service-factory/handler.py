import json
import boto3
import subprocess

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('platform-services')

def handler(event, context):

    body = json.loads(event["body"])
    service_name = body["service_name"]

    # store service in catalog
    table.put_item(
        Item={
            "service_name": service_name,
            "status": "creating"
        }
    )

    # normally you would trigger repo creation + pipeline
    print(f"Creating service {service_name}")

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": f"Service {service_name} creation started"
        })
    }
