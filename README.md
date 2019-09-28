# Client Git Hooks
A set of useful client side git hooks. To add all of them to your project simply copy the `git-hooks` directory into the root of your project and then notify Git that this directory is to be used to hooks. You can do this using the following command;

```
git config core.hooksPath git-hooks/
```

The above will only work if you are using Git 2.9 or greater. Otherwise you will need to copy the contents of the `git-hooks` directory in this project into the `.git/hooks` directory instead.
