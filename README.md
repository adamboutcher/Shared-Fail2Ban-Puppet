# Shared Fail2Ban Puppet Module

## Project Outline

This project aims to install the [Shared Fail2Ban](https://github.com/bulgemonkey/Shared-Fail2Ban/) Client (host) and API Server with an easy to implement and read Puppet module.

Hopefully this won't significantly clash with other modules from [PuppetForge](https://forge.puppet.com/) but we cannot gurantee it.

This is a sanitised version of an internal module but we do welcome and issues or PRs that may fix any significant issues or add simple features.

## Project Staticness

This module contains a static version of the [Shared Fail2Ban](https://github.com/bulgemonkey/Shared-Fail2Ban/) Project. As such there may be bugs, that have since been fixed, we suggest updating the files in the files/shared directory with the latest.

## Project Credits

The authors of this project are currently **[Adam Boutcher](https://www.aboutcher.co.uk)** and **Paul Clark**.

This has been developed at the Durham [GridPP](https://gridpp.ac.uk) Site (*UKI-SCOTGRID-DURHAM*) and the [Institute for Particle Physics Phenomenology](https://www.ippp.dur.ac.uk), [Durham University](https://dur.ac.uk).

Related works and partial works have been presented too the [WLCG](https://wlcg.web.cern.ch/) Security Operations Centre at [Cern](https://home.cern/)

----

## Guide

### Installation - Puppet
1. Create a new directory in your module directory named "fail2ban".
2. Copy this repo (or git clone) into the fail2ban directory.
3. Update your environment (if using foreman).
4. Ensure you have the [mysql module from PuppetForge](https://forge.puppet.com/puppetlabs/mysql) and [SELinux module from PuppetForge](https://forge.puppet.com/modules/puppet/selinux) installed as the server depends on them.

### Server - DB
1. Update your database details under fail2ban::server
2. Add a user for each client intending to connect
3. Only apply the class fail2ban::server to your server

### Server - API (Recommended)
1. Update your database details under fail2ban::server and files/shared_server/api_cfg.py - Ensure the api.wsgi file is correct for your distro (eg Python 3.6 or 3.9 etc)
2. Only apply the class fail2ban::server::api to your API server
3. We highly recommend enabling SSL, LetsEncrypt/Certbot is simple and easy - You will need to uncomment the last few lines in (files/shared_server/http_api.conf) to force redirects to SSL

### Client / Host
1. Update your database details if using sql or api token for api on the server
2. Update your database details if using sql or api token for the api in the client (manifests/params.pp)
3. Only apply the class fail2ban::shared to your clients

----

## Warnings and Notices

### Notice - Inherited Issues

All warngins and notices mentioned in the parent project apply to this.

### Warning - Not for Production

In no way do we endorse the current scripts as production ready (although they are currently deployed in some producation environments), we cannot gurantee their safety, especially as these are aimed for Cyber Security deployments.

Please read and understand before you deploy into your environments.

### Notice - CentOS

This module is aimed at deploying onto CentOS 7, EL8 and EL9. Other distros probably wont work.

----

## License

Released under the GPLv3 related works may be different.
