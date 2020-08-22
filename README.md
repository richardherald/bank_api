
# Bank API ![actions](https://github.com/richardherald/bank_api/workflows/actions/badge.svg)

## Introduction

The Api is divided into the contexts below:

## Users

- Sign up new users
> This feature creates a user and their account. When creating the account the user receives 100000 cents (hundred thousand cents). The API works with the monetary value in cents
- Sign in users.
> This feature requires the user's credentials (email and password) to be sent and, if the credentials are valid, a token will be sent in the response to be used for other protected resources
- Get data user logged
> This feature recover the the logged in user data

## Operations

- Transfer
> This feature transfers money from the logged-in user's account to another account. The logged in user must has the amount of money available in his account to cover the transfer fee.
- Withdraw
> This feature allows the logged in user to withdraw money from their account. The logged in user must have enough balance in his account to cover the withdrawal amount. After withdrawal an email will be sent with the proof of withdrawal.

## Transactions

- List of transactions
> Lists the history of the user's withdrawal or transfer transactions

## Admins

- Sign up new Admin
> This feature creates an administrator. they have access to the transaction report
- Sign in Admin
> This feature requires that the administrator's credentials (email and password) are sent and, if the credentials are valid, a token will be sent in the response to be used to access other protected resources
- report
> This feature returns the sum of all transactions for a period

## Setup

There is a Makefile that call some docker commands to start the application and test it.

To start the application:
> make up

To start application in iterative mode:
> make up-iterative

To run application tests the application:
> make test

To stop the containers:
> make down

## Deployment

The api use the github actions for CI/CD and is hosted at https://gigalixir.com/ on a free plan.
The public endpoint is: https://bankstone.gigalixirapp.com/api/v1

An api example of utilization is provided here:

[![Run in Postman](https://run.pstmn.io/button.svg)](https://www.getpostman.com/collections/2323d1dbb11b538771e1)\
File environment developer: https://github.com/richardherald/bank_api/blob/master/postman/development.postman_environment.json\
File environment production: https://github.com/richardherald/bank_api/blob/master/postman/production.postman_environment.json

The postman files above provide a development and production environment, if you want to use the local environment, just use the "development" environment variable or use the "production" environment variable to consume the public endpoint that is hosted on the gigalixir. If you have difficulty importing files into postman: https://learning.postman.com/docs/getting-started/importing-and-exporting-data/
