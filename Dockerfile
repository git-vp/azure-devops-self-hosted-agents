FROM ubuntu:22.04

RUN apt update
RUN apt upgrade -y
RUN apt install -y curl git jq libicu70 nodejs zip unzip
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN chmod +x get-docker.sh
RUN sh get-docker.sh

# Also can be "linux-arm", "linux-arm64".
ENV TARGETARCH="linux-x64"

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

RUN useradd agent
RUN chown agent ./
# USER agent
# Another option is to run the agent as root.
ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT ./start.sh
