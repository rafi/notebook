---
title: req8 - Postman Alternative
date: '2017-11-18'
published: true
categories: ['security']
search:
  keywords: ['passwords', 'secrets']
---

Postman have been in my chest-tool for many years now, but I can't say I like
it much; actually, at all. I tested many alternatives, terminal CLI tools and
UI applications, but none have met the basic requirements I had:

1. Fast reproducible HTTP requests.
1. Version-controlled, consumable, request libraries, per-project.

<!-- more -->

*****

## Library Mess

My Postman libraries are a mess. I have multiple computers, so each instance of
Postman has its own convoluted state of libraries.

I often share libraries with coworkers and friends by importing and exporting.
This creates another layer of duplication because *backup/restore !=
synchronization*.

How come *I* need to keep Postman's state? I want **projects** to do it.

![Postman folders](./img/postman-library.png 'coworkers synchronizing results in duplicates.')

## Cloud Synchronization (No thanks)

Each computer of mine has a different state in Postman. I do not have the
“Syncing” feature enabled, I choose not to use their cloud service because all I
really want is a way to commit these request libraries into a version-control
like Git.

## Cumbersome Presets

It's a wonderful feature to pre-set and parameterize headers, URLs and other
values within Postman. But managing them is a cumbersome chore which can be much
easier if there was a simple way to edit all of them at once.

## Bloat

I don't like the bloat Postman adds each time I open it. Recently due to Google
deprecating Chrome apps, I caught a glimpse of its size, ~250mb.

*****

## **Enter req8…**

[req8](https://github.com/rafi/req8) is a tiny Python CLI utility, in less than
300 LoC it allows the user to reproduce pre-made HTTP requests from libraries
you define with YAML. It also features visual selections if you're too lazy to
pass CLI arguments.

It supports presets such as environment and headers, and easy parameterization
of everything you define.

## Environments

Editing presets in a single YAML file makes management clear and concise.

![req8 environments](./img/req8-environments.png 'Easy environment management')

## Headers

With header presets, you can define wide scoped headers templated with
parameters.

![req8 headers](./img/req8-headers.png 'Custom authentication example via headers')

## Resources

Resource are simply defined as keys to `resources` and headers are set as a
resource-wide scope. `url` can be templated with parameters. `body` can include
intricate JSON structures.

![req8 resources](./img/req8-resources.png 'Simple GET request and POST JSON request')

## Demo

![req8 demo](./img/req8-demo.gif 'Reproduce HTTP requests with “req8”')

## Closing Notes

While Postman eases development for many, it doesn't adhere to principles I'm
looking in utilities I use: Version-controlled and plain-text configuration.
[req8](https://github.com/rafi/req8) fulfills these priorities, and offer much
more. [Try it](https://github.com/rafi/req8) out!

Thanks for reading, hope you enjoy this tool as much as I do.
