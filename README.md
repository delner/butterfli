![Butterfli](http://cdn.delner.com/www/images/projects/butterfli/logo_small.svg)
==========

[![Build Status](https://travis-ci.org/delner/butterfli.svg?branch=master)](https://travis-ci.org/delner/butterfli) ![Gem Version](https://badge.fury.io/rb/butterfli.svg)
###### *For Ruby 1.9.3, 2.0.0, 2.1.0*

### Introduction

`butterfli` is a gem for developers who want quick-access to data from popular APIs. It takes data from well-known endpoints (e.g. Instagram, Twitter, etc.) and converts them into a common container, known as a `Story`.

Currently supported providers include:
 - [Instagram](https://github.com/delner/butterfli-instagram)

Future support for providers include:
 - Facebook
 - Twitter
 - Google+
 - Vine
 - Foursquare

It is the base gem for the full *Butterfli* suite:

**Core gems**:
 - [`butterfli`](https://github.com/delner/butterfli): Core gem for Butterfli suite.
 - [`butterfli-rails`](https://github.com/delner/butterfli-rails): Core gem for Rails-engine based API interactions.

**Extension gems**:
 - [`butterfli-instagram`](https://github.com/delner/butterfli-instagram): Adds Instagram data to the Butterfli suite.
 - [`butterfli-instagram-rails`](https://github.com/delner/butterfli-instagram-rails): Adds Rails API endpoints for realtime-subscriptions.

### Installation

Install the gem via `gem install butterfli`

### Usage

The base Butterfli gem is for developers who want to extend the Butterfli suite. To use the gem to access some popular APIs, check out the *Extension gems* list above.

### Changelog

#### Version 0.0.1

 - Initial version of Butterfli (defines Story common container)
