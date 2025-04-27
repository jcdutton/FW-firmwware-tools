This page describes how to download, compile and install "ectool".

Start by downloading the source code from github:

`git clone https://github.com/jcdutton/ectool.git`

`cd ectool`

`mkdir build`

`cd build`

`cmake ..`

`make`

the "ectool" will now be in ...  ectool/build/src/ectool

to make it easy to use, copy it to /usr/sbin

`cp ./src/ectool /usr/sbin`

To test "ectool"

`sudo ectool version`


