# verify-author

By default this hook will prevent commits when the `git config user.name` has less than two characters, or if the `git config user.email` does not look like an approximately valid email address. If you need to turn this hook off you can:

```sh
git config hooks.verify-author.disabled true
```

Or if you need to specify the required format of the `user.name` you can define a Perl compliant regular expression (`$x`) that must match the `user.name` for any commits:

```sh
git config hooks.verify-author.username "$x"
```

If you need to specify the required format of the `user.email` you can define a Perl compliant regular expression (`$x`) that must match the `user.email` for any commits:

```sh
git config hooks.verify-author.email "$x"
```
