from __future__ import unicode_literals
from botocore.exceptions import ClientError

import boto3
import json

def start(instance):
    return instance.start()

def stop(instance):
    return instance.stop()

actions = [start, stop]

def get_instances(option, schedule):

    client = boto3.client('ec2')
    result = client.describe_instances(Filters=[
        {
            'Name': 'tag:janitor-%s' % option,
            'Values': [schedule]
        }
    ])

    instances = [
                    j[0] for j in [
                        [i['InstanceId'] for i in r['Instances']]
                        for r in result.get('Reservations', [])
                    ]
                ]

    ec2 = boto3.resource('ec2')
    return [ec2.Instance(instance) for instance in instances]

def handler(event, context):
    schedule = event['scheduleEvent']
    for action in actions:
        for instance in get_instances(action.__name__, schedule):
           action(instance)
