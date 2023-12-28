# launchservicesdos

This is the code to crash the launchservicesd, it does so by flooding the service using `xpc_connection_send_message` when the launchservicesd wants to send the reply effectively crashing the service. Crashing `launchservicesd` renders a lot of macOS functionality useless, for example you can try going back to Desktop and click on any previously opened app and it will just close and in crashes also can be seen that it has indeed crashed. It is worth to point out that this does not only applies to the `launchservicesd`, I believe this is present everywhere.

Compile: `gcc main.m -o dos -framework Foundation`

Run: `./dos`
