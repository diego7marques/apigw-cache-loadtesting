import time
import random

def lambda_handler(event, context):
    # Generate a random delay between 300ms (0.3s) and 600ms (0.6s)
    delay = random.uniform(0.3, 0.6)
    
    # Add the delay
    time.sleep(delay)
    
    # Return a success message
    return {
        'statusCode': 200,
        'body': 'Success',
    }