#!/bin/sh


docker build . -t daisy_atb:latest


# run once to test
docker run -it --rm daisy_atb:latest test.dai
