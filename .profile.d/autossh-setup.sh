# .profile.d/ssh-setup.sh

mkdir -p ${HOME}/.ssh
chmod 700 ${HOME}/.ssh

# Copy public key env variable into a file
echo "${AUTOSSH_PUBLIC_KEY}" > ${HOME}/.ssh/id_rsa.pub
chmod 644 ${HOME}/.ssh/id_rsa.pub

# Copy private key env variable into a file
echo "${AUTOSSH_PRIVATE_KEY}" > ${HOME}/.ssh/id_rsa
chmod 600 ${HOME}/.ssh/id_rsa

# Auto add the host to known_hosts
# This is to avoid the authenticity of host question that otherwise will halt autossh from setting up the tunnel.
#
# Ex:
# The authenticity of host '[hostname] ([IP address])' can't be established.
# RSA key fingerprint is [fingerprint].
# Are you sure you want to continue connecting (yes/no)?

ssh-keyscan ${AUTOSSH_HOST} >> ${HOME}/.ssh/known_hosts

# Setup SSH Tunnel
# This is an example of forwarding local port 3306 to the remote servers port 3306 (usually mysql)
#
# autossh will use port 33306 as a monitoring port. If the connection dies autossh will automatically set up a new one.
# ServerAliveInterval: Number of seconds between sending a packet to the server (to keep the connection alive).
# ClientAliveCountMax: Number of above ServerAlive packets before closing the connection. Autossh will create a new connection when this happens.

autossh -M 33306 -f -N -o "ServerAliveInterval 10" -o "ServerAliveCountMax 3"  -L 6000:localhost:5432 ${AUTOSSH_USER}@${AUTOSSH_HOST}
