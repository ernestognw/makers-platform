# Makers Program

This is the repository for "Makers Program" for Tec de Monterrey. This project will aid in promoting and incrementing the protoyping capabilities for the Tec community. It provides a platform to consult shared spaces and devices within the Monterrey campus for prototype fabrication.

## Table of contents

* [Client Details](#client-details)
* [Environment URLS](#environment-urls)
* [Team](#team)
* [Technology Stack](#technology-stack)
* [Setup the project](#setup-the-project-locally)
* [Running the stack for development](#running-the-stack-for-development)
* [Stop the project](#stop-the-project)
* [Running specs](#running-specs)

### Client Details

| Nombre                         | Email                    | Rol                 |
| ------------------------------ | ------------------------ | ------------------- |
| Azael Jesús Cortés Capetillo   | azael.capetillo@tec.mx   | Cliente             |
| Alvaro Cheyenne de Jesus Valdez| chdejesus@tec.mx         | Asociado al Cliente |


### Environment URLS

* **Production** - [Heroku Production](https://makersprogram.herokuapp.com/)

### Team

| Name                              | Email              | Rol        |
| --------------------------------- | ------------------ | ---------- |
| Ernesto García                    | A00820783@itesm.mx | Desarrollo |
| Alan Macedo                       | A01366288@itesm.mx | Desarrollo |
| Alberto García                    | A00822649@itesm.mx | Desarrollo |

### Technology Stack
| Technology    | Version      |
| ------------- | -------------|
| Docker        | 19.03.2      |
| Ruby          | 3.0.0        |
| Rails         |  6.1.3       |
| PostgreSQL    |  9.6.15      |

### Management tools

You should ask for access to this tools if you don't have it already:

* [Github repo](https://github.com/ernestognw/makers-platform)
* [Backlog](https://makers-platform.atlassian.net/jira/software/projects/MKR/)
* [Heroku](https://makersprogram.herokuapp.com/)
* [Documentation](https://drive.google.com/drive/u/2/folders/0AD-0tjERzkMkUk9PVA)

## Development

### Setup the project locally

To run the project, you will need to make sure you have [Docker](https://docker.com) installed on your machine.

After installing, you can follow this simple steps:

1. Clone this repository into your local machine

```bash
$ git clone https://github.com/ProyectoIntegrador2018/makers.git
```

2. Add Needed Ruby Environmental variables

They should be added into a file `config/local_env.yml` or be setup into your environment including the following variables:
```yml
TEC_USERNAME: "email_address"
TEC_PASSWORD: "password"
```

3. Navigate to the `makers/` directory and run:

```bash
$ docker-compose build
```

4. Once the Docker image is built:

```bash
$ docker-compose run web bash
```

This command will open a bash session inside the container, from which you can interact directly with the rails application.

5. Set up the database inside the web container

```bash
$ rails db:create
$ rails db:migrate
$ rails db:seed
```

You only need to follow the previous steps the first time you build the app locally, but some of the steps can and should be reused when configuration and database schema changes.

### Running the stack for Development

1. Once the database is setup and populated, you can exit the web container with `Ctrl + z` and run the following command to start the rails application:

```bash
$ docker-compose up
```

It may take a while before you see anything. Once you see an output like this:

```
web_1   | => Booting Puma
web_1   | => Rails 5.2.2 application starting in development on http://0.0.0.0:3000
web_1   | => Run `rails server -h` for more startup options
web_1   | => Ctrl-C to shutdown server
web_1   | Listening on 0.0.0.0:3000, CTRL+C to stop
```

This means the project is up and running and the web app can be used at `localhost:3000`.

### Stop the project

Use `Ctrl + c` on the terminal window in which the rails server is open to stop the project.

If you want to stop every docker process related to the project, you can run the following command from the root (`makers/`) directory:

```bash
$ docker-compose stop
```

### Running specs

To run **all** specs run `docker-compose up test`.

Or if you want to run a specific spec you can enter the test container with `docker-compose run test bash` and then:

```bash
$ rspec spec/models/user_spec.rb
```

**Sidenote:** When you open a bash shell, docker doesn't always run the `chrome` instance (needed for running js-relying tests) so make sure you have it running with `docker-compose up browser`.

#### Debugging

When debugging tests, you might benefit of viewing the selenium browser, to do so you need to download a [VNC viewer](https://www.realvnc.com/es/connect/download/viewer/). Once downloaded simply go to `vnc://localhost:4444` and input the password `secret` (**Note:** the firefox instance needs to be running for this to work).

You can also use capybara helpers such as `save_and_open_screenshot` to take a screenshot at any given time. For more info on capybara go [here](https://github.com/teamcapybara/capybara).



### Windows Set-up

The [project might break](https://github.com/rails/sprockets/issues/283) if you don't have a Linux Subsystem installed, since Windows by default doesn't differentiate folders by with different case. In order to fix this you first have to run this command in `Windows PowerShell (Admin)`

```
$ Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

After restarting, you'll need to run the following command with a normal Command Prompt (under the base project path):

```
$ fsutil.exe file SetCaseSensitiveInfo tmp enable
```
