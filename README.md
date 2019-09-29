
[![MIT Licence][licence-image]][licence-url]
[![Build Status][travis-image]][travis-url]

# Client Git Hooks
A set of useful client side git hooks. To add all of them to your project simply copy the `git-hooks` directory into the root of your project and then notify Git that this directory is to be used for its hooks. You can do this using the following command;

```
git config core.hooksPath git-hooks/
```

The above will only work if you are using Git 2.9 or greater. Otherwise you will need to copy the contents of the `git-hooks` directory in this project into the `.git/hooks` directory instead.

[licence-image]: http://img.shields.io/npm/l/gulp-rtlcss.svg?style=flat
[licence-url]: https://tldrlegal.com/license/mit-license
[travis-image]: https://travis-ci.org/rudikershaw/client-git-hooks.svg?branch=master
[travis-url]: https://travis-ci.org/rudikershaw/client-git-hooks
