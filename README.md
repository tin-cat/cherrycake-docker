![Cherrycake logo](https://raw.githubusercontent.com/tin-cat/cherrycake-gitbook/master/.gitbook/assets/cherrycake-logo.svg)
# Cherrycake docker
https://cherrycake.io

Set up a server with Cherrycake running and an application initial skeleton ready for you to start creating your application using Cherrycake.

### What is Cherrycake?

Cherrycake is a low level programming framework for developing modular, efficient and secure PHP web applications.

Unlike content management systems and fully-featured frameworks like AngularJS, React or Laravel, Cherrycake sits only as a foundation layer upon which you can build virtually any kind of application.

The aim of Cherrycake is to provide you with a methodology that feels comfortable, rational and easy to use while reaching only the fundamental structural layers of your application, so you keep complete freedom on the fun layers.

### Install

You'll need docker in your system. Follow [the official docker documentation](https://www.docker.com) on how to install Docker on your system.

* Clone the official Cherrycake docker repository
```bash
git clone https://github.com/tin-cat/cherrycake-docker.git [your project name]
```

* Optionally setup your project name for the docker environment by replacing all occurrences of `cherrycake-app` with the name of your choice in the following files:

	- ./makefile
	- ./docker/docker-compose.yml
	- ./docker/cron/cronjobs

* There's a command line interface that allows you to run commands on your Cherrycake installation. Run `make help` to see all the available commands.

* Start the Cherrycake server by running the `start` command.
```bash
make start
````

* To set up a Cherrycake skeleton to start working, run the `install-skeleton` command. You only need to do this once.
```bash
make install-skeleton
make composer-update
````

* That's it, your system is now running a server with a working Cherrycake installation and a Cherrycake base skeleton that is ready for you to start working on your project, now you can:

	* Access `http://localhost` on your browser to see the running App.
	* Access `http://localhost:8080` to admin your database (User 'root' without password)
	* Your Cherrycake project is stored under the `/app` directory, you might start working there.

### Setting up engine development mode

If you're a Cherrycake engine developer, set up a development environment by following the previous steps plus the following:

Open a shell into the PHP container by doing `make php-ssh` and run the following commands:

- **Uninstall the current Cherrycake engine**

	Open a shell into the PHP container by doing `make php-ssh` and run
	```bash
	composer remove tin-cat/cherrycake-engine
	```

- **Manually install the Cherrycake engine into `/engine`**
	```bash
	git clone git@github.com:tin-cat/cherrycake-engine.git engine
	```

- **Add `/engine` as a repository in `composer.json`**
	```
	"repositories": [
        {
            "type": "path",
            "url": "/engine"
        }
    ],
	```

- **Require the Cherrycake engine via composer**

	Open a shell into the PHP container by doing `make php-ssh` and run
	```bash
	composer require tin-cat/cherrycake-engine dev-master
	```

The Cherrycake engine will now be symlinked from `vendor/tin-cat/cherrycake-engine` to `/engine`, and you will be able to work on it under `/engine` as a normal git repository.

### Other Cherrycake repositories

* **Cherrycake Documentation** Documentation is available here: https://cherrycake.io
* **Example project** The https://cherrycake.io documentation web has been built itself with Cherrycake and also open sourced, you can use it as a reference: [Cherrycake documentation](https://github.com/tin-cat/cherrycake-documentation)
* **Cherrycake engine** The Cherrycake engine repository is available at [Cherrycake Engine](https://github.com/tin-cat/cherrycake)
* **Cherrycake Skeleton** Clone or download the [Cherrycake Skeleton](https://github.com/tin-cat/cherrycake-skeleton) repository to use it as the starting point for your project.
* **Cherrycake Docker** The [Cherrycake Docker](https://github.com/tin-cat/cherrycake-docker) sets up a complete server with Cherrycake running and a skeleton installed ready for you to start your project straightaway.

### Beta statement

Although Cherrycake is still under heavy development and it's considered to still be in a beta stage, it's functional and it's already running some public web applications without issues. It's still not recommended to use Cherrycake in critical, or data sensitive applications. Instead, you're encouraged to try it to see for yourself whether it meets your security and stability requisites, and to contribute your suggestions or improvements via the official git repositories.
