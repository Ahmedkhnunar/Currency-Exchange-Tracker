import json
import boto3
import os
from datetime import datetime, timedelta

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['TABLE_NAME']
table = dynamodb.Table(table_name)

def get_exchange_rates(date):
    response = table.get_item(Key={'Date': date})
    return response.get('Item', {}).get('Rates', {})

def calculate_changes(current_rates, previous_rates):
    changes = {}
    for currency, rate in current_rates.items():
        if currency in previous_rates:
            changes[currency] = rate - previous_rates[currency]
        else:
            changes[currency] = None
    return changes

def lambda_handler(event, context):
    today = datetime.utcnow().strftime('%Y-%m-%d')
    yesterday = (datetime.utcnow() - timedelta(1)).strftime('%Y-%m-%d')
    
    current_rates = get_exchange_rates(today)
    previous_rates = get_exchange_rates(yesterday)
    
    changes = calculate_changes(current_rates, previous_rates)
    
    return {
        'statusCode': 200,
        'body': {
            'current_rates': current_rates,
            'changes': changes
        }
    }
