# General
This serves as the foundational setup for WordPress development.

## Apps
The Docker container comes with preinstalled and configured tools:

* Composer
* Node
* WP-CLI
* Xdebug
* Git
* MailHog
* SSL

## Before Build
Before initiating the build process, ensure you have the SSL certificates. If not, copy the certificates to the `./srv/ssl/` directory. The public key must be named `cert.pem`, and the private key must be named `key.pem`. Additionally, you need to set up routing for your site.

### Windows
As I am working on Windows, I will guide you on the process specific to this platform.

1. Generate certificates using [mkcert](https://github.com/FiloSottile/mkcert/):
   ```bash
   mkcert -key-file ./srv/ssl/key.pem -cert-file ./srv/ssl/cert.pem wordpress.local *.wordpress.local
   ```
   This command generates the necessary certificate files in the `ssl` directory for the `wordpress.local` domain.

2. Add the domain to the Hosts file:
   ```
   127.0.0.1 wordpress.local
   ```

3. Set up port forwarding. You can use [netsh portproxy](https://learn.microsoft.com/en-us/windows-server/networking/technologies/netsh/netsh-interface-portproxy) or a tool like [PortProxy GUI](https://github.com/zmjack/PortProxyGUI). Redirect the domain to the assigned port.

## Configuration
The configuration is locate in `.env` file.
The startup.sh define what do on first installation
