---
title: "API Reference"
date: 2017-08-04T10:01:35+02:00
draft: false
weight: 20
---

Video calls are organized in eyeson rooms. You can control who will join
a room by using a unique identifier. Every user will receive a link to the
GUI containing a unique access key scoped to the room and user. This key grants
access to the the eyeson room.

Within an eyeson room, all features like broadcast, recording, layout,
data and image injection be directly controlled.

## Authorization

There are two levels of authorization: team-based via api-key and user-based
temporary access-key. To create a room and to register webhooks (for any rooms)
you have to provide a team-based authorization sending the API key in the HTTP
header.

```
https://api.eyeson.team/<path>
HEADERS:
  - Authorization: <YOUR_API_KEY>
```

Any other communication with the API requires user-based authorization.
Meaning: an active room and user identified by an `access_key`. The
access key is provided by the resource endpoint, no additional headers needed.
headers needed.

## eyeson Room

Any room can be created with a team-based API request, resulting in everything
to be needed to join a eyeson video calls. Within the response the current
state of a room can be seen on the ready states for user, room and the global
ready state that combines these two.

In the links section you can find a direct URL to the eyeson GUI. By using this
no further communication with the API is required and your user is ready-to-go
by using this link with any WebRTC capable user-agent like webbrowser Chrome
or Firefox.

The guest-token can be used to **quick-join** an eyeson room. Using the eyeson
web GUI a quick-join URL can be generated using the following pattern:

```
https://app.eyeson.team/guest=<guest_token>
```

The user to join the room has to be provided. If someone already created and
joined the room session, the user provided will join this existing room
session.


```
POST /rooms # create room a new room or join an existing by id.
  HEADERS Authorization
  RESPONSES 201 CREATED, 400 BAD REQUEST
GET  /rooms/:access_key # receive details of a persisted room.
  RESPONSES 200 OK, 404 NOT FOUND
DELETE /rooms/:identifier # force to stop a running meeting
  HEADERS Authorization
  RESPONSES 204 NO CONTENT, 404 NOT FOUND, 400 BAD REQUEST
```

Parameters                           | Type                     | Description
------------------------------------ | ------------------------ | ------------
id                                   | String (optional)        | If you want to get a single user or a handful of users into a specific meeting room, you can define an arbitrary id here. If kept empty, a random id will be returned.
name                                 | String (optional)        | If you want to give the room a readable name.
user[id]                             | String (optional)        | You can supply a custom user id to identify the user in further REST requests without the need of remembering the eyeson user id e.g. your internal user id, an e-mail address, phone number, etc. If kept empty, a random id will be assigned.
user[name]                           | String (required)        | Display name of the user.
user[avatar]                         | URL (optional)           | Avatars will be displayed in the sidebar of our pre-defined user interface.
options[show\_names]                 | Boolean (optional)       | Show display names in video. Default: true
options[show\_label]                 | Boolean (optional)       | Show eyeson logos in GUI. Default: true
options[exit\_url]                   | String (optional)        | Exit destination, URL for exit button in GUI
options[recording\_available]        | Boolean (optional)       | Allow recordings. Default: true
options[broadcast\_available]        | Boolean (optional)       | Allow broadcasting. Default: true
options[reaction\_available]         | Boolean (optional)       | Show gif media inserts in GUI. Default: true
options[layout\_available]           | Boolean (optional)       | Allow layout updates. Default: true
options[guest\_token\_available]     | Boolean (optional)       | Provide guest token. Default: true
options[lock\_available]             | Boolean (optional)       | Enable meeting lock. Default: false
options[kick\_available]             | Boolean (optional)       | Allow participant kick. Default: true
options[sfu\_mode]                   | String (optional)        | Set a desired sfu mode. Possible values are: 'disabled', 'screencast' or 'ptp'. To either disable the feature, limit it to screencasts or enable it for meetings with only 2 participants. Default: 'ptp'
options[custom\_fields]\[locale\]    | Language Code (optional) | User preferred language code (en, de, fr).
options[custom\_fields]\[logo\]      | String (optional)        | URL to custom logo.
options[custom\_fields]\[hide_chat\] | Boolean (optional)       | Hide chat in GUI. Default: false

EXAMPLE RESPONSE
```
{
  "access_key": "5cd3f7dce1382379a013d874",
  "ready": false,
  "room": {
    "id":   "596f5e442a3d24196f1b7d32",
    "name": "eyeson room",
    "ready": false,
    "shutdown": false,
    "sip": {
      "uri": "https://.../",
      "domain": "example.eyeson.team",
      "authorizationUser": "username",
    },
    "guest_token": "5971daf62a3d241b0d263ec6"
  },
  "team": {
    "name": "My Company Ltd."
  },
  "user": {
    "id": "596f5e442a3d24196f1b7d32",
    "name": "Jane Doe",
    "avatar": "https://example.com/avatar.png",
    "guest": false,
    "ready": false,
    "sip": {
      "uri": "https://.../",
      "domain": "example.eyeson.team",
      "wsServers": [ "..." ],
      "instanceId": "some-instance-id",
      "userAgentString": "user-id",
      "authorizationUser": "username",
      "displayName": "mrs. doe",
      "stunServers": [ "..." ],
      "turnServers": [ "..." ],
      "registerExpires": "...",
      "password": "sip-password"
    },
  },
  "links": {
    "gui": "https://app.eyeson.team/?588a0d32f9c4860024f36f3",
    "self": "https://api.eyeson.team/rooms",
    "websocket": "https://api.eyeson.team/rt"
  }
}
```

## User and Guest User

```
GET /rooms/:access_key/users/:identifier # Fetch user details.
  RESPONSES 200 OK, 404 NOT FOUND
```

EXAMPLE RESPONSE
```
{
  "id": "596f5e442a3d24196f1b7d32",
  "name": "Jane Doe",
  "avatar": "https://example.com/avatar.png",
  "guest": false
}
```

Using the guest token received from the room creation, any number of guest
users can be created. This provides an option for you to offer a "quick join"
method to a meeting.

A guest user only has access to a running meeting session. Once a meeting
ends, the guest user cannot join any future meetings in this room.

```
POST /guests/:guest_token # Create a guest user for a meeting.
  RESPONSES 201 CREATED, 401 UNAUTHORIZED, 410 GONE
```

Parameters   | Type              | Description
------------ | ----------------- | ------------
id           | String (optional) | User identifier
name         | String (required) | Users name to be displayed in participants list.
avatar       | String (optional) | HTTP URI to a user avatar.

EXAMPLE RESPONSE
```
{
  "ready": false,
  "room": {
    "id":   "596f5e442a3d24196f1b7d32",
    "name": "eyeson room",
    "ready": false,
    "shutdown": false,
    "sip": {
      "uri": "https://.../",
      "domain": "example.eyeson.team",
      "authorizationUser": "username",
    },
    "guest_token": "5971daf62a3d241b0d263ec6"
  },
  "team": {
    "name": "my own company"
  },
  "user": {
    "id": "unique-user-id",
    "name": "Some User",
    "avatar": "https://example.com/avatar.png",
    "guest": false,
    "ready": false,
    "sip": {
      "uri": "https://.../",
      "domain": "example.eyeson.team",
      "wsServers": [ "..." ],
      "instanceId": "instance-id",
      "userAgentString": "user-id",
      "authorizationUser": "username",
      "displayName": "display name",
      "stunServers": [ "..." ],
      "turnServers": [ "..." ],
      "registerExpires": "...",
      "password": "sip-password"
    },
  },
  "links": {
    "gui": "https://app.eyeson.team/?588a0d32f9c4860024f36f3",
    "self": "https://api.eyeson.team/rooms",
    "websocket": "https://api.eyeson.team/rt"
  }
}
```

## Messages

Broadcast data messages to all users of a meeting.

```
POST /rooms/:access_key/messages
  RESPONSE 201 CREATED, 400 BAD REQUEST
```

Parameters   | Type              | Description
------------ | ----------------- | ------------
type         | String (required) | Type description, e.g. 'chat'.
content      | String (required) | Data content.

## Recording

Recordings are saved in eyesons cloud storage and can be downloaded from there.
Direct URLs to downloads _expire_, so it's better store the recording identifier
and fetch a valid resource link on demand.

```
POST /rooms/:access_key/recording
  RESPONSES 201 CREATED, 400 BAD REQUEST
DELETE /rooms/:access_key/recording
  RESPONSES 200 OK
```

```
GET /recordings/:identifier
  RESPONSES 200 OK, 404 NOT FOUND
```

EXAMPLE RESPONSE
```
{
  "id": "596f5e442a3d24196f1b7d32",
  "created_at": "TODO",
  "duration": 12345, // duration in seconds
  "links": {
    "self": "https://api.eyeson.team/recordings/596f5e442a3d24196f1b7d32",
    "download": "https://cloud-storage.eyeson.team/recordings/<key>.webm"
  },
  "user": {
    "id": "596f5e442a3d24196f1b7d32",
    "name": "Jane Doe",
    "avatar": "https://example.com/avatar.png",
    "guest": false
  },
  "room": {
    "id":   "596f5e442a3d24196f1b7d32",
    "name": "eyeson room",
    "ready": false,
    "shutdown": false,
    "sip": {
      "uri": "https://.../",
      "domain": "example.eyeson.team",
      "authorizationUser": "username",
    },
    "guest_token": "5971daf62a3d241b0d263ec6"
  }
}
```

```
DELETE /recordings/:identifier
  RESPONSES 200 OK, 404 NOT FOUND
```

## Broadcast

To connect an eyeson room with a broadcast you have to provide a valid
streaming RTMP url.

```
POST /rooms/:access_key/broadcasts
  RESPONSES 201 CREATED, 400 BAD REQUEST
```

Parameters   | Type              | Description
------------ | ----------------- | ------------
stream\_url  | String (required) | Streaming URL.
player\_url  | String (optional) | Public URL to view the live video.

```
PUT /rooms/:access_key/broadcasts/generic
  RESPONSES 200 OK, 400 BAD REQUEST, 404 NOT FOUND
```

Parameters   | Type              | Description
------------ | ----------------- | ------------
player\_url  | String (required) | Public URL to view the live video.

```
DELETE /rooms/:access_key/broadcasts # stop broadcast
  RESPONSES 200 OK, 400 BAD REQUEST, 404 NOT FOUND
```

## Layout

The meeting participants will be presented in an equally distributed tiled
video layout where eyeson takes care to always update the stream depending on
the number of users. However in some cases you might want to assign specific
users to a video positions. You can do this by sending the specified podium
user-ids as a list, or switch back to auto layout any time.

Layouts are not available when using the [SFU] mode, so ensure to set the
[room configuration](#eyeson-room) properly or ensure to have more than
two participants.

```
POST /rooms/:access_key/layout
  RESPONSES 200 OK, 400 BAD REQUEST
```

Parameters  | Type              | Description
----------- | ----------------- | ------------
layout      | String (optional) | Value 'auto' or 'custom'.
users       | String (optional) | List of podium user\_ids or an empty string for an empty spot.
show\_names | String (optional) | Public URL to view the live video.


```sh
$ curl -X POST \
  -d "users[]=USER_ID_A" \
  -d "users[]=USER_ID_B" \
  -d "users[]=USER_ID_C" \
  -d "users[]=USER_ID_D" \
  "https://api.eyeson.team/rooms/ACCESS_KEY/layout"
```

## Content Integration aka Layers

Show any data content inside your video using the eyeson layer service. There
are currently three ways to achieve this.

To show simple text message inserts you can use the insert parameter. You'd
listen for tweets in a separate service and display them using the tweet senders
avatar as an icon, name as title and the tweet as content.

For more complex data generate an image and either upload the image or provide
a public URL. For overlaying images use a transparent background.

Any eyeson room video has a resolution of **1280x960** pixels. Ensure any file
uploaded is an alpha interlaced PNG image with a corresponding resolution to
avoid any distortions.

When using layers you might want to disable the [SFU] mode that in
default [room configuration](#eyeson-room) will transport individual streams
for single and two participants and not show layer media.

```
POST /rooms/:access_key/layers # insert image or text message
  RESPONSES 201 CREATED, 400 BAD REQUEST
```

Parameters      | Type              | Description
--------------- | ----------------- | ------------
file            | File (optional)   | File upload.
url             | String (optional) | File URL.
insert[icon]    | String (optional) | URL for an icon to show.
insert[title]   | String (optional) | Message title.
insert[content] | String (optional) | Message content.
z-index         | String (optional) | Use -1 for background or 1 (default) for foreground position.
layout          | String (optional) | Layout mode either 'fixed' or 'auto' (default).

```sh
$ curl -X POST \
  -d "url=https://eyeson-team.github.io/api/images/eyeson-overlay.png" \
  "https://api.eyeson.team/rooms/${ACCESS_KEY}/layers"
```

```
DELETE /rooms/:access_key/layers/:index # clear layer, index: -1 or 1
  RESPONSES 200 OK, 400 BAD REQUEST
```

Besides image data you can playback videos. We currently limit it to media
files in MP4 format that have to be available through a public URL. Note that
we do not provide any kind of upload service for this feature.

```
POST /rooms/:access_key/playbacks # play a video
  RESPONSES 201 CREATED, 400 BAD REQUEST
```

Parameters               | Type              | Description
------------------------ | ----------------- | ------------
playback[audio]          | Boolean           | Play audio (default: false)
playback[play_id]        | String            | Choose an identifier, e.g. current timestamp
playback[replacement_id] | String            | User-id of the participants video to be replaced
playback[url]            | String            | Hosted MP4 video file
playback[name]           | String            | Custom readable name for identification

The video will replace the current stream of a specific user. For sure you can
use the layout to set this user to fullscreen during the video playback and
switch back afterwards using the layout feature. As with layers ensure you
disable SFU mode.

## Register Webhooks

Register a webhook for any updates using one or multiple of the following
resource types comma separated: recording\_update, room\_update. Note that you
can register a single webhook, use the received response type to detect its
purpose. The webhook endpoint on your server requires to accept an HTTPS POST
request, the body of the request is provided in JSON format.
You can verify your requests using a SHA256 HMAC on the request body using your
API key, the corresponding hash is sent within header `X-Eyeson-Signature`.

```
webhooks POST /webhooks
  HEADERS Authorization
```

Parameters   | Type              | Description
------------ | ----------------- | ------------
url          | String (required) | Target URL.
types        | String (required) | Comma separated resource types.

Check the current registered webhook as well as the last sent message timestamp
and response code.

```
GET /webhooks
  HEADERS Authorization
  RESPONSES 200 OK
```

EXAMPLE RESPONSE
```
{
  "id": "596f5e442a3d24196f1b7d32",
  "url": "https://eyeson.com/webhook",
  "types": "room_update",
  "last_request_sent_at":"2020-08-20T11:00:57.117+00:00",
  "last_response_code":"204"
}
```

```
DELETE /webhooks/:id
  HEADERS Authorization
  RESPONSES 204 OK, 400 BAD REQUEST
```

In order to get notified for new recordings in any room session, you can
register a webhook upfront, using your target location and the webhook type
`recording_update`. See the recording resource on details of the received JSON
document.

EXAMPLE
```
{
  "type": "recording_update",
  "recording": {
    "id": "...",
    "created_at:": 1591700000,
    "duration:": 60,
    "links:": {
      "self": "https://...",
      "download": "https://..."
    },
    "user": {
      "id": "...",
      "name": "...",
      "avatar": "..."
    },
    "room": {
      "id": "...",
      "name": "...",
      "started_at": "...",
    }
  }
}
```

If you want to build up a meeting history in your application, register a
webhook for `room_update` and track when receiving a room update where
`shutdown` attribute is `true`.

EXAMPLE
```
{
  "type": "room_update",
  "room": {
    "id": "...",
    "name": "...",
    "started_at": "...",
    "shutdown": true
  }
}
```

[chrome-browser]: https://www.google.com/chrome/index.html "Google Chrome Webbrowser"
[firefox-browser]: https://www.mozilla.org/firefox/ "Mozilla Firefox Webbrowser"
[SFU]: https://webrtcglossary.com/sfu/ "Selective Forwarding Unit"
