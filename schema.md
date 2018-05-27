# root

`homebus/1` is the root of the topic tree for HomeBus devices.

Devices are welcome to publish to more than one topic.

# $homebus

`homebus/1/homebus` is the root of the HomeBus-related topics.

## provisioned

An item is published every time a device is provisioned.

```
{
  "uuid": "",


## device

```
{
  "uuid": "",
  "manufacturer": "",
  "model": "",
  "serial_number": ""
}
```

## boot
```
{
  "uuid": "",
  "timestamp": "",
  "reason": ""
  }
```  

## light
{
  "uuid": "", 
  "timestamp": seconds_since_epoch, 
  "on": true/false,
  "dim_level": integer,
  "color": 0xrgb
}
```

## occupancy


## environmental
{
  "uuid": "", 
  "timestamp": seconds_since_epoch, 
  "temp_c": float,
  "humidity":
  "pressure":
  "co":
  "co2":
  "methane":
  "lux":
}

## air quality
{
  "uuid": "", 
  "timestamp": seconds_since_epoch, 
  "co": "",
  "co2": "",
  "methane": "",
  "
}

## router
{
  "uuid": "",
  
}
