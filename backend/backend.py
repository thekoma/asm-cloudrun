#!/usr/bin/env python3
"""This stupid webapp catches the latest morning post from ilpost.it ."""
import orjson, json
import os
import redis
import requests
from fastapi import FastAPI, status, Response
from fastapi.responses import PlainTextResponse, ORJSONResponse, HTMLResponse

app = FastAPI()