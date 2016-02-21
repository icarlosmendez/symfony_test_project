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
rm app/AppKernel

# 7.
# Move the Resources and UserBundle directories and the AppKernel.php file into position
mv -R Resources app/Resources
mv -R UserBundle src/UserBundle
mv AppKernel app/AppKernel

# 8.
# Launch the welcome page to your new project in your default browser

#open http://localhost:8000

# 9.
# Launch the documentation for configuring the FOSUserBundle

#open http://symfony.com/doc/current/bundles/FOSUserBundle/index.html
# I would like to script all of this with Python and just run the python file here.

# 10.
# Fire up the embedded php server bundled with Symfony

#app/console server:run

# 11.
# To begin using your FOSUserBundle follow the documentation at the following URL.
# It should be open in your browser already
# http://symfony.com/doc/current/bundles/FOSUserBundle/index.html
