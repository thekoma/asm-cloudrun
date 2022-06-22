#!/usr/bin/env python3
import orjson, json
import os
import requests
from random import randrange as randrange
from typing import Union
from pydantic import BaseModel
from typing import Optional
from fastapi import FastAPI, status, Response
from fastapi.responses import PlainTextResponse, ORJSONResponse, HTMLResponse

app = FastAPI()

@app.get("/ping", response_class=PlainTextResponse, status_code=200)
async def ping():
    return "pong"

@app.get("/", response_class=PlainTextResponse, status_code=200)
async def home():
    return "Hello"
# "Hello please post a request in the format <url>/api/<module name>" with data '{ "value01": 100, "value02": 10} '!"

class ModuleOptions(BaseModel):
    function_name: Optional[str] = "sub"
    port: Optional[int] = 80
    proto: Optional[str] = "http"
    value01: float
    value02: float




def get_current_namespace():
    ns_path = "/var/run/secrets/kubernetes.io/serviceaccount/namespace"
    if os.path.exists(ns_path):
        with open(ns_path) as f:
            return f.read().strip()
    try:
        _, active_context = kubernetes.config.list_kube_config_contexts()
        return active_context["context"]["namespace"]
    except KeyError:
        return "default"

@app.post("/api/{module}")
async def post_module(module: str, params: ModuleOptions):
    function_name = dict(params)['function_name']
    port = dict(params)['port']
    proto = dict(params)['proto']
    if (os.environ.get('KUBERNETES_SERVICE_HOST') is not None) and (module.find(".") == -1):
        host=module + "." + get_current_namespace() + ".svc.cluster.local"
        print("Sono in k8s: " + host)
    else:
        host=module
        print("Non sono in k8s: " + host)

    url = proto + "://" + host + ":" + str(port) + "/api/module/" + function_name
    payload={}
    payload['value01']=dict(params)['value01']
    payload['value02']=dict(params)['value02']
    json_post = json.dumps(payload)
    print("URL:" + url)
    print("Payload:" + json_post)
    r = requests.post(url = url, data = json_post, timeout=1)
    print("Reply:")
    print(r.status_code)
    reply = {
        "return_code": r.status_code,
        "payload": payload,
        "url": url,
        "returned_data": r.json()
        }
    return reply