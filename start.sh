#!/bin/bash

cd ./lab_01/deployment && sudo docker compose up postgres -d && cd ..
psql -d postgres -h localhost -p 5432 -U and -W -f ./init.sql
psql -d postgres -h localhost -p 5432 -U and -W -f ./alter.sql
psql -d postgres -h localhost -p 5432 -U and -W -f ./copy.sql