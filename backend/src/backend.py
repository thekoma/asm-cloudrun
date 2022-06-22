#!/usr/bin/env python3
import orjson, json
import os
import requests
from random import randrange as randrange
from typing import Union
from pydantic import BaseModel
from fastapi import FastAPI, status, Response
from fastapi.responses import PlainTextResponse, ORJSONResponse, HTMLResponse


MODULE = os.getenv("MODULE_NAME", "unset")

app = FastAPI()

@app.get("/ping", response_class=PlainTextResponse, status_code=200)
async def ping():
    return "pong"

@app.get("/", response_class=PlainTextResponse, status_code=200)
async def home():
    return "Hello!"

@app.get("/api/" + MODULE, response_class=ORJSONResponse, status_code=200)
async def module_get():
    payload = ModuleOptions()
    return { "module": MODULE, "payload": payload }

class ModuleOptions(BaseModel):
    # function_name: str
    value01: Union[float, None] = None
    value02: Union[float, None] = None
    success: Union[bool, None] = False

@app.post("/api/module/{function}")
async def post_module(function: str, moduleopts: ModuleOptions):
    options = dict(moduleopts)
    options['module_name'] = MODULE
    options['function'] = function
    value01 = options['value01']
    value02 = options['value02']
    match function:
        case 'mult':
            options['result'] = value01*value02
            options['success'] = True
        case 'sub':
            options['result'] = value01-value02
            options['success'] = True
        case 'sum':
            options['result'] = value01+value02
            options['success'] = True
        case _:
            options['result'] = "unknown function"
            options['success'] = False
    return options