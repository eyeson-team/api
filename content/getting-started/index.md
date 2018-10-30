---
title: "How to get started"
date: 2017-08-03T11:23:37+02:00
draft: false
weight: 10
---

To start a fully featured video call all you have to do is send a single
request to the eyeson API. The eyeson services organize video calls in
rooms. After you create a room the API provides you with an URL you can use to
send a user to the eyeson web GUI. The web GUI is hosted by the eyeson team and
ensures regular updates with the latest features as well as a stable and well
designed user experience. Any mobile visitors will be handled automatically
given the choice to join the meeting via mobile applications too.

## Get Your Api Key

Before you can create your first custom eyeson video calls you have to
generate a new api key.

Sign in at [eyeson Accounts](https://accounts.eyeson.team/), switch to
the [projects section](https://accounts.eyeson.team/projects), describe your
project in a few sentences and request your api key. Soon you will receive an
email to confirm the key generation. By proceeding you are ready to use
eyeson with your very personal api key.

The api is free to use and does not require any payment method to be stored and
does not cause costs. However, please note that the free service has a
monthly limit in terms of usage. If this limit is reached you will not be able
to use your key until the upcoming month anymore. For sure you can request an
upgrade to a paid plan anytime.

## Access the API

API endpoint: [https://api.eyeson.team](https://api.eyeson.team)

For authorization, required for team-based services, send an HTTP header with:

```
Authorization: <YOUR_API_KEY>
```

Responses will always contain an appropriate HTML status code plus a JSON
object in the body.

## Start and Join eyeson Room

It's incredibly easy to get started. All you need to do is implement a single
request. This request creates an eyeson MCU instance and provides you with a
link to a reference web UI which can be used right away.

The eyeson API provides eyeson room features to all WebRTC and WebSocket
capable clients. All communication with eyeson occurs over Secure HTTP and
Secure WebSocket protocols.

```
POST /rooms
```

Parameters   | Type              | Description
------------ | ----------------- | -------
...          | ...               | ...
user[name]   | String (required) | Display name of the user
...          | ...               | ...

EXAMPLE RESPONSE
```json
{
  links: {
    gui: "https://app.eyeson.team/?588a0d32f9c4860024f36f3",
    self: "...",
    websocket: "..."
  },
  ready: false,
  room: { ... },
  team: { ... },
  user: { ... }
}
```

Redirect your client to the URL given in the `links.gui` attribute, to use
with the eyeson pre-defined user interface.

```sh
$ curl -X POST \
  -H "Authorization: YOUR_API_KEY" \
  -d "user[name]=Bob" \
  "https://api.eyeson.team/rooms"
```

## Next Steps

The eyeson service provides an API for real-time data synchronization. The RT
API is a modern WebSocket based API providing you with a real time stream of
events and enabling you to build a powerful UI in combination with our
JavaScript libraries, SDKs and REST API.

### Go Further with SDKs

Test your integration by using the predefined eyeson UI. Build a totally
customized UI and UX by using the SDKs. Integrate eyeson features in your own
mobile and web applications. Use additional eyeson cloud MCU features,
available via the API.

Our REST API allows you to build your individual video communication solutions.

### Use Advanced MCU Features

Inject live data sources into the MCU (live video, play video file, static
image, static text). Specify layers and positions and sizes for live data
source injection. Use predeﬁned video call layouts. Enable or disable
video for participants connected to MCU. Add or remove audio and video sources
(moderator features). Show selected sources in fullscreen mode on the MCU.
Connect external video sources like IP CAMS. Connect the MCU to CDN networks
for broadcasting.  Connect phone lines to your MCU. Trigger and manage
 recordings on your MCU.

