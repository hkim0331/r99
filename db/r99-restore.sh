#!/bin/sh
psql -h localhost -U ${R99_USER} -W ${R99_DB} < $1
