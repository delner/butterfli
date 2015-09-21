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

### Features

Butterfli has several core components which support data retrieval and processing tasks. Some of these components can be configured directly to change Butterfli's behavior, and others are only for use by extension gems explicitly.

#### Jobs

Most data retrieval and processing can be performed in atomic units of work. Butterfli segments these operations into `Job`s, which have specific input and output. All jobs inherit from `Butterfli::Jobs::Job`, respond to `#work`, and return output.

```ruby
job = Butterfli::Jobs::Job.new
job.work
```

The most common job type is the `Butterfli::Jobs::StoryJob`, which returns a collection of `Butterfli::Data::Story`. It will also send the stories it retrieves to any configured *writers*: an endpoint like a database, cache, or event handler which accepts `Butterfli::Jobs::StoryJob`. (See the **Writing** section for more details.)

#### Asynchronous processing

Jobs can also be processed using the Butterfli processor (disabled by default.) When enabled, this processor can enqueue a `Butterfli::Jobs::StoryJob` and call `#work` on them asynchronously.

```ruby
Butterfli.processor.enqueue(job)
```

This can be especially useful for expensive data retrieval or improving application responsiveness. The back-end of the processor can be configured to use a variety of different strategies for processing jobs.

##### Monolith processor

The in-application processor provided by Butterfli is called the *monolith processor*. It is a simple thread pool which will run jobs within the application that queues them. This mode is useful for simple, lightweight deployments that do not require much processing power, or multiple nodes.

To setup the monolith processor, add the following to the Butterfli configuration:

```ruby
Butterfli.configure do |config|
  config.processor :monolith do |processor|
    # Defines what a worker should do after completing a batch of jobs.
    #  - sleep: puts the worker to sleep for a fixed period of time.
    #  - block: sleeps the worker indefinitely until a job is queued, or its signaled to wake up.
    #  (Default: :block)
    processor.after_work = :sleep
    # Number of threads to use. (Default: 1)
    processor.num_workers = 1
    # If after_work = :sleep, interval to sleep for, in seconds. (Default: 5)
    processor.sleep_for = 5
  end
end
```

Then at the bottom of your configuration file, add the following:

```ruby
# Starts the monolith processor worker threads
Butterfli.processor.adapter.start
```

You can also listen to specific work events for monitoring or logging purposes:

```ruby
Butterfli.configure do |config|
  config.processor :monolith do |processor|
    # Invoked for individual jobs
    processor.on_job_started do |job|
    end
    processor.on_job_completed do |job, result|
    end
    processor.on_job_error do |job, error|
    end

    # Invoked for a batch of jobs
    processor.on_work_started do
    end
    processor.on_work_completed do |result|
    end
    processor.on_work_error do |error|
    end
    
    # Invoked if the worker inexplicably dies
    processor.on_worker_death do |error|
    end
  end
end
```

#### Writing

A place where output from Butterfli is sent is known as a *writer*: an endpoint to which data can be written. It could be a database, cache, file, function, API, etc...

Each writer listens on *channels*. A channel expects a specific kind of input, and writes to its destination accordingly. The default channel is `:stories`, which expects a collection of `Butterfli::Data::Story`.

An example of writing stories:

```ruby
# Does not provide error handling, and might raise errors
Butterfli.writers.each { |w| w.write(:stories, stories) }
# Provides error handling for any StandardError
Butterfli.writers.each { |w| w.write_with_error_handling(:stories, stories) }
```

The `#write_with_error_handling` allows the developer to handle write errors via an event handler.

To handle these errors, add the following to your Butterfli configuration:

```ruby
Butterfli.configure do |config|
  config.writer :example do |writer|
    writer.on_write_error do |error, stories|
      # Custom error handling code here.
    end
  end
end
```

##### Syndication writer

You can push events directly through Butterfli's event-handling system to other parts of application. (See **Syndication** for more details.)

To write stories to these subscribers, add the following to the Butterfli configuration:

```ruby
Butterfli.configure do |config|
  config.writer :syndicate
end
```

#### Caching

Some components in Butterfli require caching to operate (particularly for pagination and throttling features.) It provides a cache-layer from which simple values can be read and written.

Some basic operations include:

```ruby
Butterfli.cache.read(key)
Butterfli.cache.write(key, value)
Butterfli.cache.fetch(key, value)
Butterfli.cache.delete(key)
```

The storage mechanism for this cache is configurable for your application's needs.

##### Memory cache

The default cache is an in-memory `Hash` for all values. This works well for simple applications that do not require much memory, or multiple nodes.

You need not set any configuration to use this cache. However, you can explicitly enable it in the Butterfli configuration using:

```ruby
Butterfli.configure do |config|
  config.cache :memory
end
```

#### Syndication

Butterfli provides a simple, in-application event-handling system called *syndication*. It allows any part of the application to listen for new stories.

In your application, you can listen for stories using `#subscribe`, to register an event handler:
```ruby
Butterfli.subscribe do |stories|
  puts "I received #{stories.length} stories!"
end
```

The above block will be called when any kind of story is received. To send stories to subscribers, you can invoke:

```ruby
Butterfli.syndicate(stories)
```

You can also subscribe to specific types of stories. Using `to:` allows you to specify where the story came from (e.g. `:instagram`) and `type:` allows you to specify what kind of story it should be.
```ruby
Butterfli.subscribe to: :instagram, type: :image do |stories|
  puts "I received #{stories.length} image stories!"
end
```

#### Regulation

*(TODO)*

### Changelog

#### Version 0.0.1

 - Initial version of Butterfli (defines Story common container)
