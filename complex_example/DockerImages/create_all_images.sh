#!/bin/bash

for i in dhcp http dns; do
    cd $i;
    ./create_image.sh || true;
    cd ..;
done

