def lambda_handler(event, context):
    """
    AWS Lambda function that returns a simple "Hello, World!" message.
    """
    return {
        'statusCode': 200,
        'body': 'Hello, World!'
    }
