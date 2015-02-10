# estebanmatias92/composer-improved

This image have a programmatic entrypoint which i recommend you to read.
When you specifies PROJECT_SOURCE and SOURCE_TYPE variables, the first time deployed (when the current folder dont have the composer.json file), it installs new php project using composer.
The root of the installed project will be the current workdir.

## Usage

docker run --rm -e PROJECT_SOURCE=”symfony/symfony” -e PROJECT_VERSION=”~2.6” -e SOURCE_TYPE=”composer” -e PROJECT_FLAGS=”--ignore-platform-reqs” -e INSTALL_FLAGS=”--prefer-dist --ignore-platform-reqs” estebanmatias92/composer-improved validate

If you dont specifies nothing, the container will work anyways but will not create the project.

docker run --rm estebanmatias92/composer-improved --version

## Environment variables

#### PROJECT_SOURCE:
Can be a repo url from git, mercurial or subversion. Can be url with a tar or zip file (http://<url-here>.zip), or can be a packagist project.

#### SOURCE_TYPE:
It is not smart and needs specifications to work.
The values can be;

git,
subversion,
mercurial,
targz,
zip,
composer

#### PROJECT_VERSION:
Only works with the composer type. It specifies the packagist project version.

#### PROJECT_FLAGS:
Valid for git, mercurial, subversion and composer type, and corresponds to the flags from each command line tool.

#### INSTALL_FLAGS:
Corresponds with flags from "composer install" command.

