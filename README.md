Spatio
======

About
-----
IT IS HEAVILY WORK IN PROGRESS.

Spatio is about to become a spatial-aware web service for a University Project. More Infos later.

Deployment
----------

Until now, just a converter/reader for aggregating data (not even persisted in a database yet) for CSV and RSS exist. See demo_app.rb for implementation details


To run, have ruby 1.9 installed and type:
```
$> gem install bundler
$> bundle install
$> ruby demo_app.rb
```

There you can see the contents of the "stuff" variables by calling ```stuff``` on the pry console. Type ```exit``` to leave the breakpoint (that's "continue" in other debuggers)  or ```!!!``` to quit.
