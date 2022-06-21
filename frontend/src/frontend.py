#!/usr/bin/env python3
import orjson, json
import os
import requests
from random import randrange as randrange
from typing import Union
from pydantic import BaseModel
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
    function_name: str
    value01: float
    value02: float


@app.post("/api/{module}")
async def post_module(module: str, params: ModuleOptions):
    url = "{module}/api/{module}"
    r = requests.get(url = url, params = params)
    return r