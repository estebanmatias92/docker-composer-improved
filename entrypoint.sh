#!/bin/bash

set -e

# Download and create the first time, a new composer project with its dependencies.
if [ ! -s composer.json -a -n "$PROJECT_SOURCE" -a -n "$SOURCE_TYPE" ]; then

    PWD=$(pwd)
    
    case $SOURCE_TYPE in
        git)
            git clone $PROJECT_FLAGS $PROJECT_SOURCE $PWD
            ;;
        subversion)
            svn checkout $PROJECT_FLAGS $PROJECT_SOURCE $PWD
            ;;
        mercurial)
            hg clone $PROJECT_FLAGS $PROJECT_SOURCE $PWD
            ;;
        targz)
            wget -O /tmp/project.tar.gz $PROJECT_SOURCE \
            && tar -zxvf /tmp/project.tar.gz -C $PWD \
            && rm /tmp/project.tar.gz
            ;;
        zip)
            wget -O /tmp/project.zip $PROJECT_SOURCE \
            && unzip -o /tmp/project.zip -d $PWD \
            && rm /tmp/project.zip
            ;;
        composer)
            composer --ansi create-project --no-install --no-interaction $PROJECT_FLAGS $PROJECT_SOURCE $PWD $PROJECT_VERSION
            ;;
        *)
            echo "Invalid SOURCE_TYPE !!!" \
            && echo "Should be used some of the next values:" \
            && echo " " \
            && echo "git" \
            && echo "subversion" \
            && echo "mercurial" \
            && echo "targz" \
            && echo "zip" \
            && echo "composer" \
            && exit 1
            ;;
    esac

    # Strip first-level folder if exists
    directory=$(find $PWD -name composer.json 2>/dev/null | head -n 1 | xargs dirname)
    if [ "$directory" != "$PWD" ]; then
        mv $directory/* $PWD \
        && rm -rf $directory
    fi

    composer --ansi install $INSTALL_FLAGS
fi

# Execute composer anyway.
exec /usr/local/bin/composer --ansi
