# daisy-model_dockerized

To run daisy with docker successfully you have to mount your data directories inside the container. To achieve this, add ```-v local/path:container/path``` to the docker run command.


If data and .dai file is located in the same directory you can simply mount that diretory to the same path in the container and set is as working directory:

```
docker run -it --rm -v `pwd`:`pwd` -w `pwd` daisy_atb:latest test.dai
```
