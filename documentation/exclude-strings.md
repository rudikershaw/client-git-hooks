# excluded-strings

By default this hook will stop any commits that includes the string 'TODO'. If you have added a TODO it is better to register it on a purpose built issue tracking system. This default however may not be to everyone's taste. You can turn this off by adding the following configuration:

```
git config hooks.excluded-strings.disabled true
```

Or you can specify a file which includes a new-line separated list of strings that should not be allowed in your commits.

```
git config hooks.excluded-strings.file exclusions.text
```
