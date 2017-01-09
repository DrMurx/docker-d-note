docker-d-note
============

A lightweight docker container for [d-note](https://github.com/atoponce/d-note), a web application for self destructing notes written by Aaron Toponce.

Self destructing one-time notes are great for quickly exchanging passphrases, credit card numbers or similar data between two trusted parties, but without the overhead of sending a message through a properly end-to-end encrypted communication channel and deleting it afterwards.

You can also use d-note to pass such data from any computer to your mobile device.

> Note: This is not intend to replace proper encryption. You should still setup GPG to for your emails and use a secure chat client like Threema, Telegram or What's App.


Usage
-----

The UI of d-note is pretty straightforward:

1. Type your secret message in the form, set an optional password and submit.
2. After a few seconds of intensive calculation, the note is securely stored in the server and you'll be shown a link.
3. Forward the link you can forward to the recipient, along with the password if you set one. d-note optionally displays the link as QR code which you can pick up with your mobile.
4. When the recipient clicks the link and enters the password, the message is displayed.
5. At the same time, the message is removed from the server and can't be displayed again.

> Note: If you send the d-note link through a messenger which displays a link preview, it will consume the message and make it unusable for you. A filter by `User-Agent` on your webserver might help to block such requests.


Installation & Configuration
----------------------------

Basically just run the container. It uses a volume mounted to `/dnote` for the stored notes and exposes the d-note app via HTTP on port 8080:

```
docker run --detach --volume /srv/dnote:/dnote --publish 8080:8080 --name dnote drmurx/docker-d-note
```

The volume contains the notes database and a configuration file with the encryption salts. The salt is part of the decryption key, so if you delete the dconfig.py, your stored notes are lost.

> Note: This image **does not** provide any native encryption on the communication layer. You have to put it behind a reverse proxy with HTTPS termination. I highly recommend Jason Wilder's [nginx-proxy](https://github.com/jwilder/nginx-proxy) with the [Let's Encrypt companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion).

You can pass in the environment variable `APPLICATION_ROOT` (defaults to `/`) to the `docker run` command if you prefer to host d-note in a subdirectory instead of the webroot.

Furthermore, you can tune d-note's server side concurrency using the environment variables `PROCESSES` and `THREADS` to control how the app scales. Please refer to the `uwsgi` documentation if you really need to increase your throughput.


Credits
-------

Copyright (c) 2017 Jan Kunzmann <jan-github@phobia.de>, see [LICENSE](LICENSE).
