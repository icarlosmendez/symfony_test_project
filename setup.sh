#!/usr/bin/env bash

# Script designed to get a symfony base project up and running in a matter of seconds or minutes depending on the speed
# of your internet connection and your hardware.

# 1.
# Set your project name variable here
# Echo it out to the terminal so you know that part is working

projectname=symfony_test_project

echo
echo " Your project $projectname is now being built..."

# 2.
# Install symfony with symfony. (recommended)
# The '$projectname' variable passes in your chosen project name from above.

symfony new "$projectname" lts

# 3.
# cd into the project directory so you have access to the Symfony console functionality

echo
echo " Changing to the $projectname directory..."
echo
cd "$projectname"/

# 4.
# Install the Friends of Symfony User Bundle via composer

composer require friendsofsymfony/user-bundle "~2.0@dev"

# 5.
# Run composer install to ensure that all the dependencies are installed accordingly

composer install

# 6.
# Remove the current Resources directory and the AppKernel.php file
rm -R app/Resources
echo
echo " Removing the app/Resources directory..."

rm -R app/config
echo
echo " Removing the app/config directory..."

rm app/AppKernel.php
echo
echo " Removing the app/AppKernel.php file"

# 7.
# Move the Resources and UserBundle directories and the AppKernel.php file into position

cd ..
echo
echo " Moving the Resources directory into position..."
mv Resources symfony_test_project/app/Resources

echo
echo " Moving the config directory into position..."
mv config symfony_test_project/app/config

echo
echo " Moving the UserBundle directory into position..."
mv UserBundle symfony_test_project/src/UserBundle

echo
echo " Moving the AppKernel.php file into position..."
mv AppKernel.php symfony_test_project/app/AppKernel.php

# 8.
# Run app/console cache:clear to prepare the system for the new configurations
# Update the database schema. Pushes the user table to your db
# Create a test user

echo
echo " Changing to the $projectname directory..."
cd symfony_test_project

echo
echo " Clearing the cache and preparing to work..."
app/console cache:clear

echo
echo " Updating the database schema using Doctrine..."
app/console doctrine:schema:update --force

echo
echo " Creating testuser and adding to database..."
app/console fos:user:create testuser test@example.com p@ssword

# 9.
# Launch the welcome page to your new project in your default browser

open http://localhost:8000

# 10.
# Launch the documentation for configuring the FOSUserBundle

open http://symfony.com/doc/current/bundles/FOSUserBundle/index.html

# 11.
# Fire up the embedded php server bundled with Symfony

app/console server:run

# 12.
# To begin using your FOSUserBundle follow the documentation at the following URL.
# It should be open in your browser already
# http://symfony.com/doc/current/bundles/FOSUserBundle/index.html
