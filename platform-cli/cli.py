import sys
import requests

API_URL = "https://YOUR_API_GATEWAY_URL"

def create_service(name):
    response = requests.post(f"{API_URL}/platform/create-service", json={
        "service_name": name
    })
    print(response.json())

def create_tenant(name):
    response = requests.post(f"{API_URL}/platform/create-tenant", json={
        "tenant_name": name
    })
    print(response.json())

def list_services():
    response = requests.get(f"{API_URL}/platform/services")
    print(response.json())

if __name__ == "__main__":
    command = sys.argv[1]

    if command == "create-service":
        create_service(sys.argv[2])
    elif command == "create-tenant":
        create_tenant(sys.argv[2])
    elif command == "list-services":
        list_services()
    else:
        print("Unknown command")
