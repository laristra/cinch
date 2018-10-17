# Cinch Developer Documentation

# Branch Naming Conventions

The Cinch *master* branch is the primary development branch for the
proejct. Commits to master require that continuous integration tests
pass before they may be merged.

Please use the following naming conventions when creating branches:

* **release**/*major_minor*<br>
  The *release* prefix is reserved for supported Cinch release
  branches. Releases and release candidates will be identified using
  tags. Patch numbers will be derived using *git describe* from the last
  tagged version.

* **stable**/*branch\_name*<br>
  A *stable* branch is a development or feature branch that is
  guaranteed to build and pass the Cinch continuous integration test
  suite, but one which incorporates new features or capabilities that
  are not available in a release branch. This label should not be used
  for a branch that is intended to become a release candidate (Use
  *release* instead.)

* **feature/username**/*branch\_name* or **feature**/*branch\_name*<br>
  A *feature* branch is where new development is done. However, master
  should be merged periodically into a feature branch. If the branch is
  to primarily be developed by an individual, it should include the
  *username* as part of the branch.

* **fix**/*reference*<br>
  Bug-fix branches should use the *fix* prefix, and should include
  a reference number or name, e.g., issue number.

<!-- vim: set tabstop=2 shiftwidth=2 expandtab fo=cqt tw=72 : -->
