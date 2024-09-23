#!/bin/bash

cd ./lab_01
psql -d postgres -h localhost -p 5432 -U and -W -f ./drop.sql
cd ./deployment && sudo docker compose down postgres