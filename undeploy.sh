#!/bin/bash

echo "Stopping containers"
docker stop balticweb db couch

full ()
{
    echo "Removing containers" && docker rm balticweb db couch && docker       network rm baltic
}

$1

exit 0
