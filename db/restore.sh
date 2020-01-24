#!/bin/sh
psql -h localhost -U user1 -W r99 < $1
