# symfony_test_project
A quick trip to a functional Symfony project with FOSUserBundle installed.

### Assumptions:
You are working on a *nix system (haven't done this on Windows)

You want to create a Symfony project based on the latest stable release

You want a fully functioning authentication/user creation system

You will be using a database to persist data

You will be using 'Doctrine' ORM

### Prerequisites: 
**These steps are mandatory for working with Symfony**

- You have installed PHP >=5.3.9

- You have installed MySQL or MariaDB (most of this will work with other db's but no testing has been done)

- You have installed Symfony Installer according to these instructions (Linux and Mac OS X)

    - This will make the Symfony Installer available globally on your system (_best practice/highly recommended_)

```
sudo curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
sudo chmod a+x /usr/local/bin/symfony
```

- You have installed Composer according to these instructions (Linux and Mac OS X)

    - This will make Composer available globally on your system (_best practice/highly recommended_)

```
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
```
```
php installer
sudo mv composer.phar /usr/local/bin/composer
```

### Okay! Let's do this:
- Clone project into your chosen base directory
    - In terminal navigate to your base directory
    - `git clone https://github.com/icarlosmendez/symfony_test_project`
    - `cd symfony_test_project` into the project directory
    - `ls` to verify that you have two files
        - README.md and setup.sh  
- Set the projectname variable
    - In your code editor, open setup.sh and set the projectname variable to your preference
    - save 
- Build it
    - In terminal run setup.sh to scaffold the project
    - `bash setup.sh`
    - Watch as the magic happens!
- What you get 
    - Symfony 2.8 LTS
    - FOSUserBundle 2.0@dev
- This build script will culminate with:
    - The launch of your project in the browser
    - The launch of the documentation page for ‘Getting Started With FOSUserBundle’ on the Symfony website
- From here you will configure FOSUserBundle

### Adapted from: 'Getting Started With FOSUserBundle'
http://symfony.com/doc/current/bundles/FOSUserBundle/index.html

#### Translations
This feature uses a list of text substitutions in a key => value pair technique.
This is an easy way of configuring standard text which can then be used throughout the application simply by passing the key into your twig template and the value is rendered.
You want this.

If you wish to use default texts provided in this bundle, you have to make sure you have translator enabled in your config.

_YAML_

filepath: `app/config/config.yml`

```
framework:
    translator: { fallbacks: ["%locale%"] }
```

For more information about translations, check Symfony documentation.

### Installation/configuration Overview

- Enable the Bundle
- Create your User class
- Configure your application's security.yml
- Configure the FOSUserBundle
- Import FOSUserBundle routing
- Add the FOSUser service
- Update your database schema


#### Step 1: Enable the bundle

Enable the bundle in the kernel by adding the entry shown below

_PHP_

filepath: `app/AppKernel.php`

```
$bundles = array(
    //...
    new FOS\UserBundle\FOSUserBundle(),
    //...
```


#### Step 2: Create your User class

- The goal of this bundle is to persist some User class to a database (MySql, MongoDB, CouchDB, etc).
- Your first job, then, is to create the User class for your application.
- This class can look and act however you want:
    - add any properties or methods you find useful.
    - _This is your User class._

</br>
**Doctrine ORM User class**

You will need to create the 'Entity' directory to hold the `User.php` file
Do that now.

_Annotations_

filepath: `src/AppBundle/Entity/User.php`

```
namespace AppBundle\Entity;

use FOS\UserBundle\Model\User as BaseUser;
use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity
 * @ORM\Table(name="fos_user")
 */
class User extends BaseUser
{
    /**
     * @ORM\Id
     * @ORM\Column(type="integer")
     * @ORM\GeneratedValue(strategy="AUTO")
     */
    protected $id;

    public function __construct()
    {
        parent::__construct();
        // your own logic
    }
}
```

`user` is a reserved keyword in the SQL standard. If you need to use reserved words, surround them with backticks, e.g. @ORM\Table(name=" \`user\` ")


#### Step 3: Configure your application's security.yml

In order for Symfony's security component to use the FOSUserBundle, you must tell it to do so in the security.yml file. The security.yml file is where the basic security configuration for your application is contained.

Below is a minimal example of the configuration necessary to use the FOSUserBundle in your application:
Pay close attention to the indentation. That is how YAML understands hierarchy and an improperly indented config rule will result in an error

_YAML_

filepath: `app/config/security.yml`

```
security:
    encoders:
        FOS\UserBundle\Model\UserInterface: bcrypt

    role_hierarchy:
        ROLE_ADMIN: ROLE_USER
        ROLE_SUPER_ADMIN: ROLE_ADMIN

    providers:
        fos_userbundle:
            id: fos_user.user_provider.username

    firewalls:
        main:
            pattern: ^/
            form_login:
                provider: fos_userbundle
                csrf_token_generator: security.csrf.token_manager

            logout: true
            anonymous: true

    access_control
         - { path: ^/login$, role:  IS_AUTHENTICATED_ANONYMOUSLY }
         - { path: ^/register, role:  IS_AUTHENTICATED_ANONYMOUSLY }
         - { path: ^/resetting, role:  IS_AUTHENTICATED_ANONYMOUSLY }
         - { path: ^/admin/, role:  ROLE_ADMIN }
```


#### Step 4: Configure the FOSUserBundle

Add the following configuration to your config.yml file according to which type of datastore you are using.

_YAML_

filepath: `app/config/config.yml`

```
fos_user:
    db_driver: orm (other valid values are 'mongodb', 'couchdb' and 'propel')
    firewall_name: main
    user_class: AppBundle\Entity\User
```


#### Step 5: Import FOSUserBundle routing files

By importing the routing files you will have ready made pages for things such as logging in, creating users, etc.

_YAML_

filepath: `app/config/routing.yml`

```
fos_user:
    resource: "@FOSUserBundle/Resources/config/routing/all.xml"
```

In order to use the built-in email functionality (confirmation of the account, resetting of the password), you must activate and configure the SwiftmailerBundle


#### Step 6: Add the fos_user service

This is not in the official documentation but without this insertion, courtesy of:
http://stackoverflow.com/questions/35031401/symfony-2-7-3-doctrine-you-have-requested-a-non-existent-service-fos-user/35032097
your schema update in step 7 won’t work. It's time for them to update the docs!

_YAML_

filepath: `app/config/services.yml`

```
services:
    fos_user.doctrine_registry:
        alias: doctrine
```


#### Step 7: Update your database schema

This step assumes the existence of a database with a name. This is the only part so far where any creativity has been allowed but don't let that throw you.


Most fresh installs of MySQL or MariaDB will provide a prebuilt test database.
If you did the secure install process and removed the test database then that's no longer an option.
If you do not have a test database or something to that effect, create one now. Review the next step for a suggestion.


Creating the database via `app/console doctrine:database:create` is recommended and then the naming will be done during the database creation.


Next ensure that your database name is accurately configured in `app/config/parameters.yml`. By default it is defined as symfony.
Now that the bundle is configured and we're/you’re sure you have a database, the last thing you need to do is update your database schema because you have added a new entity, the User class which you created in Step 3.


For ORM run the following command:

`app/console doctrine:schema:update --force`

For other db types see the official docs. Link is at the top-ish.


#### Step 8: Test the functionality of the forms

Go to your project page running in the browser at `localhost:8000`

Add the extension `/register` and you should see a registration form. Go ahead and sign up with a test user.
Upon submission this user should be entered into your database and you should be redirected to `/register/confirmed` with a messages showing:

Logged in as test | Log out
The user has been created successfully

Congrats test, your account is now activated.

Go ahead and log out and add the extension `/login` and you should see a login form.

Log in as your test user and you should be authenticated against the database and logged in. If you look down at the bottom of the browser you'll see the profiler panel
and it should show you logged in as your test user and a whole bunch of other interesting statistics that are useful during development and testing.

I hope that you got through that scot-free and that you now have a symfony project, set up with a basic configuration of the FOSUserBundle ready for further development.
The next step is to enable the overriding of the templates that come with FOSUserBundle as you will surely need to customize these forms for your site's look and feel.
Stay tuned!
