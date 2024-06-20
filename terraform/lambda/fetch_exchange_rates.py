import json
import boto3
import os
import requests
from datetime import datetime
import xml.etree.ElementTree as ET

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['TABLE_NAME']
table = dynamodb.Table(table_name)


def fetch_exchange_rates():
    """Fetches exchange rates from ECB daily XML."""
    url = 'https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml'
    response = requests.get(url)
    response.raise_for_status()  # Raise an exception for unsuccessful requests
    return response.content


def parse_exchange_rates(xml_data):
    """Parses XML data and extracts exchange rates."""
    root = ET.fromstring(xml_data)

    # Define namespaces for easier access
    namespaces = {'gesmes': 'http://www.gesmes.org/xml/2002-08-01', 'ecb': 'http://www.ecb.int/vocabulary/2002-08-01/eurofxref'}

    # Find the Cube element with the most recent date
    cube_time_element = root.find('.//ecb:Cube[@time]', namespaces)
    
    # Check if Cube time element exists
    if cube_time_element is None:
        print("No Cube time element found.")
        return {}

    rates = {}
    for cube in cube_time_element.findall('ecb:Cube', namespaces):
        currency = cube.attrib['currency']
        rate = float(cube.attrib['rate'])
        rates[currency] = rate
    
    # Store the rates in DynamoDB
    if rates:
        today = datetime.utcnow().strftime('%Y-%m-%d')
        table.put_item(
            Item={
                'Date': today,
                'Rates': {k: str(v) for k, v in rates.items()}
            }
        )
    return rates


def lambda_handler(event, context):
    """Lambda function to fetch and return exchange rates."""
    try:
        xml_data = fetch_exchange_rates()
        rates = parse_exchange_rates(xml_data)
        return {
            'statusCode': 200,
            'body': {'message': 'Exchange rates fetched successfully', 'rates': rates}
        }
    except requests.exceptions.RequestException as e:
        return {
            'statusCode': 500,
            'body': {'message': f"Error fetching exchange rates: {e}"}
        }
