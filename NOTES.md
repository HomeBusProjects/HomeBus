# provisioner

unprovisioned device contacts provisioner REST API, sends:
- mac address
- type of activity
- serial number
- manufacturer
- firmware name
- firmware version


gets:
- UUID
- mqtt credentials



UPD - unprovisioned device

PS - provisioning server


UPD
- look for HomeBus.local on mDNS
- send request to HomeBus.local/provision?mac_address=XX:XX:XX:XX:XX:XX&serial_number=&manufacturer=&firmware=&firmware_version=&type=

PS
- get request at /provision
- process
- send response uuid: "", mqtt_username:, mqtt_password, mqtt_host, mqtt_port, mqtt_ssl
