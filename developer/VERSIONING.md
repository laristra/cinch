# Cinch Developer Documentation

# Branch Naming Conventions

The *master* branch is the primary development branch for the
proejct. Commits to master require that continuous integration tests
pass before they may be merged.

Please use the following naming conventions when creating branches:

* **release**/*major.minor*<br>
  The *release* prefix is reserved for supported release
  branches. Actual releases and pre-releases will be identified using
  tags.
  
  Tagging conventions for the release branch:

  * Patch numbers for a release will be specified in the tag, such
    that a given release will have the form *major.minor.patch*.  

  * Alpha, Beta, or Release Candidates<br>
    Any pre-release version should include the name of the pre-release,
    e.g., alpha, beta or rc, and the version of the pre-release at the
    end of the normal release version. Here are some examples:

    * Release candidate 2 of release 1.0.0 would be *1.0.0-rc.2*.
    * Alpha release 1 of release 1.0.0 would be *1.0.0-alpha.1*.

  * Must branch from: **master**

* **stable**/*branch\_name*<br>
  A *stable* branch is a development or feature branch that is
  guaranteed to build and pass the FleCSI continuous integration test
  suite, but one which incorporates new features or capabilities that
  are not available in a release branch. This label should not be used
  for a branch that is intended to become a release candidate (Use
  *release* instead.)

* **feature/username**/*branch\_name* or **feature**/*branch\_name*<br>
  A *feature* branch is where new development is done. However, master
  should be merged periodically into a feature branch. If the branch is
  to primarily be developed by an individual, it should include the
  *username* as part of the branch.

  * Must branch from: **master**
  * Must merge to: **master**

* **fix**/*reference*<br>
  Bug-fix branches should use the *fix* prefix, and should include
  a reference number or name, e.g., issue number or the related release
  tag.

  * Must branch from: **release branch**
  * Must merge to: **master *and* release branch**

# Managing Branches

Blah Blah

## Feature Branches

All new development is done on a feature branch.

### Creating
To create a new feature branch:
```bash
# Make sure that you are up-to-date on the master branch
$ git checkout master
$ git pull

# Create a new feature branch
$ git checkout -b feature/name
```
Once you make changes to your feature branch, you can push them to
the remote--**after considering classification and export control
implications**--using the following:
```
git push --set-upstream origin feature/name
```

### Merging
Once you are done developing a feature, you should merge your feature
branch with master using the *no fast-forward (--no-ff)* flag to git:
```bash
# Make sure that you are up-to-date on the master branch
$ git checkout master
$ git pull

# Merge your branch into master
$ git merge --no-ff feature/name
```
The *--no-ff* flag preserves information about the existence of the
feature branch after it is removed.

Once you have merged your changes into master, you should submit a pull
request. This can be done on the [github
website](https://github.com/laristra), or from the command-line:



# Creating a Distribution

<!-- vim: set tabstop=2 shiftwidth=2 expandtab fo=cqt tw=72 : -->
