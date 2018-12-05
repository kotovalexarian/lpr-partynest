Partynest
=========

[![Build Status](https://travis-ci.org/libertarian-party/partynest.svg?branch=master)](https://travis-ci.org/libertarian-party/partynest)
[![Coverage Status](https://coveralls.io/repos/github/libertarian-party/partynest/badge.svg)](https://coveralls.io/github/libertarian-party/partynest)
[![Maintainability](https://api.codeclimate.com/v1/badges/974d97f03895453189e1/maintainability)](https://codeclimate.com/github/libertarian-party/partynest/maintainability)
[![Inline docs](http://inch-ci.org/github/libertarian-party/partynest.svg?branch=master)](http://inch-ci.org/github/libertarian-party/partynest)



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

### Example systemd service

Replace `user` with the name of user which you want an application to run with.

```
[Unit]
After=network.target
Description=Partynest web server

[Service]
ExecStart=/usr/bin/bundle exec rails server --environment production
Restart=always
Type=simple
User=user
WorkingDirectory=/var/www/partynest/current

[Install]
WantedBy=multi-user.target
```
