# Project: Monster Shop

Monster Shop is a fictitious e-commerce application that has admins, merchants, registered users, and visitors. Our application allows admins to manage all users. Merchants can fulfill orders, change order status and enable/disable items. Registered users and visitors can browse the items, place items in their shopping cart and checkout. Customers of the site can register and log in.

## Objective and Implementation 
This group project was completed in 10 days as a requirement for Module 2 at Turing School of Software and Design.

The project was built using Rails which implements the following:

MVC design pattern.
Object oriented programming principles.
CRUD functions - create, read, update, delete.
Behavior Driven Development - BDD.
Advanced database queries and calculations using ActiveRecord.
Authentication using bcrypt.
Session management to implement authorization for various users and shopping cart experience.
Feature and model testing with test coverage at 99% or better.
FactoryBot to create objects for efficient testing.
Version control using GitHub.
Project management tool: GitHub Projects.

## Contributors
- Sarah Tatro
- Jake Miller 
- Tyler Bierworth 
- Martha Troubh

## System Requirements
- Rails 5.x
- ActiveRecord - PostgreSQL

### Gems Used
---
- Bcrypt
- Capybara
- FactoryBot
- Launchy
- Pry
- RSpec
- Shoulda Matchers
- Simplecov

## GitHub Repository
https://github.com/ktsune/monster_shop

## Instructions

#### How to setup:
    1. Clone the GitHub repository.
    2. Go to the directory with the new repo. Run bundle install.
    3. Run rake db:{create,migrate,seed}
    4. Run rails s, visit localhost:3000 to view the app and navigate on your local server.
#### Run tests:
    1. Run rspec.
    2. To run an individual test, type rspec and the full path to the test file into the command line.
#### Sample login credentials for users:
    1. Login as an admin: email jeff@gmail.com, password: jeff
    2. Login as a merchant: email green@gmail.com, password: frogs
    3. Login as a customer: *create your own user account*
