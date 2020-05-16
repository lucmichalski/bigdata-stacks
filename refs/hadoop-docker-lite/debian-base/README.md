- Create base image with Debian linux distro 
- Install essential linux packages
- Install Open JDK 7. All hadoop images should extend this one.


Building the image
----
- ``docker build -t pkeropen3/debian-base .``

Version
---
- Debian linux: 8.3 (jessie)
- Java: Open JDK 7 

