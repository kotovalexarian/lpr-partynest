Partynest
=========

[![Build Status](https://travis-ci.org/libertarian-party/partynest.svg?branch=master)](https://travis-ci.org/libertarian-party/partynest)
[![Coverage Status](https://coveralls.io/repos/github/libertarian-party/partynest/badge.svg?branch=master)](https://coveralls.io/github/libertarian-party/partynest?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/974d97f03895453189e1/maintainability)](https://codeclimate.com/github/libertarian-party/partynest/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/974d97f03895453189e1/test_coverage)](https://codeclimate.com/github/libertarian-party/partynest/test_coverage)
[![Inline docs](http://inch-ci.org/github/libertarian-party/partynest.svg?branch=master)](http://inch-ci.org/github/libertarian-party/partynest)

A web application to manage political party members and supporters.



Table of contents
-----------------

* [Overview](#partynest)
* [Table of contents](#table-of-contents)
* [Deploy](#deploy)



Deploy
------

Tested with **Ubuntu Server 18.04 LTS**.

### System packages

* `build-essential`
* `bundler`
* `liblzma-dev`
* `libpq-dev`
* `nodejs`
* `npm`
* `patch`
* `ruby`
* `ruby-dev`
* `rubygems-integration`
* `zlib1g-dev`

### Steps

* Create directory `/var/www/partynest/` writable by deploy user
* Copy file `config/master.key` to `/var/www/partynest/shared/config/`
* Create PostgreSQL role `partynest` with password `password`
* Create PostgreSQL database `partynest_production` owned by `partynest`

### Example systemd services

Replace `user` with the name of user and `group` with the name of group
which you want an application to run as.

#### Web server

```
[Unit]
After=syslog.target network.target
Description=Partynest web server

[Service]
ExecStart=/usr/bin/bundle exec rails server --environment production
Group=group
Restart=on-failure
RestartSec=1
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=partynest-web
Type=simple
User=user
WorkingDirectory=/var/www/partynest/current

[Install]
WantedBy=multi-user.target
```

#### Job processing

```
[Unit]
After=syslog.target network.target
Description=Partynest job processing

[Service]
ExecStart=/usr/bin/bundle exec sidekiq --environment production
Group=group
Restart=on-failure
RestartSec=1
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=partynest-worker
Type=simple
User=user
WorkingDirectory=/var/www/partynest/current

[Install]
WantedBy=multi-user.target
```
