Eye Street's Rails Tools
========================

This is a collection of rake tasks that we use on multiple Rails projects.  Right now it consists of two sets of tasks:

1. Heroku deploy tasks

2. Change log generation via Pivotal Tracker

Installation
------------
Since this is a (for now) non-published gem hosted privately on our GitHub account you need to add this line to your Gemfile:

    gem 'rails_tools', :git => 'https://github.com/eyestreet/rails_tools'

And when you run `bundle install` you'll need to enter your GitHub username and password.

Then you need to add this to your Rakefile

    require 'rails_tools/tasks'

If you have `require 'tasks/rails'` in the file, it must go **below** that or you will get the error

    undefined method `==' for class `ActiveSupport::BasicObject'

Something having to do with what or how the Pivotal Tracker gem loads ActiveSupport::BasicObject.

Installation instructions might be a little different for Rails 3.  I haven't tried it yet.  Please update this file if you do.

Heroku Deploy Tasks
-------------------

These tasks are used to make deploying to a Heroku project easier.  They were taken from somewhere on the internet and modified to suit our needs.

The ones you'll use most commonly are:

* rails_tools:staging_migrations

This task deploys the branch specified in the ENV var BRANCH (or develop by default) to the Heroku app specified in the ENV var APP and then runs your DB migrations.

* rails_tools:production_migrations

This task deploys the branch specified in the ENV var BRANCH (or master by default) to the Heroku app specified in the ENV var APP and then runs your DB migrations.


NOTE: The *_rollback tasks have never been tested by us.


Change Log Generation
---------------------

This task (it's only one task right now) is used to generate a quick change log by matching the Pivotal Tracker story IDs in your git commit messages to the data in your PT project.

* rails_tools:changelog

You must specify two fields via ENV vars:

**CLIENT_TOKEN**: the PT client token for a user with access to the project

**PROJECT_ID**: the PT project ID you're generating the changelog for.  You can get this from the project's URL (https://www.pivotaltracker.com/projects/11111)

Then you must pass in a required start rev[1] and an optional end rev[1] (default HEAD).  Remember, this is rake so parameters are in quotes and comma separated.

Examples:

Generate the change log from tag 3.0.1 to HEAD:

    $ CLIENT_TOKEN=12345667 PROJECT_ID=11111 rake rails_tools:changelog['3.0.1']


Generate the change log from sha 65b4867a to b01c5b6e:

    $ CLIENT_TOKEN=12345667 PROJECT_ID=11111 rake rails_tools:changelog['65b4867a,b01c5b6e']


[1] A git rev can be a tag, sha, refname.  For more information see this - [http://www.kernel.org/pub/software/scm/git/docs/gitrevisions.html](http://www.kernel.org/pub/software/scm/git/docs/gitrevisions.html)