# Upgrading a Refinery app to Refinery3, Rails 4.2#

## Remove old values from config files ##
1. DELETE config.active_record.whitelist_attributes
2. DELETE config.active_record.mass_assignment_sanitizer
3. DELETE config.active_record.auto_explain_threshold_in_seconds
4. CHANGE config.serve_static_assets  TO config.serve_static_files
5. SET config.eager_load TO false (dev and test), true (production)

## Add secrets.yml ##
See [the ruby upgrade guide](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html) for exact details

## In your models and controllers ##
1. Remove `attr_accessible` statements in your models.
Control of which model attributes can be updated has moved from the model to the controller. 
This feature is known as 'Strong Parameters'. 

2. Add the attributes as strong parameters in your controllers

####Example
**Before**
````ruby
#app/models/person.rb
...
attr_accessible :name, :title
...
````

**After**
````ruby
#app/controllers/people_controller.rb

def new
  @person = Person.new(new_person_params)
....

def update
  if @person.update(person_params)
  etc
...
protected

def new_person_params
  params.require(:person).permit(:name)
end

def person_params
  params.require(:person).permit(:name, :title)
end
````

*Note: different actions can permit different sets of attributes, or all actions can share a single set of permitted attributes.
In the example above the `create` action can only set the person's name, while the `update` action can set the name and title.*

## In Engines and Extensions ##

**In admin controllers**

If your app or extension uses Refinery's crudify you must define a strong parameters method, as *crudify* will call it (whether you need it nor not).
It can be a no-op, thus:

````ruby
def mymodel_params
end
````

** No more dashboard **

The Refinery dashboard has gone. 

From `engine.db` remove the code which linked to the dashboard and avoid the deprecation notice.
````ruby
  plugin.activity = {...}
````


** FriendlyId Changes **

In order to continue allowing `.find(id)` to work:

````ruby
friendly_id :title, use: :slugged
````
needs to become:
````ruby
friendly_id :title, use: [:slugged, :finders]
````

There are also some other major changes in friendly_id: https://github.com/norman/friendly_id


## Refinery Upgrade ##
run  `rails generate refinery:cms --update`

*(this will run rake db:migrate and rake db:seed)*

### If you are using Refinerycms-blog ###
run `rake acts_as_taggable_on_engine:install:migrations`


## Check files that you have over-ridden ##
Check your app for any Refinery files that you may have over-ridden.
Compare them to the new Refinery files
* Do you still need to override them?
* Are there changes you need to include in your copy of the file?
* Is there another way of making your change without overriding? 

Making changes to Refinery's default behavour using presenters and decorators will make future upgrades easier as your changes are separate from Refinery itself. 


## Refinery::Search changes
In application.rb DELETE

````ruby
config.to_prepare do
  Refinery.searchable_models = Refinery::Page
end
````

CREATE config/initializers/refinery/search.rb with an entry similar to the following
````ruby
#config/initializers/refinery/search.rb
Refinery::Search.configure do |config|
  config.enable_for = ['Refinery::Page']
end
````

The search route which was `refinery.search_path` is now `refinery.search_root_path`
More information in [refinerycms-search documentation](https://github.com/refinery/refinerycms-search)
