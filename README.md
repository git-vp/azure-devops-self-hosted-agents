# azure-devops-self-hosted-agents

Jobs in a DevOps pipeline are executed by a DevOps Agent. This DevOps agent can be:
* Microsoft Agents - where Microsoft takes care of providing the VM and software to execute the job
* Self Hosted Agent - where the individual takes the responsibility of installed the agent on a host of their choice

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
