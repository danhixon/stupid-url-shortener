Stupid Url Shortener
============

This is a stupid url shortener written in Sinatra.

Basically this will let you shorten urls to one host and only 
one type of resource. The resources must be uniquely identifiable
by a numeric value.

Stupid, right?

Here is an exampe from twitter:

    http://twitter.com/#!/whoever/status/68432368452636674

becomes:

    http://localhost:9393/53Q6DmISDS

Why?
-------------

Well, that was the requirement: Short urls for one type of resource.

Its weird but _kind of cool_ because it doesn't use a database.

How does it work?
-------------

Base62 encoding.  You take a numeric idenfier (base 10) and convert that 
into base 62 (0-9,a-z,A-z).

You set up the redirect host and the resource path with environment variables
and it exposes a a couple apis that accept the resource id:

    get /api/url/:id => returns short url
    get /api/short_id/:id => returns shortened id which can be appended to host

Is that really all?
--------------

Almost. It is pretty stupid but you can mess with a hash called PATH_MAPS.

This lets you configure other short urls to static pages like about:

    PATH_MAPS = {
      '' => '',
      'a' => 'about',
      'biz' => 'business'
    }

/a would redirect to:
redirect_host/about

/biz would redirect to:
redirect_host/business

Installation
-------------

    git clone https://github.com/danhixon/stupid-url-shortener.git
    cd stupid-url-shortener
    bundle install
    bundle exec shotgun config.ru --server thin -o 0.0.0.0

Heroku Ready
-------------

    heroku create my-stupid-url-shortener
    git push heroku master

License
-------------
Stupid Url Shortener is Copyright © 2011 Dan Hixon. It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.