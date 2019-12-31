# Contributing

## Getting started

1. Install [docker](https://docs.docker.com/install/).
1. Clone this respository onto your machine.
1. Open a shell terminal and `cd` into the root of the project directory.
1. Run `docker build ./` which should terminate with `Successfully built xxxxxxxxxxxx`
1. (Optional) Copy `xxxxxxxxxxxx` into your clipboard and run `docker run xxxxxxxxxxxx cat target/git-hooks.zip > target/git-hooks.zip` to extract the built archive.

## Code Quality

You will hopefully have noticed that the build is running `shellcheck` on all the shell scripts written in the project. Additionally, you will likely have noticed that the build runs tests on each hook individually and then an integration test at the end.

Before raising a pull request, please ensure that the build runs successfully, and that you have written new unit tests for any new functionally you have added (or bugs you have fixed etc). Additionally, please carefully consider alternatives before adding new programs to the docker build environment. The fewer are used, the easier it will be to maintain compatibility.
