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
git clone https://github.com/tin-cat/cherrycake-docker.git
```
* There's a command line interface that allows you to run commands on your Cherrycake installation. Run `./cherrycake help` to see all the available commands.

* Start the Cherrycake server by running the `start` command.
```bash
./cherrycake start
````

* To set up a Cherrycake skeleton to start working, run the `install-skeleton` command. You only need to do this once.
```bash
./cherrycake install-skeleton
./cherrycake composer-update
````

* That's it, your system is now running a server with a working Cherrycake installation and a Cherrycake base skeleton that is ready for you to start working on your project, now you can:

	* Access `http://localhost` on your browser to see the running App.
	* Access `http://localhost:8080` to admin your database (User 'root' without password)
	* Your Cherrycake project is stored under the `/app` directory, you might start working there.

### Other Cherrycake repositories

* **Cherrycake Documentation** Documentation is available here: https://cherrycake.io
* **Example project** The https://cherrycake.io documentation web has been built itself with Cherrycake and also open sourced, you can use it as a reference: [Cherrycake documentation](https://github.com/tin-cat/cherrycake-documentation)
* **Cherrycake engine** The Cherrycake engine repository is available at [Cherrycake Engine](https://github.com/tin-cat/cherrycake)
* **Cherrycake Skeleton** Clone or download the [Cherrycake Skeleton](https://github.com/tin-cat/cherrycake-skeleton) repository to use it as the starting point for your project.
* **Cherrycake Docker** The [Cherrycake Docker](https://github.com/tin-cat/cherrycake-docker) sets up a complete server with Cherrycake running and a skeleton installed ready for you to start your project straightaway.

### Beta statement

Although Cherrycake is still under heavy development and it's considered to still be in a beta stage, it's functional and it's already running some public web applications without issues. It's still not recommended to use Cherrycake in critical, or data sensitive applications. Instead, you're encouraged to try it to see for yourself whether it meets your security and stability requisites, and to contribute your suggestions or improvements via the official git repositories.
