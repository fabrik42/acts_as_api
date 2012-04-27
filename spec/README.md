# Spec folder intro

## Running specs

Every ORM has a rake task. Run `rake -T` to see them all.

`rake spec:all` will run all spec suites in a row.

`rake spec:#{orm_name}` will run the spec suite for a specific ORM.

## Working with the specs

acts_as_api can be used with lots of different configurations, depending e.g. on the ORM (ActiveRecord, Mongoid, vanilla ruby) or the way the content is rendered (usual Rails controller, vs. Responder).

A goal of the lib is to stay consistent in its behaviour over these different configurations, so it won't get in your way, once you change other parts of your application.

To achieve this goal and because of the need to keep the specs as DRY as possible, the following spec setup was created:

### A shared engine

In order to keep the spec suite DRY it uses a Rails engine, available at `./shared_engine`.

It contains the controllers that are re-used by the ORM-specific Rails apps and some mixins that can be shared over the models of different ORMs.

### Dummy Rails apps

There used to be one Rails app that contained all supported ORMs. But multiple times this setup veiled problems e.g. with ORM-specific dependencies.

Now there are multiple Rails apps, one for every supported ORM: `./active_record_dummy` and `./mongoid_dummy`.

These are very simple apps, basically just clicked together on [railswizard.org](http://railswizard.org).

They contain **no controllers** to be tested, just models that match the tested ones.

### Adding a dummy Rails app

* Create a new Rails app in the folder `./spec/#{orm_name}_dummy`.

* Create to Models used in the spec (`User, Profile, Untouched, Task`).

* Include `SharedEngine::UserTemplate` in your `User` model.

* Add `mount SharedEngine::Engine => "/shared", :as => "shared"` to your `routes.rb`

* Add the following lines to your Gemfile:

```ruby
gem 'shared_engine', :path => '../shared_engine'
gem 'acts_as_api', :path => '../../'
```

* Add your dummy app to the `Rakefile` in the root folder by adding it to the `supported_orms` array.


If you have to do some special setup (e.g. creating a schema) you can do this in `./spec_helper.rb`.
