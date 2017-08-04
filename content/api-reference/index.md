---
title: "API Reference"
date: 2017-08-04T10:01:35+02:00
draft: false
---

Video conferences are organized in eyeson rooms. You can control who will join
a room by using an unique identifier. Every user will receive a link to the
GUI containing a user-based unique access key that will match room and user
allowing to join the eyeson room.

Within an eyeson room, all features like broadcast, recording, layout, inject
data like images or text with background and foreground images can be directly
controlled.

```plain
https://api.eyeson.team/<path>
HEADERS:
  - Authorization: <YOUR_API_KEY>
```

{{< warning title="TODO" >}}
Info about when to use Authorization and when to use access key is missing!
{{< /warning >}}

## eyeson Room

```
POST /rooms # create room a new room or join an existing by id.
  RESPONSES 201 CREATED, 400 BAD REQUEST
GET  /rooms/:access_key # receive details of a persisted room.
  RESPONSES 200 OK, 404 NOT FOUND
```

Parameters   | Type              | Description
------------ | ----------------- | ------------
id           | String (optional) | If you want to get a single user or a handful of users into a specific meeting room, you can define an arbitrary id here. If kept empty, a random id will be returned.
name         | String (optional) | If you want to give the room a readable name.
user[id]     | String (optional) | You can commit a custom user id in order to identify the user in further REST requests without the need of remembering the eyeson user id e.g. your internal user id, an e-mail address, phone number, etc. If kept empty, a random id will be assigned.
user[name]   | String (required) | Display name of the user.
user[avatar] | URL (optional)    | Avatars will be displayed in the sidebar of our pre-defined user interface.

EXAMPLE RESPONSE:
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

## User and Guest User

```
GET /rooms/:access_key/users/:identifier # Fetch user details.
  RESPONSES 200 OK, 404 NOT FOUND
```

EXAMPLE RESPONSE:
```json
{
  "id": "596f5e442a3d24196f1b7d32",
  "name": "Jane Doe",
  "avatar": "https://example.com/avatar.png",
  "guest": false
}
```

Using the guest token received from the room creation, any number of guest
users can be created. This provides the opportunity to offer a quick join
method to a meeting.

A guest user has only access to a running meeting session. As soon a meeting
has ended, the guest user can no longer join any future meeting on this room.

```
POST /guests/:guest_token # Create a guest user for a meeting.
  RESPONSES 201 CREATED, 401 UNAUTHORIZED, 410 GONE
```

Parameters   | Type              | Description
------------ | ----------------- | ------------
id           | String (optional) | User identifier
name         | String (required) | Users name to be displayed in participants list.
avatar       | String (optional) | HTTP URI to a user avatar.

EXAMPLE RESPONSE:
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
        self: "https://api.eyeson.team/rooms/<access-key>/files/<file-id>",
        slides: [
          "https://some-cloud-storage.io/converted-file/page-01.png",
          "https://some-cloud-storage.io/converted-file/page-02.png",
          // ...
          "https://some-cloud-storage.io/converted-file/page-99.png"
        ],
        thumbnails: [
          "https://some-cloud-storage.io/converted-file/thumb-01.png",
          "https://some-cloud-storage.io/converted-file/thumb-02.png",
          // ...
          "https://some-cloud-storage.io/converted-file/thumb-99.png"
        ],
        download: "https://some-cloud-storage.io/most-awesome-presentation.pdf"
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
    self: "https://api.eyeson.team/rooms/<access-key>/files/<file-id>",
    slides: [
      "https://some-cloud-storage.io/converted-file/page-01.png",
      "https://some-cloud-storage.io/converted-file/page-02.png",
      // ...
      "https://some-cloud-storage.io/converted-file/page-99.png"
    ],
    thumbnails: [
      "https://some-cloud-storage.io/converted-file/thumb-01.png",
      "https://some-cloud-storage.io/converted-file/thumb-02.png",
      // ...
      "https://some-cloud-storage.io/converted-file/thumb-99.png"
    ],
    download: "https://some-cloud-storage.io/most-awesome-presentation.pdf"
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

The eyeson API offers presentation handling that will automatically store the
current presenter, store current presented slide and switch the current stream
layout to display the slide in full-size and participant in small windows on
the bottom position. This is especially helpful if you broadcast a stream (e.g.
to YouTube, Facebook, etc.) and want to ensure that viewers receive any content
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
  user: {
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
requires to have an extension installed. The eyeson GUI has a built in feature
detection and will guide a participant on how to install the extension
required.

```
POST /rooms/:access_key/presentation
  RESPONSES 201 CREATED
PUT /rooms/:access_key/presentation
  RESPONSES 200 OK
DELETE /rooms/:access_key/presentation
  RESPONSES 200 OK
```

{{< note title="Note" >}}
Screen capture presentation share the endpoint with slideshow presentations,
obviously without providing an URL to a slide.
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
  user: {
    "id": "596f5e442a3d24196f1b7d32",
    "name": "Jane Doe",
    "avatar": "https://example.com/avatar.png",
    "guest": false
  }
}
```

## Recording

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
    self: "https://api.eyeson.team/recordings/596f5e442a3d24196f1b7d32",
    download: "https://cloud-storage.eyeson.team/recordings/<key>.webm"
  },
  user: {
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

```
POST   /rooms/:access_key/broadcasts
DELETE /rooms/:access_key/broadcasts
PUT    /rooms/:access_key/broadcasts/:platform
DELETE /rooms/:access_key/broadcasts/:platform
```

## Content Integration aka Layers

```
POST   /rooms/<access_key>/layers
DELETE /rooms/<access_key>/layers/<identifier>
```


```
webhooks POST /webhooks
```

## Websocket Connection

Websocket connection endpoint is received in the response of the room creation.

Events:
  - Files Conversion Progress (0-1)

