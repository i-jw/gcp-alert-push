import requests
import json
import os
import base64
import time
wechat_webhook = os.environ.get("WECHAT", "Specified environment variable WECHAT is not set.")
dingtalk_webhook = os.environ.get("DINGTALK", "Specified environment variable DING is not set.")

def send_wechat_msg(alert_msg):
    values = {
        "msgtype":"text",
        "text":{
        "content": alert_msg
        }
    }
    headers={'Content-Type': 'application/json'}
    r = requests.post(wechat_webhook, json=values, headers=headers)
    r.encoding = 'utf-8'
    return (r.text)

def send_dingtalk_msg(alert_msg):
    values = {
        "msgtype":"text",
        "text":{
        "content": alert_msg
        }
    }
    headers={'Content-Type': 'application/json'}
    r=requests.post(dingtalk_webhook,data=json.dumps(values),headers=headers)
    r.encoding = 'utf-8'
    return (r.text)

def app(event, context):
    msg_decode = base64.b64decode(event['data']).decode('utf-8')
    msg = json.loads(msg_decode)
    # print("msg json is : ")
    # print(msg)
    status = msg['incident']['state']
    summary = msg['incident']['summary']
    started_at = time.ctime(msg['incident']['started_at'])
    ended_at = time.ctime(msg['incident']['ended_at'])
    project_id = msg['incident']['resource']['labels']['project_id']
    threshold_value = msg['incident']['threshold_value']
    observed_value = msg['incident']['observed_value']
    resource_display_name = msg['incident']['resource_display_name']
    policy_name = msg['incident']['policy_name']

    alert_msg = "Google Alarm Details:\n" + "Current State:" + status + "\n" \
    "started_at:" + started_at + "\n" \
    "ended_at:" + ended_at + "\n" \
    "Reason for State Change:" + summary + "\n" \
    "alert_policy:" + policy_name + "\n" \
    "threshold:" + threshold_value + "\n" \
    "observed_value:" + observed_value + "\n" \
    "resource_display_name:" + resource_display_name
    print(resource_display_name)
    # print(alert_msg)
    if wechat_webhook != "":
        res = send_wechat_msg(alert_msg)
        print(res)
    if dingtalk_webhook != "":
        res = send_dingtalk_msg(alert_msg)
        print(res)