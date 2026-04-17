#!/system/bin/sh

set -o errexit -o pipefail -o nounset

# This script sets up iptable rules for processes related to AHE.

csm_uid="$(getprop alexa.hybrid.client.uid)"
csm_port="$(getprop alexa.hybrid.client.port)"

skill_uid="$(getprop alexa.hybrid.skillcontainer.uid)"
skill_port="$(getprop alexa.hybrid.skillcontainer.server_port)"
skill_ingestion_port="$(getprop alexa.hybrid.skillcontainer.ingestion_port)"

davs_uid="$(getprop alexa.hybrid.davscap.uid)"
davs_port="$(getprop alexa.hybrid.davscap.port)"

# Create new chain ahe_out
iptables -N ahe_out
# Filter OUTPUT through ahe_out
iptables -I OUTPUT 1 -j ahe_out
# Remove any existing rules on the ahe_out chain
iptables --flush ahe_out

# Setup rule for CSM which connects to AHE (ExecutionController)
iptables -A ahe_out -p tcp --dport "$csm_port" -m owner --uid-owner "$csm_uid" -j ACCEPT

# Setup rule for the davs capability agent which connects to AHE (ArtifactManager)
iptables -A ahe_out -p tcp --dport "$davs_port" -m owner --uid-owner "$davs_uid" -j ACCEPT

# Setup rule for skill container to ingest content into ArtifactManager for local model building
iptables -A ahe_out -p tcp --dport "$skill_ingestion_port" -m owner --uid-owner "$skill_uid" -j ACCEPT

# Following makes sure the FIN packets go through in case the process exits before the FIN packet is sent
iptables -A ahe_out -p tcp --dport "$davs_port" -m state --state ESTABLISHED -j ACCEPT
iptables -A ahe_out -p tcp --dport "$csm_port" -m state --state ESTABLISHED -j ACCEPT
iptables -A ahe_out -p tcp --dport "$skill_ingestion_port" -m state --state ESTABLISHED -j ACCEPT

# Setup rules for skillcontainer which creates a server that AHE (SkillGateway) connects to
iptables -A ahe_out -p tcp --sport "$skill_port" -m owner --uid-owner "$skill_uid" -j ACCEPT
