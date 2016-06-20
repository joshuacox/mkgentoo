# mkgentoo
Make Gentoo docker container PDQ

`make auto` and you should have a bash shell inside a working gentoo container, read on for more info

### Requirements
docker 1.11 
make (GNU Make 4.1)  
~may work with earlier versions of either YMMV

### usage

edit the following line in the`Dockerfile` to emerge the packages you like

```
ENV PACKAGES vim colordiff
```

then  build your container with:

```
make build
```

if your merges are successful then you can
run the container with

```
make run
```

then enter the running container

```
 make enter
```

or look at the logs:

```
make logs
```

remove the running image or cleanup old cid files:

```
 make rm
```
