#!/bin/bash

set -e

# Download and create the first time, a new composer project with its dependencies.
if [ ! -s composer.json -a -n "$PROJECT_SOURCE" -a -n "$SOURCE_TYPE" ]; then

    # Move to temporary folder to avoid overwriting conflicts
    tmpFolder="tmp-$HOSTNAME"
    mkdir $tmpFolder
    cd $tmpFolder

    PWD=$(pwd)
    
    # Create the project
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
    jsonDirectory=$(find $PWD -name composer.json 2>/dev/null | head -n 1 | xargs dirname)
    if [ "$jsonDirectory" != "$PWD" ]; then
        cp -Rf $jsonDirectory/* $PWD \
        && rm -rf $jsonDirectory
    fi

    # Return to the root project folder and remove the tmp folder
    cd -
    cp -Rf $tmpFolder/* .
    rm -rf $tmpfolder
   
    # Install dependencies
    composer --ansi install $INSTALL_FLAGS
    
    # give non-root permissions
    chown -R 1000:users .
fi

# Execute composer anyway.
exec composer --ansi "$@"
