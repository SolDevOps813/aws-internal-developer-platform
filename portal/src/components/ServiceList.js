services:

  api-service:
    description: Serverless HTTP API
    module: api-service
    runtime: python

  worker-service:
    description: Background worker
    module: worker-service
    runtime: python
