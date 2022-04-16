
[![MIT Licence][licence-image]][licence-url]
[![Build Status][travis-image]][travis-url]
[![GitHub version][version-image]][releases-url]
[![Github all downloads][downloads-image]][releases-url]

# Client Git Hooks
A set of useful and generic client side (local) git hooks. To add all of them to your project simply copy the `git-hooks` directory into the root of your project and then notify Git that this directory is to be used for its hooks. You can do this using the following command;

```sh
git config core.hooksPath git-hooks/
```

The above will only work if you are using Git 2.9 or greater. Otherwise you will need to either, copy the contents of the `git-hooks` directory in this project into the `.git/hooks` directory, or replace the `.git/hooks` directory with a symlink to the new directory.

## Hook Functions Performed
 * [exclude-strings](documentation/exclude-strings.md) - prevent commits including changes with specified strings.
 * [file-size](documentation/file-size.md) - prevent commits including files above a specified size.
 * [message-format](documentation/message-format.md) - prevent commit messages that do not match a specified pattern.
 * [verify-author](documentation/verify-author.md) - prevents commits from users without author details set correctly.

## Custom Configuration
The behaviour of these hooks can be changed by specifying custom git configuration. Each function performed by this library of standardized hooks has custom git configuration that can be added. To view more details of the configuration available for each hook, click the name of the hook in the previous list to be taken to the documentation.

[licence-image]: http://img.shields.io/npm/l/gulp-rtlcss.svg?style=flat
[licence-url]: https://tldrlegal.com/license/mit-license
[travis-image]: https://app.travis-ci.com/rudikershaw/client-git-hooks.svg?branch=develop
[travis-url]: https://app.travis-ci.com/rudikershaw/client-git-hooks?branch=develop
[version-image]: https://img.shields.io/github/release/rudikershaw/client-git-hooks.svg
[releases-url]: https://github.com/rudikershaw/client-git-hooks/releases/
[downloads-image]: https://img.shields.io/github/downloads/rudikershaw/client-git-hooks/total.svg
