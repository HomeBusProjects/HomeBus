# Homebus Protocols

Homebus provides a "pubsub" networking abstraction in which clients can publish and subscribe to specific data types.

Clients are identified by a UUID which will be unique in their networks.

Data is identified by a "DDC" - Discrete Data Collection - which is a namedspaced object that potentially in a standardized format that carries information over Homebus. For instance, "org.homebus.experimental.air-sensor" may carry air temperature, humidity and pressure values.

A Homebus client may request to publish or receive specific DDCs. The Homebus network administrator decides whether or not to grant access based on the request.

A Homebus client may also request to transmit a DDC to another Homebus client.




## Homebus Provisioning Protocol

This information is current as of 26 September 2020. The Homebus protocol is still in flux. You should not build anything using this.

A Homebus client sends a provisioning request to a Homebus server over HTTP(S).

Ideally the Homebus client is ideally initially configured by an app which shares with it wifi credentials, the Homebus server's name or IP address and a short-lived authentication token. This information may also be simply compiled into the client's code, though the authentication token will generally only have a 24 hour or less lifespan.

A request asks for permission for one or more devices to join a Homebus network and identifies the types of data that the devices will publish (write), subscribe to (read) or do both with. The authentication token identifies the network. The request specifies the number of devices, which all share the same permissions.

A request may also specify the capabilities of a client. Some clients may be able to use more advanced authentications strategies like client side certificates. Some may not even be able to use certificate-based security to transport data.

A response includes credentials for connecting to the Homebus network, an array of UUIDs for devices, and a long-lived refresh token that the device can use to refresh its credentials or ask for new permissions.

request:
```
{
 identity: {
    manufacturer: "",
    model: "",
    serial_number: string, 
    pin: string
	},
  capabilities: {
    can_identify: boolean,
    has_screen: boolean,
	can_client_certificate: boolean,
	can_broker_certificate: boolean,
	can_sign: boolean,
    can_verify: boolean
  },
  ddcs: {
    ro_ddcs: [ string ],
    wo_ddcs: [ string ],
    rw_ddcs: [ string ]
	},
  number_of_uuids: integer
}

->

response:

{
  status: 
  security: {
    username: string,
    password: string,
	broker: string,
	port: integer,
    client_certificate: string,
	broker_certificate: string
  },
  uuids: [ uuid, ... ],
  refresh_token: string
}


## Homebus Network

Homebus currently uses MQTT as a transport layer. However, Homebus applications should not assume they're running on top of MQTT. Homebus manages MQTT topic names in an opaque manner to the application.

Homebus publishes DDCs in an envelope:

{
	source: uuid,
	timestamp: unsigned integer,
	contents: {
	    ddc:  string,
	    payload: object
		},
    security: {
	}
}
