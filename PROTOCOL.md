# Homebus Protocols

Homebus provides a network abstration designed to simplify sharing of data between IoT devices. Just as IP provides an abstract internetwork that runs above network hardware while hiding the details of the network hardware's implementation, and TCP provides a reliable stream networking abstraction, Homebus focusses on an abstract network where blocks of data can be shared between devices using a standardized format.

Homebus consists of three protocols: a provisioning protocol, a layer that runs Homebus over MQTT and a 

The first is a provisioning protocol. A client that wishes to join a Homebus network requests access via the provisioning protocol via a provisioning server. It is preconfigured with a security token and contact information for the server.

Homebus provides a "pubsub" networking abstraction in which clients can publish and subscribe to specific data types.

Clients are identified by a UUID which will be unique in their networks.

Data is identified by a "DDC" - Discrete Data Collection - which is a namedspaced object that potentially in a standardized format that carries information over Homebus. For instance, "org.homebus.experimental.air-sensor" may carry air temperature, humidity and pressure values.

A Homebus client may request to publish or receive specific DDCs. The Homebus network administrator decides whether or not to grant access based on the request.

A Homebus client may also request to transmit a DDC to another Homebus client.

**Homebus protocols are under development. They may change substantially from their current implementation and from this specification.**

## Tokens

Homebus provisioning requests are authenticated and authorized using security tokens provided by the Homebus provisioning server. The tokens are opaque and, although they are not OAuth tokens, they shall be used in a manner consistent with [RFC 6750 - The OAuth 2.0 Authorization Framework: Bearer Token Usage](https://datatracker.ietf.org/doc/html/rfc6750).



## Homebus Provisioning Protocol

This information is current as of 26 September 2020. The Homebus protocol is still in flux. You should not build anything using this. It is certain to change.

A Homebus client sends a provisioning request to a Homebus server over HTTP(S).

Ideally the Homebus client is ideally initially configured by an app which shares with it wifi credentials, the Homebus server's name or IP address and a short-lived authentication token. This information may also be simply compiled into the client's code, though the authentication token will generally only have a 24 hour or less lifespan.

A request asks for permission for one or more devices to join a Homebus network and identifies the types of data that the devices will publish (write), subscribe to (read) or do both with. The authentication token identifies the network. The request specifies the number of devices, which all share the same permissions.

A request may also specify the capabilities of a client. Some clients may be able to use more advanced authentications strategies like client side certificates. Some may not even be able to use certificate-based security to transport data.

A response includes credentials for connecting to the Homebus network, an array of UUIDs for devices, and a long-lived refresh token that the device can use to refresh its credentials or ask for new permissions.

request:
```
{
  name: '',
  ddcs: {
    consume_ddcs: [ string ],
    publish_ddcs: [ string ],
  },
  devices: [
    {
      identity: {
      manufacturer: "",
      model: "",
      serial_number: string, 
      pin: string
      }
  ]
}
```
->

response:
```
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
  devices: [
  {
  }
  ]
}
```

## Homebus Network

Homebus currently uses MQTT as a transport layer. However, Homebus applications should not assume they're running on top of MQTT. Homebus manages MQTT topic names in an opaque manner to the application.

Homebus publishes DDCs in an envelope:
```
{
	source: uuid,
	timestamp: unsigned integer,
	sequence: unsigned integer,
	contents: {
	    ddc:  string,
	    payload: object
		},
    security: {
	}
}
```

