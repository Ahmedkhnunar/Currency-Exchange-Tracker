# Currency Exchange Tracker

## Overview

This project provides a currency exchange tracking application using AWS services. The application fetches daily exchange rate data from the European Central Bank and stores it in a DynamoDB table. It exposes a REST API to provide current exchange rate information and their changes compared to the previous day.

## Architecture

The application is built using the following AWS services:

- **AWS Lambda**: Executes serverless functions to fetch exchange rates and handle API requests.
- **AWS DynamoDB**: NoSQL database used to store daily exchange rate data.
- **AWS API Gateway**: Manages RESTful API endpoints for accessing exchange rates.
- **AWS CloudWatch**: Triggers Lambda functions to fetch exchange rates daily.
- **AWS S3**: Stores Lambda function code packages.
- **AWS CloudFormation**: Infrastructure as Code (IaC) tool for managing AWS resources.

## Setup Instructions

### Prerequisites

1. **AWS Account**: Ensure you have an AWS account with appropriate permissions.
2. **AWS Credentials**: Configure AWS CLI with your credentials using `aws configure`.
3. **Terraform**: Install Terraform from [terraform.io](https://www.terraform.io/downloads.html) for your operating system.

### Deployment Steps

1. **Clone the Repository**:

   ```bash
   git clone 
   cd currency-exchange-tracker/terraform

   terraform init
   terraform plan
   terraform apply
   terraform destroy

