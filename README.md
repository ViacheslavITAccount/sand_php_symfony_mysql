# Sandbox PHP Symfony Framework, MYSQL, Nginx

This is an empty project based on PHP (8.3) Symfony Framework (6.4), MySQL (8) and Nginx (1.28)

You can download it and use for your experiments and pet-projects with this technologies

## Requirements

You need installed next software for successfully using this project

#### make
#### Docker version 28.1.1 or higher
#### Docker Compose version v2.35.1 or higher
#### git version 2.43.0 or higher
 
> This project was tested and run on Linux workstation. Correct working with other OS didn't check

## Before run

You should add next line in your file `/etc/hosts`

```
127.0.0.1 pet-project.sandbox.local
```

## Build and run project

Project contains all necessary Dockerfiles for build images and run project

You can build and run this project using only one command

```
make build
```

For next times you can run project with command

```
make up
```

and shot down with command

```
make down
```

## Other command

You can see list of available command when you execute

```
make help
```

or explore file `Makefile` in project root directory  


Enjoy!!!