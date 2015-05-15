#!/bin/bash

# This script is used by Nagios to post alerts into a Slack channel
# using the Incoming WebHooks integration. Create the channel, botname
# and integration first and then add this notification script in your
# Nagios configuration.
#
# Slack configuration options are taken from the contact.
# define contact {
#    _slack_username  your.slack.username
#    _slack_hooks_url https://hooks.slack.com/services/blah/boog/bliggy
#    _slack_channel   #ops
# }
#
# The contents of the message is read from the first argument.
#
# All variables that start with NAGIOS_ are provided by Nagios as
# environment variables when an notification is generated.
# A list of the env variables is available here:
#   http://nagios.sourceforge.net/docs/3_0/macrolist.html
#
# More info on Slack
# Website: https://slack.com/
# Twitter: @slackhq, @slackapi
#
# Source: https://github.com/apowers/nagios-tools
# License: MIT

MESSAGE=$1

#Set the message icon based on Nagios service/host state
if [ "$NAGIOS_SERVICESTATE" = "CRITICAL" -o "$NAGIOS_HOSTSTATE" = "DOWN" ]; then
    ICON=":exclamation:"
elif [ "$NAGIOS_SERVICESTATE" = "OK" -o "$NAGIOS_HOSTSTATE" = "UP" ]; then
    ICON=":white_check_mark:"
else
    ICON=":warning:"
fi

#Send message to Slack
curl -X POST --data-urlencode "payload={\"channel\": \"${NAGIOS__CONTACTSLACK_CHANNEL}\", \"username\": \"${NAGIOS__CONTACTSLACK_USERNAME}\", \"icon_emoji\": \":pager:\", \"text\": \"${ICON} ${MESSAGE}\"}" $NAGIOS__CONTACTSLACK_HOOKS_URL
