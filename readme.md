# DTN Emulator

## How to clone

This repo has git submodules dependencies, so in order to properly work, you need to clone it by doing:

```
git clone --recurse-submodules -j8 git@github.com:octaviotastico/dtn-emulator.git
```

If you already cloned the repo without using the recurse submodules flag, or you have an older version of Git, you can use:

```
git submodule update --init --recursive
```

---

## How to use the Dockerfile

### > Create a Docker Image and then the Docker Containers.

#### **To create an Docker image with the Dockerfile**
```
docker build --pull --rm -f "Dockerfile" -t ud3tn "."
```

#### **To run the image (i.e create containers) in interactive mode**
```
docker run --rm -it -p <AAP PORT Number>:8000 -p <CLA PORT Number>:8001 ud3tn:latest
```
For example:
```
docker run --rm -it -p 4242:8000 -p 4224:8001 ud3tn:latest
docker run --rm -it -p 4243:8000 -p 4225:8001 ud3tn:latest
docker run --rm -it -p 5555:8000 -p 6666:8001 ud3tn:latest
etc...
```

#### **To check if the containers are running**
```
docker ps -a
```

#### **To attach a terminal to the container**
```
docker exec -it <container id> bash
```

### > Connect the containers to the same network

To do this, you can either use [host networking](https://docs.docker.com/network/host/) (basically removing network isolation), or to create a [Docker network](https://docs.docker.com/network/bridge/) (a bridge).

The easiest way is to use your own network (host networking).

#### **Use host networking**

```
docker run --rm -it --network host ud3tn:latest
```

And that's all for host networking.

If you want to isolate the Docker container, you can still use bridge networking.

#### **Check which networks are available**
```
docker network list
```

#### **Create a new network**
```
docker network create DTN-test-network
```

#### **Connect the containers to the network**
If container was already created, you can connect it later by doing:
```
docker network connect DTN-test-network <container id>
```

#### **Run the containers with the network**
If container was not already created, you can create it connected to the new docker network by doing:
```
docker run --rm -it --net DTN-test-network -p 4242:8000 -p 4224:8001 ud3tn:latest
```

All you have to do is to add the `--net DTN-test-network` flag.

#### **To inspect the container**
And check its IP Address, ports, and which network is it connected to:
```
docker inspect <container name>
```


### > Run the μD3TN nodes (Inside the containers)

If we were to create a DTN with two nodes, Node A and Node B, we could launch two different containers and do something like this:

#### **Node A)**
```
ud3tn/build/posix/ud3tn --eid dtn://a.dtn/ --bp-version 7 --aap-port 4242 --cla "mtcp:*,4224"
```

#### **Node B)**
```
ud3tn/build/posix/ud3tn --eid dtn://b.dtn/ --bp-version 7 --aap-port 4243 --cla "mtcp:*,4225"
```

### > Run python AAP tools to configure the nodes

#### **Node A)**
```
python3 ud3tn/tools/aap/aap_config.py --tcp localhost 4242 --dest_eid dtn://a.dtn/ --schedule 1 3600 100000 dtn://b.dtn/ mtcp:localhost:4225
```

#### **Node B)**
```
python3 ud3tn/tools/aap/aap_config.py --tcp localhost 4243 --dest_eid dtn://b.dtn/ --schedule 1 3600 100000 dtn://a.dtn/ mtcp:localhost:4224
```

### > Try sending a bundle
#### **Node A)**
```
python3 ud3tn/tools/aap/aap_send.py --tcp localhost 4242 dtn://b.dtn/bundlesink 'Hello, from node A!'
```

#### **Node B)**
```
python3 ud3tn/tools/aap/aap_send.py --tcp localhost 4243 dtn://a.dtn/bundlesink 'Hello, from node B!'
```
