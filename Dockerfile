### Docker image of ud3tn and python AAP tools

# Start from ubuntu image
FROM ubuntu:latest
# Update and upgrade to the latest versions
RUN apt-get update && apt-get upgrade -y
# Install build essentials
RUN apt-get install build-essential -y
# Install python
RUN apt-get install python3 python3-pip -y

# Expose the two ports
# (This can be changed to any port you want doing -p <port>:<port>)
# (That way you can run multiple instances of ud3tn with different ports)

# Port 8000 is used for the --aap-port param
EXPOSE 8000
# Port 8001 is used for the --cla param
EXPOSE 8001


# Add ud3tn code to image
ADD ./ud3tn ./ud3tn
# Run "make posix" on ud3tn's Makefile
RUN make -C ./ud3tn posix
# Install python dependencies
RUN python3 -m pip install ud3tn-utils pyd3tn

# Test command to check if the makefile worked
RUN ls -a
RUN ls -a ./ud3tn/build/posix
# CMD ["ls", "-a"]
