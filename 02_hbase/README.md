# HBase on Docker

NOTE: The docker-compose files don't work with the latest versions of Windows 10, due to an isue documented on [Stack Overflow](https://stackoverflow.com/questions/54181219/windows-cant-bind-to-port-above-49690).

A reasonable fix is to follow the details there and edit the range of dynamic ports available to Win10.  Changing the ports naively in the Docker Compose files don't Just Work, likely due to assumptions made in the containers
