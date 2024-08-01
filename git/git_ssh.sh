#!/bin/bash

# >>> ssh-agent initialize >>>
SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    source ${SSH_ENV}
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
    source ${SSH_ENV}
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
# <<< ssh-agent initialize <<<

# ssh-add -D
ssh-add ~/.ssh/git_personal
ssh -T git@github.com
