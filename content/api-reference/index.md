---
title: "API Reference"
date: 2017-08-04T10:01:35+02:00
draft: false
---

Video conferences are organized in eyeson rooms. You can control who will join
a room by using an unique identifier. Every user will receive a link to the
guy containing a user-based unique access key that will match room and user
allowing to join the eyeson hosted web UI.

Within an eyeson room, all features like broadcast, recording, layout, inject
data like images or text with background and foreground images can be directly
controlled.

```plain
https://api.eyeson.team/<path>
HEADERS:
  - Authorization: <YOUR_API_KEY>
```

## eyeson Room

```
POST /rooms # create room a new room or join an existing by id.
GET  /rooms/:access_key # receive details of a persisted room.
```

Parameters   | Type              | Description
------------ | ----------------- | -------
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
GET /rooms/:access_key/users/:identifier
```

```
POST /guests/:guest_token
```

## File Management

```
GET /rooms/:access_key/users/:identifier
GET    /rooms/:access_key/files
POST   /rooms/:access_key/files
GET    /rooms/:access_key/files/:identifier
PUT    /rooms/:access_key/files/:identifier
DELETE /rooms/:access_key/files/:identifier
```

## Messages

```
POST   /rooms/:access_key/messages
```

## Presentation

```
POST   /rooms/:access_key/presentation
PUT    /rooms/:access_key/presentation
DELETE /rooms/:access_key/presentation
```

## Screencapture

```
POST   /rooms/:access_key/presentation
PUT    /rooms/:access_key/presentation
DELETE /rooms/:access_key/presentation
```

## Recording

```
DELETE /rooms/:access_key/recording
POST   /rooms/:access_key/recording
```

```
GET /recordings/:identifier
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

```
ws /rt
```

