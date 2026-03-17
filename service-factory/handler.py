import json
import os
import boto3
import uuid
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get("SERVICE_CATALOG_TABLE")

table = dynamodb.Table(TABLE_NAME)


def response(status, body):
    return {
        "statusCode": status,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
        },
        "body": json.dumps(body)
    }


def create_service(body):
    service_id = str(uuid.uuid4())

    item = {
        "service_id": service_id,
        "service_name": body.get("service_name"),
        "created_at": datetime.utcnow().isoformat(),
        "type": "service"
    }

    table.put_item(Item=item)

    return response(200, {
        "message": "Service created",
        "service": item
    })


def create_tenant(body):
    tenant_id = str(uuid.uuid4())

    item = {
        "service_id": tenant_id,
        "tenant_name": body.get("tenant_name"),
        "created_at": datetime.utcnow().isoformat(),
        "type": "tenant"
    }

    table.put_item(Item=item)

    return response(200, {
        "message": "Tenant created",
        "tenant": item
    })


def list_services():
    result = table.scan()

    return response(200, result.get("Items", []))


def handler(event, context):
    path = event.get("rawPath")
    method = event.get("requestContext", {}).get("http", {}).get("method")

    body = {}
    if event.get("body"):
        body = json.loads(event["body"])

    # ROUTING
    if path == "/platform/create-service" and method == "POST":
        return create_service(body)

    elif path == "/platform/create-tenant" and method == "POST":
        return create_tenant(body)

    elif path == "/platform/services" and method == "GET":
        return list_services()

    return response(404, {"error": "Not found"})
