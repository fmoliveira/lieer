#!/bin/bash

# this script is a workaround for the issue reported at https://github.com/gauteh/lieer/issues/267
# when trying to build lieer on macos due to the missing headers from notmuch2.
# 
# tested on:
# - macos sonoma 14.5 arm64
# - brew 4.3.7
# - notmuch 0.38.3
# - python 3.11.9
# - pip 24.1.1
# - lieer 1.6 with git head 578b9d7698c261ddf4d8010427e156890ea0c535
#
# error output:
#
# running build_ext
# generating cffi module 'build/temp.macosx-14.0-arm64-cpython-311/notmuch2._capi.c'
# already up-to-date
# building 'notmuch2._capi' extension
# clang -Wsign-compare -Wunreachable-code -fno-common -dynamic -DNDEBUG -g -fwrapv -O3 -Wall -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk -I../../lib -I-L -I/opt/homebrew/opt/python@3.11/Frameworks/Python.framework/Versions/3.11/include/python3.11 -c build/temp.macosx-14.0-arm64-cpython-311/notmuch2._capi.c -o build/temp.macosx-14.0-arm64-cpython-311/build/temp.macosx-14.0-arm64-cpython-311/notmuch2._capi.o
# build/temp.macosx-14.0-arm64-cpython-311/notmuch2._capi.c:572:14: fatal error: 'notmuch.h' file not found
#     #include <notmuch.h>
#
# turns out that the notmuch.h header is available right there with the homebrew package along with the respective library binaries.
# this script will simply grab the notmuch2 path from homebrew and add the include and lib paths to the cffi build.
#
# the expected successful output should look like:
# Successfully built lieer notmuch2
# Installing collected packages: pyparsing, notmuch2, httplib2, google_auth_oauthlib, google-auth-httplib2, google-api-python-client, lieer
# Successfully installed google-api-python-client-2.135.0 google-auth-httplib2-0.2.0 google_auth_oauthlib-1.2.0 httplib2-0.22.0 lieer-1.6 notmuch2-0.1 pyparsing-3.1.2
#
# and then you should have the program `gmi` in your path:
# which gmi
# 
# finally you can try running it and it should work!
# gmi --help

platform=$(uname -s | tr '[:upper:]' '[:lower:]')
if [[ "$platform" != 'darwin' ]]; then
  echo "Platform '$platform' is not supported!"
  echo "Follow the official uninstall guide at: https://github.com/gauteh/lieer"
  exit 1
fi

if ! command -v notmuch >/dev/null 2>&1; then
  echo "Notmuch is not installed!"
  echo "Install it with homebrew: brew install notmuch"
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Brew is not installed!"
  echo "This script only supports homebrew setups, sorry."
  exit 1
fi

notmuch_path=$(readlink -f $(brew --prefix notmuch))
notmuch_include="$notmuch_path/include"
notmuch_lib="$notmuch_path/lib"

pip install --global-option=build_ext --global-option="-I$notmuch_include" --global-option="-L$notmuch_lib" --no-use-pep517 .
