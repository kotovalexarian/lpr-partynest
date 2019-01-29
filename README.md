Partynest
=========

[![Build Status](https://travis-ci.org/libertarian-party/partynest.svg?branch=master)](https://travis-ci.org/libertarian-party/partynest)
[![Coverage Status](https://coveralls.io/repos/github/libertarian-party/partynest/badge.svg?branch=master)](https://coveralls.io/github/libertarian-party/partynest?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/974d97f03895453189e1/maintainability)](https://codeclimate.com/github/libertarian-party/partynest/maintainability)
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
* `gnupg2`
* `liblzma-dev`
* `libpq-dev`
* `nodejs`
* `npm`
* `patch`
* `zlib1g-dev`

### Ruby installation

Install Ruby system-wide with [RVM](https://rvm.io):

```
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | sudo bash -s stable
```

Replace `user` with the name of your current user:

```
sudo usermod -a -G rvm user
```

Log out from system, then log in again. Install Ruby and Bundler:

```
rvm install ruby-2.6.0
rvm use ruby-2.6.0
gem install bundler
```

### Steps

* Create directory `/opt/partynest/` writable by deploy user
* Copy file `config/master.key` to `/opt/partynest/shared/config/`
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
ExecStart=/usr/local/rvm/bin/rvm default do bundle exec puma --environment production
Group=group
Restart=always
RestartSec=1
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=partynest-web
Type=simple
User=user
WorkingDirectory=/opt/partynest/current

[Install]
WantedBy=multi-user.target
```

#### Job processing

```
[Unit]
After=syslog.target network.target
Description=Partynest job processing

[Service]
ExecStart=/usr/local/rvm/bin/rvm default do bundle exec sidekiq --environment production
Group=group
Restart=always
RestartSec=1
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=partynest-worker
Type=simple
User=user
WorkingDirectory=/opt/partynest/current

[Install]
WantedBy=multi-user.target
```
