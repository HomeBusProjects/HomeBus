# HomeBus Is

[![Test](https://github.com/HomeBusProjects/HomeBus/actions/workflows/test.yml/badge.svg)](https://github.com/HomeBusProjects/HomeBus/actions/workflows/test.yml)

HomeBus is a prototype system that provides a uniform interface for publishing, accessing and sharing data collected by
sensors located around a home, business or region. HomeBus is a provisioning system that allows devices to find and publish data to brokers, and allows brokers to connect to external services.

HomeBus allows you to control your data and grant access to your devices to other devices and services. 

HomeBus is *not* ready for prime time. This is an experimental prototype; we have a lot to learn from the system and it needs to mature substantially  before suggesting that anyone else use it.

## Installation

### Docker

#### Import a `pg_dump` backup into Docker

```
docker-compose exec -T postgres  pg_restore --verbose --clean --no-acl --no-owner -d homebus_development -U postgres  < latest.dump
```

### Raspberry Pi

Some day we will offer pre-built Raspbian images that you can just flash to an SD card. Today is not that day.

1. Flash a copy of Rasbian Stretch Lite to a microSD card. If you want to access your Raspberry Pi without attacing a keyboard and monitor, mount the microSD card on your computer. You'll see a `/boot` DOS partition.

In `/boot` create an empty file called `ssh`. This will automatically configure the Pi to start its SSH server on boot.

In `/boot`

```
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
	ssid="YOUR WIFI SSID"
	scan_ssid=1
	psk="YOUR WIFI PASSWORD"
	key_mgmt=WPA-PSK
	}
```


2. Establish your SSH key on the pi. Let's assume the pi is called `homebus`:

```ssh-copy-id homebus```

3. Install Python on the pi. This is a good time to install your favorite editor or utilities as well.

```
ssh homebus sudo apt-get update \; sudo apt-get install python-all python-all-dev python-psycopg2 python3-psycopg2
```

4. Update Ansible's inventory file to list your Pi

5. Run Ansible to build the HomeBus operating environment on your Pi. This will likely take 30 to 45 minutes or more, depending on the speed of your Pi, microSD card and Internet connection. Ansible will generate lots of output, alhtough the `zzet.rbenv` section will be very slow with no output in places. Be patient.

```
ansible-playbook -i inventory/pi playbooks/pibook.yml
```

# Provisioning

Homebus offers automatic provisioning to devices. A device may be a trunk or a leaf. Trunks connect leaves. Leaves are individual sensors.

Each provisioned device is assigned a UUID. Each sensor on the device is also assigned a UUID. All sensors on a device will share a single MQTT account.

Sensors may indicate precision, accuracy, and frequency of updates.

Each item with a UUID is assigned its own topic: `homebus/devices/UUID` to which it may publish JSON updates.

For instance, an ESP8266 with temperature, humidity, barometric pressure and light sensors would be a trunk with four leaves. Each leaf as a UUID. 


# Heroku

## autossh

Requires a persistent ssh connection through which it can tunnel PostgreSQL to the MQTT brokers.

https://elements.heroku.com/buildpacks/quinde/heroku-buildpack-ssh-tunnel


```
heroku create --buildpack https://github.com/quinde/heroku-buildpack-ssh-tunnel.git
heroku config:set SSH_PUBLIC_KEY="`cat path/to/public/key`"
heroku config:set SSH_PRIVATE_KEY="`cat path/to/private/key`"
heroku config:set SSH_TUNNELS="user@ssh-server:ssh-port|127.0.0.1:local-port:target-host:remote-port"
```

