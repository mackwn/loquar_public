# README

Loquar is a webapp which provides a gamified version of the public domain textbook, Latin For Beginners, by Benjamin D'Ooge. Users sign-up using their email and gain points through answering questions correctly in each lesson. After scoring enough points, users can advance to the next lesson. Each lesson includes the text from book to explain the grammar needed to answer the questions.

The app uses the Ruby on Rails framework with a fair amount of custom javascript on the front-end to handle the game interface. 

This is a copy of the original repository and the commit history has been omitted for security purposes as this app is still deployed.

Last major update January 2018. Updated gems and ruby version in October 2020. 

* Ruby version 2.4.1

Installing:
* Install the needed gems with bundle install
* Create the database with rails db:migrate
* Create the admin account with rails db:seed
Set Environment Variables:
* Secret key
* Sendgrid login or other email server settings
* AWS key or similar for storing questions - see models/question.rb
* Default admin login

Load the lessons:
* Create the lesson files using rake migrate:lessons
* Create the lesson text using rake migrate:lessonText

Run the server and begin!

Additional notes:
* Audio samples are generated using ESpeak externally and loaded into public/audios. 
* Images are pulled from public domain sources and attached with paper clip.
* Lesson material is loaded from a csv file. Exercises were parsed from an html version of the text with an external tool. 

Important Files:
* assets/javascripts/lessons.coffee - Coffeescript for managing the game interface. Originally written in Jquery and used a coffee script converter for use with ruby on rails.
* app/controllers/answering_controller.rb - controls much of the logic for managing the flow of each lesson. 
* lib/tasks/import_lessons.rake - rake task for creating lessons from csv files
* lib/answering_functions.rb - Functions for generating questions and creating random answer choices. Creates random blanks in words for the cloze deletion questions. 
