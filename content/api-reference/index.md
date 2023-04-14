---
title: "API Reference"
date: 2017-08-04T10:01:35+02:00
draft: false
weight: 20
---

Video calls are organized in Eyeson rooms. You can control who will join
a room by using a unique identifier. Every user will receive a link to the
GUI containing a unique access key scoped to the room and user. This key grants
access to the the Eyeson room.

Within an Eyeson room, all features like broadcast, recording, layout,
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
Meaning: an active room and user identified by an `access_key`. The access key
is provided by the resource endpoint, no additional headers are needed.

An expired access key - meeting has been shutdown - will result in a HTTP
response code of `410 GONE` for any request that uses the access key for
authorization.

## Eyeson Room

Any room can be created with a team-based API request, resulting in everything
to be needed to join a Eyeson video calls. Within the response the current
state of a room can be seen on the ready states for user, room and the global
ready state that combines these two.

In the links section you can find a direct URL to the Eyeson GUI. By using this
no further communication with the API is required and your user is ready-to-go
by using this link with any WebRTC capable user-agent like webbrowser Chrome
or Firefox.

The guest-token can be used to **quick-join** an Eyeson room. Using the Eyeson
web GUI a quick-join URL can be generated using the following pattern:

```
https://app.eyeson.team/?guest=<guest_token>
```

The user to join the room has to be provided. If someone already created and
joined the room session, the user provided will join this existing room
session.

```
POST /rooms # create room a new room or join an existing by id.
  HEADERS Authorization
  RESPONSES 201 CREATED, 400 BAD REQUEST, 403 FORBIDDEN

GET /rooms/<access_key> # receive details of a persisted room.
  RESPONSES 200 OK, 404 NOT FOUND, 410 GONE

DELETE /rooms/<room_id> # force to stop a running meeting
  HEADERS Authorization
  RESPONSES 204 NO CONTENT, 400 BAD REQUEST, 403 FORBIDDEN, 404 NOT FOUND
```

Parameters                                                | Type                     | Description
------------------------------------                      | ------------------------ | ------------
id                                                        | String (optional)        | If you want to get a single user or a handful of users into a specific meeting room, you can define an arbitrary id here. If kept empty, a random id will be returned.
name                                                      | String (optional)        | If you want to give the room a readable name.
user[id]                                                  | String (optional)        | You can supply a custom user id to identify the user in further REST requests without the need of remembering the Eyeson user id e.g. your internal user id, an e-mail address, phone number, etc. If kept empty, a random id will be assigned.
user[name]                                                | String (required)        | Display name of the user.
user[avatar]                                              | URL (optional)           | Avatars will be displayed in the sidebar of our pre-defined user interface.
options[show\_names]                                      | Boolean (optional)       | Show display names in video. Default: true
options[show\_label]                                      | Boolean (optional)       | Show Eyeson logos in GUI. Default: true
options[exit\_url]                                        | String (optional)        | Exit destination, URL for exit button in GUI
options[recording\_available]                             | Boolean (optional)       | Allow recordings. Default: true
options[broadcast\_available]                             | Boolean (optional)       | Allow broadcasting. Default: true
options[reaction\_available]                              | Boolean (optional)       | Show gif media inserts in GUI. Default: true
options[layout\_available]                                | Boolean (optional)       | Allow layout updates. Default: true
options[guest\_token\_available]                          | Boolean (optional)       | Provide guest token. Default: true
options[lock\_available]                                  | Boolean (optional)       | Enable meeting lock. Default: false
options[kick\_available]                                  | Boolean (optional)       | Allow participant kick. Default: true
options[sfu\_mode]                                        | String (optional)        | Set a desired sfu mode. Possible values are: 'disabled', 'screencast' or 'ptp'. To either disable the feature, limit it to screencasts or enable it for meetings with only 2 participants. Default: 'ptp'
options[widescreen]                                       | Boolean (optional)       | Run meeting in widescreen mode (16:9 aspect ratio). Default: false
options[audio\_insert]                                    | String (optional)        | Show audio insert ('enabled', 'disabled' or 'audio\_only'). Default: audio\_only
options[audio\_insert\_position][x]                       | Number (optional)        | X position value of the audio insert.
options[audio\_insert\_position][y]                       | Number (optional)        | Y position value of the audio insert.
options[custom\_fields]\[locale\]                         | Language Code (optional) | User preferred language code (en, de, fr).
options[custom\_fields]\[logo\]                           | String (optional)        | URL to custom logo.
options[custom\_fields]\[hide_chat\]                      | Boolean (optional)       | Hide chat in GUI. Default: false
options[custom\_fields]\[virtual_background\]             | Boolean (optional)       | Enable Virtual Background selection. Default: false
options[custom\_fields]\[virtual_background_allow_guest\] | Boolean (optional)       | Enable Virtual Background selection for Guest users. Default: false
options[custom\_fields]\[virtual_background_image\]       | String (optional)        | Provide a custom Virtual Background image for selection.

Example Response
```
{
  "access_key": "vAX29sGYPZEvZQwvg0jycrPX",
  "ready": false,
  "locked": false,
  "room": {
    "id": "63ede350b20526000f64376b",
    "name": "eyeson room",
    "ready": false,
    "started_at": "2021-01-01T09:00:00.000Z",
    "shutdown": false,
    "sip": {
      ...
    },
    "guest_token": "gKsiVlrvkFyL3klk1wBHLlm3"
  },
  "team": {
    "name": "My Company Ltd."
  },
  "user": {
    "id": "63ede350b20526000f64376d",
    "room_id": "63ede350b20526000f64376b",
    "name": "Jane Doe",
    "avatar": "https://myawesomeapp.com/images/avatar.png",
    "guest": false,
    "ready": false,
    "sip": {
      ...
    }
  },
  "links": {
    "self": "https://api.eyeson.team/rooms/vAX29sGYPZEvZQwvg0jycrPX",
    "gui": "https://app.eyeson.team/?vAX29sGYPZEvZQwvg0jycrPX",
    "guest_join": "https://app.eyeson.team/?guest=gKsiVlrvkFyL3klk1wBHLlm3",
    "websocket": "https://api.eyeson.team/rt?access_key=vAX29sGYPZEvZQwvg0jycrPX"
  },
  "options": {
    "show_names": true,
    "show_label": true,
    "exit_url": "https://myawesomeapp.com/meeting-end",
    "recording_available": true,
    "broadcast_available": true,
    "layout_available": true,
    "layout": "auto",
    "reaction_available": true,
    "suggest_guest_names": true,
    "lock_available": false,
    "kick_available": true,
    "sfu_mode": "ptp",
    "layout_users": null,
    "layout_name": null,
    "voice_activation": false,
    "custom_fields": {},
    "widescreen": false
  },
  "presentation": null,
  "broadcasts": [],
  "recording": null,
  "snapshots": [],
  "signaling": {
    ...
  }
}
```

If `recording_available`, `broadcast_available`, `layout_available`, or
other `...available` options are set to false, related API requests will respond
with status `405 METHOD NOT ALLOWED`. Except for kick and lock, they will
respond with status `403 FORBIDDEN`.

## User and Guest User

```
GET /rooms/<access_key>/users/<user_id> # Fetch user details.
  RESPONSES 200 OK, 404 NOT FOUND, 410 GONE
```

Example Response
```
{
  "id": "63ede350b20526000f64376d",
  "name": "Jane Doe",
  "avatar": "https://myawesomeapp.com/images/avatar.png",
  "guest": false,
  "joined_at": "2021-01-01T09:00:00.000Z"
}
```

Using the guest token received from the room creation, any number of guest
users can be created. This provides an option for you to offer a "quick join"
method to a meeting.

A guest user only has access to a running meeting session. Once a meeting
ends, the guest user cannot join any future meetings in this room.

```
POST /guests/<guest_token> # Create a guest user for a meeting.
  RESPONSES 201 CREATED, 400 BAD REQUEST, 410 GONE, 423 LOCKED
```

Parameters               | Type                     | Description
------------------------ | ------------------------ | ------------
id                       | String (optional)        | User identifier
name                     | String (required)        | Users name to be displayed in participants list.
avatar                   | String (optional)        | HTTP URI to a user avatar.
custom\_fields\[locale\] | Language Code (optional) | User preferred language code (en, de, fr).


Example Response
```
{
  "access_key": "cnNqsoJlGIsf8L2WtqDzrH4y",
  "ready": false,
  "locked": false,
  "room": {
    "id": "63ede350b20526000f64376b",
    "name": "eyeson room",
    "ready": true,
    "started_at": "2021-01-01T09:00:00.000Z",
    "shutdown": false,
    "sip": {
      ...
    },
    "guest_token": "gKsiVlrvkFyL3klk1wBHLlm3"
  },
  "team": {
    "name": "My Company Ltd."
  },
  "user": {
    "id": "63ede4a773b114000faa26eb",
    "room_id": "63ede350b20526000f64376b",
    "name": "Guest user",
    "avatar": "https://myawesomeapp.com/images/guest-avatar.png",
    "guest": true,
    "ready": false,
    "sip": {
      ...
    }
  },
  "links": {
    "self": "https://api.eyeson.team/rooms/cnNqsoJlGIsf8L2WtqDzrH4y",
    "gui": "https://app.eyeson.team/?cnNqsoJlGIsf8L2WtqDzrH4y",
    "guest_join": "https://app.eyeson.team/?guest=gKsiVlrvkFyL3klk1wBHLlm3",
    "websocket": "https://api.eyeson.team/rt?access_key=cnNqsoJlGIsf8L2WtqDzrH4y"
  },
  "options": {
    "show_names": true,
    "show_label": true,
    "exit_url": null,
    "recording_available": true,
    "broadcast_available": true,
    "layout_available": true,
    "layout": "auto",
    "reaction_available": true,
    "suggest_guest_names": true,
    "lock_available": false,
    "kick_available": true,
    "sfu_mode": "ptp",
    "layout_users": null,
    "layout_name": null,
    "voice_activation": false,
    "custom_fields": {},
    "widescreen": false
  },
  "presentation": null,
  "broadcasts": [],
  "recording": null,
  "snapshots": [],
  "signaling": {
    ...
  }
}
```

## Lock meeting and kick user

A meeting can be locked, so that only participants who are actively in the
meeting at the moment of locking are allowed to stay. No more users can join
afterwards.\
_Heads-up! There's no "unlock" yet. Once locked, there's no way to let new users
join the running meeting._

```
POST /rooms/<access_key>/lock
  RESPONSES 201 CREATED, 403 FORBIDDEN, 404 NOT FOUND, 410 GONE
```

Sometimes it may be necessary to remove a participant from a meeting. Please
note, that kicked users can re-join at any time!

```
DELETE /rooms/<access_key>/users/<user_id>
  RESPONSES 200 OK, 403 FORBIDDEN, 404 NOT FOUND, 410 GONE
```

## Messages

Broadcast data messages to all users of a meeting.

```
POST /rooms/<access_key>/messages
  RESPONSE 201 CREATED, 400 BAD REQUEST, 404 NOT FOUND, 410 GONE
```

Parameters   | Type              | Description
------------ | ----------------- | ------------
type         | String (required) | Type description, e.g. 'chat'.
content      | String (required) | Data content.

## Recording

Recordings are saved in Eyesons cloud storage and can be downloaded from there.
Direct URLs to downloads _expire_, so it's better store the recording identifier
and fetch a valid resource link on demand.

```
POST /rooms/<access_key>/recording # start recording
  RESPONSES 201 CREATED, 404 NOT FOUND, 405 METHOD NOT ALLOWED, 406 NOT ACCEPTABLE, 410 GONE

DELETE /rooms/<access_key>/recording # stop recording
  RESPONSES 200 OK, 404 NOT FOUND, 410 GONE
```

```
GET /recordings/<recording_id>
  HEADERS Authorization
  RESPONSES 200 OK, 404 NOT FOUND
```

Example Response
```
{
  "id": "63ede57ff3e015000fbe1af5",
  "created_at": 1609491600,
  "duration": 1800, // duration in seconds
  "links": {
    "self": "https://api.eyeson.team/recordings/63ede57ff3e015000fbe1af5",
    "download": "https://fs.eyeson.com/meetings/<key>.webm?..."
  },
  "user": {
    "id": "63ede350b20526000f64376d",
    "name": "Jane Doe",
    "avatar": "https://myawesomeapp.com/images/avatar.png",
    "guest": false,
    "joined_at": "2021-01-01T09:00:00.000Z"
  },
  "room": {
    "id": "63ede350b20526000f64376b",
    "name": "eyeson room",
    "ready": true,
    "started_at": "2021-01-01T09:00:00.000Z",
    "shutdown": false,
    "sip": {
      ...
    },
    "guest_token": "gKsiVlrvkFyL3klk1wBHLlm3"
  }
}
```

```
DELETE /recordings/<recording_id>
  HEADERS Authorization
  RESPONSES 200 OK, 404 NOT FOUND
```

## Snapshot

This request creates a snapshot of the current meeting. Snapshots are saved in
Eyesons cloud storage and can be downloaded from there.

```
POST /rooms/<access_key>/snapshot
  RESPONSES 201 CREATED, 404 NOT FOUND, 410 GONE
```

```
GET /snapshots/<snapshot_id>
  HEADERS Authorization
  RESPONSES 200 OK, 404 NOT FOUND

DELETE /snapshots/<snapshot_id>
  HEADERS Authorization
  RESPONSES 200 OK, 404 NOT FOUND
```

Example Response
```
{
  "id": "63ede760f3e015000fbe1af8",
  "name": "1609491900",
  "links": {
    "download": "https://fs.eyeson.com/meetings/<key>.jpg?..."
  },
  "creator": {
    "id": "63ede350b20526000f64376d",
    "name": "Jane Doe",
    "avatar": "https://myawesomeapp.com/images/avatar.png",
    "guest": false,
    "joined_at": "2021-01-01T09:00:00.000Z"
  },
  "created_at": "2021-01-01T09:05:00.000Z"
  "room": {
    "id": "63ede350b20526000f64376b",
    "name": "eyeson room",
    "ready": true,
    "started_at": "2021-01-01T09:00:00.000Z",
    "shutdown": false,
    "sip": {
      ...
    },
    "guest_token": "gKsiVlrvkFyL3klk1wBHLlm3"
  }
}
```

## Broadcast

To connect an Eyeson room with a broadcast you have to provide a valid
streaming RTMP url.

```
POST /rooms/<access_key>/broadcasts # start broadcast
  RESPONSES 201 CREATED, 400 BAD REQUEST, 404 NOT FOUND, 405 METHOD NOT ALLOWED, 406 NOT ACCEPTABLE, 410 GONE
```

Parameters   | Type              | Description
------------ | ----------------- | ------------
stream\_url  | String (required) | Streaming URL.
player\_url  | String (optional) | Public URL to view the live video.

```
PUT /rooms/<access_key>/broadcasts/generic # update broadcast player_url
  RESPONSES 200 OK, 400 BAD REQUEST, 404 NOT FOUND, 410 GONE
```

Parameters   | Type              | Description
------------ | ----------------- | ------------
player\_url  | String (required) | Public URL to view the live video.

```
DELETE /rooms/<access_key>/broadcasts # stop broadcast
  RESPONSES 200 OK, 404 NOT FOUND, 410 GONE
```

## Layout

The meeting participants will be presented in an equally distributed tiled
video layout where Eyeson takes care to always update the stream depending on
the number of users. However in some cases you might want to assign specific
users to a video position. To switch back to auto layout you can send
layout `auto` with no further options.

The custom Eyeson podium layout can be set to one, two, four or nine
participants. This is controlled by the `users` parameter: Provide a user
identifier and the specific user will be placed on this position. Use an empty
string `""` to assign no-participant and keep a spot free. This free spots will
be filled if you choose the `auto` layout. Additionally you can choose to
activate voice detection that will replace the spots with participants that
have said something recently. If you choose layout `custom` the free spots will
not be filled and you can use them to show some background using the [media
inject](#content-integration-aka-layers) feature.

Besides layouts that are selected by the number of users there are some named
layouts that can be applied. Those will not provide equal distributed position
but show some participants in an expanded view.

Note that layouts are not available when using the [SFU] mode, so set the [room
configuration](#eyeson-room) properly or take care to have more than two
participants.

```
POST /rooms/<access_key>/layout
  RESPONSES 200 OK, 400 BAD REQUEST, 404 NOT FOUND, 405 METHOD NOT ALLOWED, 410 GONE
```

Parameters                 | Type               | Description
-------------------------- | -----------------  | ------------
layout                     | String (optional)  | Value 'auto' or 'custom'.
users                      | List (optional)    | List of podium user\_ids, a custom layout position identifier or an empty string for an empty spot.
voice\_activation          | Boolean (optional) | Fill empty spots by voice detected activation.
show\_names                | Boolean (optional) | Show display names in video. Default: true
name                       | String (optional)  | Use a named layout. Current layouts are: `one`, `two`, `four`, `six`, `nine`, and the presentation layouts with a single or two presenter and other users shown below or above `present-lower-3`, `present-upper-6`, `present-upper-right-9`, and `present-two-upper-6`.
audio\_insert              | String (optional)  | Show audio insert ('enabled', 'disabled' or 'audio\_only'). Default: audio\_only
audio\_insert\_position[x] | Number (optional)  | X position value of the audio insert.
audio\_insert\_position[y] | Number (optional)  | Y position value of the audio insert.


```sh
$ curl -X POST \
  -d "users[]=USER_ID_A" \
  -d "users[]=USER_ID_B" \
  -d "users[]=USER_ID_C" \
  -d "users[]=USER_ID_D" \
  "https://api.eyeson.team/rooms/<ACCESS_KEY>/layout"
```

## Content Integration aka Layers

Show any data content inside your video using the Eyeson layer service. There
are currently three ways to achieve this.

To show simple text message inserts you can use the insert parameter. You'd
listen for tweets in a separate service and display them using the tweet senders
avatar as an icon, name as title and the tweet as content.

For more complex data generate an image and either upload the image or provide
a public URL. For overlaying images use a transparent background.

Any Eyeson room video has a resolution of either **1280x960** pixels (960p in 
default) or 1280x720 pixels (HD in widescreen mode). Ensure any file uploaded 
is an alpha interlaced PNG image with a corresponding resolution to avoid any 
distortions.

When using layers you might want to disable the [SFU] mode that in
default [room configuration](#Eyeson-room) will transport individual streams
for single and two participants and not show layer media.

```
POST /rooms/<access_key>/layers # insert image or text message
  RESPONSES 201 CREATED, 400 BAD REQUEST, 404 NOT FOUND, 410 GONE
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
DELETE /rooms/<access_key>/layers/<layer_index> # clear layer, layer_index: -1 or 1
  RESPONSES 200 OK, 404 NOT FOUND, 410 GONE
```

## Playbacks

Besides image data you can playback videos. We currently limit it to media
files in webm (preferred) or mp4 format that have to be available through a
public URL. Note that we do not provide any kind of upload service for this
feature.

```
POST /rooms/<access_key>/playbacks # play a video
  RESPONSES 201 CREATED, 400 BAD REQUEST, 404 NOT FOUND, 410 GONE
```

Parameters               | Type              | Description
------------------------ | ----------------- | ------------
playback[audio]          | Boolean           | Play audio (default: false)
playback[play_id]        | String            | Choose an identifier, e.g. current timestamp or use a custom layout position identifier
playback[replacement_id] | String            | User-id of the participants video to be replaced
playback[url]            | String            | Hosted MP4/WEBM video file
playback[name]           | String            | Custom readable name for identification

The video will replace the current stream of a specific user. For sure you can
use the layout to set this user to fullscreen during the video playback and
switch back afterwards using the layout feature. As with layers ensure you
disable SFU mode.

If the playback has been started with `playback[play_id]`, it can be stopped
using the following request:

```
DELETE /rooms/<access_key>/playbacks/<play_id> # stop playback with play_id
  RESPONSES 200 OK, 404 NOT FOUND
```


## Register Webhooks

Register a webhook for any updates using one or multiple of the following
resource types comma separated: recording\_update, room\_update. Note that you
can register a single webhook, use the received response type to detect its
purpose. The webhook endpoint on your server requires to accept an HTTPS POST
request, the body of the request is provided in JSON format.
You can verify your requests using a SHA256 HMAC on the request body using your
API key, the corresponding hash is sent within header `X-Eyeson-Signature`.

```
POST /webhooks
  HEADERS Authorization
  RESPONSES 201 CREATED, 400 BAD REQUEST, 403 FORBIDDEN
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
  RESPONSES 200 OK, 403 FORBIDDEN
```

Example Response
```
{
  "id": "63ede98fb20526000f64378a",
  "types": [
    "room_update"
  ],
  "url": "https://myawesomeapp.com/meeting-webhook",
  "last_request_sent_at": "2021-01-01T09:00:00.000+00:00",
  "last_response_code": "201"
}
```

```
DELETE /webhooks/<webhook_id>
  HEADERS Authorization
  RESPONSES 204 NO CONTENT, 400 BAD REQUEST, 403 FORBIDDEN, 404 NOT FOUND
```

In order to get notified for new recordings in any room session, you can
register a webhook upfront, using your target location and the webhook type
`recording_update`. See the recording resource on details of the received JSON
document.

Example Webhook
```
{
  "timestamp": 1609493400,
  "type": "recording_update",
  "recording": {
    "id": "63ede57ff3e015000fbe1af5",
    "created_at": 1609491600,
    "duration": 1800,
    "links": {
      "self": "https://api.eyeson.team/recordings/63ede57ff3e015000fbe1af5",
      "download": "https://fs.eyeson.com/meetings/<key>.webm?..."
    },
    "user": {
      "id": "63ede350b20526000f64376d",
      "name": "Jane Doe",
      "avatar": "https://myawesomeapp.com/images/avatar.png",
      "guest": false,
      "joined_at": "2021-01-01T09:00:00.000Z"
    },
    "room": {
      "id": "63ede350b20526000f64376b",
      "name": "eyeson room",
      "ready": true,
      "started_at": "2021-01-01T09:00:00.000Z",
      "shutdown": false,
      "sip": {
        ...
      },
      "guest_token": "gKsiVlrvkFyL3klk1wBHLlm3"
    }
  }
}
```

If you want to build up a meeting history in your application, register a
webhook for `room_update` and track when receiving a room update where
`shutdown` attribute is `true`.

Example Webhook
```
{
  "timestamp": 1609493400,
  "type": "room_update",
  "room": {
    "id": "63ede350b20526000f64376b",
    "name": "eyeson room",
    "ready": false,
    "started_at": null,
    "shutdown": true,
    "sip": {
      ...
    }
  }
}
```

[chrome-browser]: https://www.google.com/chrome/index.html "Google Chrome Webbrowser"
[firefox-browser]: https://www.mozilla.org/firefox/ "Mozilla Firefox Webbrowser"
[SFU]: https://webrtcglossary.com/sfu/ "Selective Forwarding Unit"
