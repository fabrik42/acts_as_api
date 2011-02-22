# The built-in XML/JSON support of Rails is great but:
# You surely don’t want to expose your models always with all attributes.
#
# acts_as_api enriches the models and controllers of your app in a rails-like way so you can easily determine how your API responses should look like.

### Features
# * DRY templates for your api responses
# * Easy but very flexible syntax for defining the templates
# * XML, JSON and JSON-P support out of the  box, easy to extend
# * Minimal dependecies (you can also use it without Rails)
# * Does not rely on ActiveRecord (can be used with other ORMs like Mongoid)
# * Supports multiple api rendering templates for a models. This is especially useful for API versioning or for example for private vs. public access points to a user’s profile.

# ***

### Rails 3.0.x Quickstart

# Add to gemfile
gem 'acts_as_api'

# Update your bundle
bundle install

#### Setting up your Model

# Given you have a model `User`.
# If you only want to expose the `first_name` and `last_name` attribute of a user via your api, you would do something like this:

# Within your model:
#
# First you activate acts_as_api for your model by calling `acts_as_api`.
#
# Then you define an api template to render the model with `api_accessible`.
class User < ActiveRecord::Base

  acts_as_api

  api_accessible :name_only do |template|
    template.add :first_name
    template.add :last_name
  end

end

# An API template with the name `:name_only` was created.
#
# See below how to use it in the controller:

#### Setting up your Controller



# Now you just have to exchange the `render` method in your controller for the `render_for_api` method.
class UsersController < ApplicationController
  
  def index
    @users = User.all
    # Note that it's wise to add a `root` param when rendering lists.
    respond_to do |format|
      format.xml  { render_for_api :name_only, :xml => @users, :root => :users  }
      format.json { render_for_api :name_only, :json => @users, :root => :users }
    end
  end
  
  def show
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.xml  { render_for_api :name_only, :xml  => @user }
      format.json { render_for_api :name_only, :json => @user }
    end
  end
  
end

#### That's it!

# Try it. The JSON response of #show should now look like this:
#
# Other attributes of the model like `created_at` or `updated_at` won’t be included 
# because they were not listed by `api_accessible` in the model.
{
  "user": {
    "first_name": "John",
    "last_name":  "Doe"    
  }
}

# ***

### But wait! ... there's more
#
# Often the pure rendering of database values is just not enough, so acts_as_api
# provides you some tools to customize your API responses.

#### What can I include in my responses?
#
# You can do basically anything:
# 
# * Include attributes and all other kinds of methods of your model
# * Include child associations (if they also act_as_api this will be considered)
# * Include lambdas and Procs
# * Call methods of a parent association
# * Call scopes of your model or child associations
# * Rename attributes, methods, associations
# * Create your own hierarchies
#
# You can find advanced examples in the [Github Wiki][wi]
#
#  [wi]: https://github.com/fabrik42/acts_as_api/wiki/

# ***

### Links
# * Check out the [source code on Github][so]
# * For more usage examples visit the [wiki][wi]
# * Found a bug or do you have a feature request? [issue tracker][to]
# * [Docs][do]
#
# [so]: https://github.com/fabrik42/acts_as_api/
# [wi]: https://github.com/fabrik42/acts_as_api/wiki/
# [to]: https://github.com/fabrik42/acts_as_api/issues
# [do]: http://rdoc.info/github/fabrik42/acts_as_api









