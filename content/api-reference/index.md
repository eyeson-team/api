---
title: "API Reference"
date: 2017-08-04T10:01:35+02:00
draft: false
---

Video conferences are organized in eyeson rooms. You can control who will join
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

```plain
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
to be needed to join a eyeson video conference. Within the response the current
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
```

Parameters   | Type              | Description
------------ | ----------------- | ------------
id           | String (optional) | If you want to get a single user or a handful of users into a specific meeting room, you can define an arbitrary id here. If kept empty, a random id will be returned.
name         | String (optional) | If you want to give the room a readable name.
user[id]     | String (optional) | You can supply a custom user id to identify the user in further REST requests without the need of remembering the eyeson user id e.g. your internal user id, an e-mail address, phone number, etc. If kept empty, a random id will be assigned.
user[name]   | String (required) | Display name of the user.
user[avatar] | URL (optional)    | Avatars will be displayed in the sidebar of our pre-defined user interface.

EXAMPLE RESPONSE
```json
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
```json
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
```json
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

## File Management

Documents like PDF slide presentations or images can be stored in eyeson
service provided cloud storage. The files are available throughout the meeting.
Uploaded PDF files are automatically converted to single images that can be
used to present high resolution single slides.

```
GET    /rooms/:access_key/files
  RESPONSES 200 OK
```

EXAMPLE RESPONSE
```json
{
  files: [
    {
      "id": "596f5e442a3d24196f1b7d32",
      "name": "most-awesome-presentation.pdf",
      "type": "...",
      "converted": true,
      "conversion_progress": 1.0,
      "failed": false,
      "links": {
        "self": "https://api.eyeson.team/rooms/<access-key>/files/<file-id>",
        "slides": [
          "https://some-cloud-storage.io/converted-file/page-01.png",
          "https://some-cloud-storage.io/converted-file/page-02.png",
          // ...
          "https://some-cloud-storage.io/converted-file/page-99.png"
        ],
        "thumbnails": [
          "https://some-cloud-storage.io/converted-file/thumb-01.png",
          "https://some-cloud-storage.io/converted-file/thumb-02.png",
          // ...
          "https://some-cloud-storage.io/converted-file/thumb-99.png"
        ],
        "download": "https://some-cloud-storage.io/most-awesome-presentation.pdf"
      }
    },
    {
      // ...
    }
  ]
}
```

```
POST   /rooms/:access_key/files # Document upload, requires file.
  RESPONSES 201 CREATED, 400 BAD REQUEST
GET /rooms/:access_key/files/:identifier # Fetch document.
  RESPONSES 200 OK
DELETE /rooms/:access_key/files/:identifier # Destroy document.
  RESPONSES 200 OK
```

Parameters   | Type              | Description
------------ | ----------------- | ------------
file         | String (required) | File upload parameter required at creation.

EXAMPLE RESPONSE
```json
{
  "id": "596f5e442a3d24196f1b7d32",
  "name": "most-awesome-presentation.pdf",
  "type": "...",
  "converted": true,
  "conversion_progress": 1.0,
  "failed": false,
  "links": {
    "self": "https://api.eyeson.team/rooms/<access-key>/files/<file-id>",
    "slides": [
      "https://some-cloud-storage.io/converted-file/page-01.png",
      "https://some-cloud-storage.io/converted-file/page-02.png",
      // ...
      "https://some-cloud-storage.io/converted-file/page-99.png"
    ],
    "thumbnails": [
      "https://some-cloud-storage.io/converted-file/thumb-01.png",
      "https://some-cloud-storage.io/converted-file/thumb-02.png",
      // ...
      "https://some-cloud-storage.io/converted-file/thumb-99.png"
    ],
    "download": "https://some-cloud-storage.io/most-awesome-presentation.pdf"
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

## Presentation

The eyeson API offers presentation handling out of the box. Meaning it will
automatically store the current presenter, the currently presented slide and
switch the stream layout to accommodate the slide in full-size and the
participants. This is especially helpful if you broadcast a stream (e.g. to
YouTube, Facebook, etc.) and want to ensure that viewers receive any content
presented. Participants of the eyeson GUI will additionally receive an image of
the slide.

```
POST /rooms/:access_key/presentation
  RESPONSES 201 CREATED, 400 BAD REQUEST
PUT /rooms/:access_key/presentation
  RESPONSES 200 OK, 404 NOT FOUND
DELETE /rooms/:access_key/presentation
  RESPONSES 200 OK
```

Parameters   | Type              | Description
------------ | ----------------- | ------------
slide        | String (required) | URL to PNG image, to show in video stream.

EXAMPLE RESPONSE
```json
{
  "slide": "https://some-cloud-storage.io/converted-file/page-42.png",
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
  "user": {
    "id": "596f5e442a3d24196f1b7d32",
    "name": "Jane Doe",
    "avatar": "https://example.com/avatar.png",
    "guest": false
  }
}
```

{{< note title="Note" >}}
A presentation is locked to the user that created it. Any user can still stop
a presentation but not switch to another slide.
{{< /note >}}

## Screen capture

In order to provide screen capture presentations, the clients user agent
requires an extension to be installed. The GUI has built in feature detection
and will guide a participant through the installation.

```
POST /rooms/:access_key/presentation
  RESPONSES 201 CREATED
PUT /rooms/:access_key/presentation
  RESPONSES 200 OK
DELETE /rooms/:access_key/presentation
  RESPONSES 200 OK
```

{{< note title="Note" >}}
Screen capture presentation share the endpoint with slide-show presentations.
Without providing a URL to a slide, obviously.
{{< /note >}}

EXAMPLE RESPONSE
```json
{
  "slide": null,
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
  "user": {
    "id": "596f5e442a3d24196f1b7d32",
    "name": "Jane Doe",
    "avatar": "https://example.com/avatar.png",
    "guest": false
  }
}
```

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
```json
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

## Broadcast

To connect an eyeson room with a broadcast you have to provide a valid streaming
URL. To receive one please follow the instructions from [YouTube](yt-streaming-api),
[Facebook](fb-streaming-api), or other.

```
POST /rooms/:access_key/broadcasts
  RESPONSES 201 CREATED, 400 BAD REQUEST
```

Parameters   | Type              | Description
------------ | ----------------- | ------------
platform     | String (required) | Platform identifier (e.g. 'twitter').
stream\_url  | String (required) | Streaming URL.
player\_url  | String (optional) | Public URL to view the live video.

```
PUT /rooms/:access_key/broadcasts/:platform
  RESPONSES 200 OK, 400 BAD REQUEST, 404 NOT FOUND
```

Parameters   | Type              | Description
------------ | ----------------- | ------------
platform     | String (required) | Platform identifier (e.g. 'twitter').
player\_url  | String (required) | Public URL to view the live video.

```
DELETE /rooms/:access_key/broadcasts/:platform
  RESPONSES 200 OK, 400 BAD REQUEST
DELETE /rooms/:access_key/broadcasts # delete all broadcasts
  RESPONSES 200 OK, 400 BAD REQUEST, 404 NOT FOUND
```

{{< note title="Note" >}}
You can use multiple platforms to broadcast to but there is a limitation of
one stream per platform.
{{< /note >}}

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

```
POST /rooms/:access_key/layers # insert image or text message
  RESPONSES 201 CREATED, 400 BAD REQUEST
```

Parameters      | Type              | Description
--------------- | ----------------- | ------------
file            | String (optional) | File upload.
url             | String (optional) | File URL.
insert[icon]    | String (optional) | URL for an icon to show.
insert[title]   | String (optional) | Message title.
insert[content] | String (optional) | Message content.
z-index         | String (optional) | Use -1 for background or 1 (default) for foreground position.
layout          | String (optional) | Layout mode either 'fixed' or 'auto' (default).

```
DELETE /rooms/:access_key/layers/:index # clear layer, index: -1 or 1
  RESPONSES 200 OK, 400 BAD REQUEST
```

## Register Webhooks

Register webhooks for any updates using one or multiple of the following
resource types comma separated: user, document, recording, broadcast,
room\_instance, team or presentation.

```
webhooks POST /webhooks
  HEADERS Authorization
```

Parameters   | Type              | Description
------------ | ----------------- | ------------
url          | String (required) | Target URL.
types        | String (required) | Comma separated resource types.

In order to get notified for new recordings in any room session, you can
register a webhook upfront, using your target location and the webhook type
`recording`. See the recording resource on details of the received json
document.

[chrome-browser]: https://www.google.com/chrome/index.html "Google Chrome Webbrowser"
[firefox-browser]: https://www.mozilla.org/firefox/ "Mozilla Firefox Webbrowser"
[yt-streaming-api]: https://developers.google.com/youtube/v3/live/getting-started " YouTube Live Streaming API Overview"
[fb-streaming-api]: https://developers.facebook.com/docs/videos/live-video "Live Video on Facebook"
