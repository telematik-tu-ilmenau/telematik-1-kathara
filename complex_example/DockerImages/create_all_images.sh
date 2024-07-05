#!/bin/bash

for i in *; do
    cd $i;
    ./create_image.sh || true;
    cd ..;
done

