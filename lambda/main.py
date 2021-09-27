from os import environ
import json

def main(event, context):
    response = {
        "message": f"Hello from Lambda! I do absolutely nothing!"
    }
    print(json.dumps(response))
    return response

def lambda_handler(event, context):
    try:
        response = main(event, context)
        return response
    except Exception as error:
        raise
