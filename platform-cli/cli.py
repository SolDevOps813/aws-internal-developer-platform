import requests
import sys

service_name = sys.argv[1]

response = requests.post(
    "https://platform-api/create-service",
    json={"service_name": service_name}
)

print(response.json())
