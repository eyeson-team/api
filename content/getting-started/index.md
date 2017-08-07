---
title: "How to get started"
date: 2017-08-03T11:23:37+02:00
draft: false
---

To start a fully featured video conference all you have to do is send a single
request to the eyeson API. The eyeson services organize video conferences in
rooms. After you create a room the API provides you with an URL to can use to
send a user to the eyeson web GUI. The web GUI is hosted by the eyeson team and
ensures regular updates with the latest features as well as a stable and well
designed user experience. Any mobile visitors will be handled automatically
given the choice to join the meeting via mobile applications.

## Get Your Api Key

Please [contact us](https://eyeson.team/developers/#contact-me) to receive your
personal API key for your implementation.

## Access the API

API endpoint: [https://api.eyeson.team](https://api.eyeson.team)

For authorization send an HTTP header with
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

EXAMPLE RESPONSE:
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

Redirect your client to the URL given in the links.gui attribute, to use
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
JavaScript libraries, SDK's and REST API.

### Go Further with SDKs

Test your integration with (by using) the predefined eyeson UI. Build a totally
customized UI and UX by using the SDK's. Integrate eyeson features in your own
mobile and web applications. Use additional eyeson cloud MCU features,
available via the API.

Our REST API allows you to build your individual video communication solutions.

### Use Advanced MCU Features

Inject live data sources into the MCU (live video, play video file, static
image, static text). Specify layers and positions/sizes for live data source
injection. Use predeﬁned video conference layouts. Enable/disable video for
participants connected to MCU. Add/remove audio/video sources (Moderator
features). Show selected sources in fullscreen mode on MCU. Connect external
video sources (e.g. IP CAMS). Connect MCU to CDN networks for broadcasting.
Connect phone lines to your MCU. Trigger and manage recordings on your MCU.

