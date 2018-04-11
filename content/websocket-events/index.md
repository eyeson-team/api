---
title: "Websocket Events"
date: 2017-08-04T10:01:35+02:00
draft: false
weight: 30
---

The websocket connection endpoint is received in the response of the room
creation. Provide the `access_key` in order to authenticate the user.

## Uploaded File Conversion Progress

Progress level is received as floating point number between `0.0` and `1.0`.

```json
{
  "type": "files_update",
  "files": [
    {
      "id": "59393f902a3d24150b2ae7bd",
      "name": "presentation.pdf",
      "type": "application/pdf",
      "converted": false,
      "conversion_progress": 0.42,
      "failed": false,
      "links": {
        "self": "https://api.eyeson.team/files/59393f902a3d24150b2ae7bd",
        "slides": [],
        "thumbnails": [],
        "download": ""
      }
    },
    // ...
  ]
}
```


## Slide Update

Receive a presentation slide URL. When a presentation stops an empty string is
sent.

```json
{
  "type": "slide",
  "slide": "https://example.com/page-42.png"
}
```

