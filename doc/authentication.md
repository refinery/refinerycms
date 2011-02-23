# Authentication

## About

At the heart of Refinery's user management is the authentication engine located in ``authentication/``

What this really is is just a standard [Devise](http://github.com/platformatec/devise)
install extended with a few extra features like "I forgot my password" and hooked directly
into the heart of Refinery's engine system.

Devise allows you to easily integrate with other systems too.
So you could be logged in into another system using devise and easily stay logged
in between the two systems without having to login twice.

## Adding New Users

New users can be easily added by going to the 'Users' area admin and clicking on "Add New User".

## Limiting and Granting Access

Each user has a set of engines they're allowed to see.
You can control which engines each user can see by checking and unchecking the
checkboxes next to the engine name when editing or adding a new user.
