---
title: "How to get started"
date: 2017-08-03T11:23:37+02:00
draft: false
---

Integrate eyeson into your own apps with our API and SDK's.  The eyeson API is
the foundation upon which all SDK's, frameworks, UI components and libraries
are built. The eyeson API offers direct control of eyeson CLOUD MCU instances
you can even compose video content in real-time.

## Get your api key

Please [contact us](https://eyeson.team/developers/#contact-me) to receive your
personal API key for your implementation.

## Access the api

API endpoint: [https://api.eyeson.team](https://api.eyeson.team)


For authorization send an HTTP header with
```
Authorization: YOUR_API_KEY
```
Responses will always contain an appropriate HTML status code plus a JSON
object in the body.

## Start and join eyeson room

It's incredibly easy to get started. All you need to do is implement a single
request. This request creates an eyeson MCU instance and provides you with a
link to a reference web UI which can be used right away.

The eyeson API provides eyeson room features to all WebRTC and WebSocket
capable clients. All communication with eyeson occurs over Secure HTTP and
Secure WebSocket protocols.

```
POST /rooms
PARAMETERS:
  # If you want to get a single user or a handful of users into a specific
  # meeting room, you can define an arbitrary id here. If kept empty, a random
  # id will be returned.
  id:  String (optional)
name:  String (optional)
  If you want to give the room a readable name
user:  User (required)
  The user object is described as follows:
id:  String (optional)
  You can commit a custom user id in order to identify the user in further REST requests without the need of remembering the eyeson user id e.g. your internal user id, an e-mail address, phone number, etc. If kept empty, a random id will be assigned.
name: String (required)
  Display name of the user
avatar: URL (optional)
  Avatars will be displayed in the sidebar of our pre-defined user interface.
```

EXAMPLE RESPONSE:
```
links: {
gui: "https://app.eyeson.team/?588a0d32f9c4860024f36f3"
      self: "..."
      websocket: "..."
},
ready: false,
  room: {...},
  team: {...},
  user: {...}
```

Redirect your client to the URL given in the links.gui attribute, to use
our pre-defined user interface.

```sh
$ curl -X POST \
  -H "Authorization: YOUR_API_KEY" \
  -d "user[name]=Bob" \
  "https://api.eyeson.team/rooms"
```

## Go further with SDK's

Test your integration with (by using) the predefined eyeson UI. Build a totally
customized UI and UX by using the SDK’s. Integrate eyeson features in your own
mobile and web applications. Use additional eyeson cloud MCU features,
available via the API.

Our REST API allows you to build your individual video communication solutions.

## MCU features

Inject live data sources into the MCU (live video, play video file, static image, static text)Specify layers and positions/sizes for live data source injectionUse predeﬁned video conference layoutsEnable/disable video for participants connected to MCUAdd/remove audio/video sources (Moderator features)
  Show selected sources in fullscreen mode on MCUConnect external video sources (e.g. IP CAMS)Connect MCU to CDN networks for broadcastingConnect phone lines to your MCUTrigger and manage recordings on your MCU


## Additional eyeson core features



Synchronized slide presentation / realtime slide image distributionFeeds & MessagingUpload / download / documents


We provide an API for real-time data synchronization. The RT API is a modern
WebSocket based API providing you with a real time stream of events and
enabling you to build a powerful UI in combination with our JavaScript
libraries, SDK's and REST API.
