# coding: utf-8
import os

DEBUG = bool(os.environ.get('DEBUG_MODE', False))
SECRET_KEY = os.environ.get('SECRET_KEY', 's3cr3t-k3y')

MONGODB_NAME = os.environ.get('MONGODB_NAME', 'flapp_mongo_db')
MONGODB_HOST = os.environ.get('MONGODB_HOST', 'localhost')
MONGODB_PORT = os.environ.get('MONGODB_PORT', 27017)

MONGODB_SETTINGS = {
    'db': MONGODB_NAME,
    'host': MONGODB_HOST,
    'port': int(MONGODB_PORT),
}
