# azure-devops-self-hosted-agents

Jobs and tasks in a DevOps pipeline are executed by a DevOps Agent. This DevOps agent can be:
* Microsoft Agents - where Microsoft takes care of providing the VM and software to execute the job
* Self Hosted Agent - where the individual takes the responsibility of installing the agent on a host of their choice

## Self Hosted Agent
DevOps agent software can be installed on a variety of hosts.
## Self Hosted Agent on Windows
* Go to `dev.azure.com/{DevOps-Org-Name}`
* Click on `Organisation Settings -> Agent Pools (under Pipelines section) -> Click on Default Agent Pool -> New Agent -> Download`
  * Copy downloaded agent (for example: `vsts-agent-win-x64-3.232.0.zip`) to a folder
  * Extract the contents of zip file
* DevOps Agents can be authenticated using either:
  * [PAT Tokens](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/personal-access-token-agent-registration?view=azure-devops)
  * [Service Principle](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/service-principal-agent-registration?view=azure-devops)
* To configure the agent run `config.cmd`. Configuring the agents takes place in 2 stages. 
  * In the first stage, it will prompt the following.
    * `Enter Server URL`: `https:\\dev.azure.com\{DevOps-Org-Name}`
    * `Enter authentication type (press enter for PAT)`: `Press <ENTER>`
    * `Enter personal access token`:
  * The above details are used by the agent to connect to DevOps server
  * In the 2nd stage, it will prompt the following:
    * `Enter agent pool (press Enter for Default)`
    * `Enter agent name`
  * With the above details it will add the agent to the Agent pool
  * It will prompt for few other details like working directory, run agent as a service etc
* For further details refer to [Self Hosted Windows Agent](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/windows-agent?view=azure-devops#download-and-configure-the-agent)

## Self Hosted Agent in Docker
* Go to `dev.azure.com/{DevOps-Org-Name}`
* Click on `Organisation Settings -> Agent Pools (under Pipelines section) -> Click on Add Pool`
* Select Pool Type as Self Hosted, and assign a Pool name, for example `TestPool`
* Follow the instructions in [Self Hosted Agent in Docker for Linux](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops) to create:
  * `Dockerfile` for Ubuntu 22.04
  * `start.sh`
     `Note`: this file should have linux line endings (i.e. `\n`)
     In VS Code, `File -> Preferences -> Settings`, search for `line end`. This will show the setting for `Files: Eol`. By default it is set to `auto`. Change it to: `\n`
 
* For example, see the below `Dockerfile`
  ```docker
  
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
  ```
* Ensure Docker Desktop is running
* Build Docker image:
  
  `docker build --tag "azp-agent:linux" .`
  
* Run Docker image:

  `docker run -e AZP_URL="<Azure DevOps instance>" -e AZP_TOKEN="<Personal Access Token>" -e AZP_POOL="<Agent Pool Name>" -e AZP_AGENT_NAME="Docker Agent - Linux" -v /var/run/docker.sock:/var/run/docker.sock --name "azp-agent-linux" azp-agent:linux`

  where:
  * AZP_URL = `https://dev.azure.com/{DevOps-Org-Name}/`
  * AZP_TOKEN = Follow instructions in [PAT Token](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows#create-personal-access-tokens-to-authenticate-access) to create a PAT token
  * AZP_AGENT_NAME = Name of an agent within a pool. This name can be anything. For example, I called it `AdoDockerSelfHostedAgent`
  * AZP_POOL = Name of the Agent pool. If this is not specified it uses `default` pool
  * -v /var/run/docker.sock - is to allow to run Docker within the DevOps Agent docker container
 
 * For example:
   
   `docker run -e AZP_URL=https://dev.azure.com/Architecture -e AZP_TOKEN={pat-token-value} -e AZP_POOL=TestPool -e AZP_AGENT_NAME=AdoDockerSelfHostedAgent -v /var/run/docker.sock:/var/run/docker.sock --name "azp-agent-linux" azp-agent:linux`

* Once the agent is run it should display something like:

  ![image](https://github.com/git-vp/azure-devops-self-hosted-agents/assets/25417872/e9f968e5-d255-43c5-90e0-e1751b4fe3ac)

* You can also verify the running self hosted agent in the agent pool here:

  ![image](https://github.com/git-vp/azure-devops-self-hosted-agents/assets/25417872/0a9ee2b3-68f9-4e50-8202-8f5604b7ed84)




  

