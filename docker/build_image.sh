#!/bin/bash

docker build -f Dockerfile -t baseapp .

docker-compose -f docker-compose.yml up -d
