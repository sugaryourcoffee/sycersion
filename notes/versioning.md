# Versioning
`sycversion` is based on 

* the article [A successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/) from Vincent Driessen and
* the [semantic versioning](https://semver.org) philosophy

## Git Branching Model
With branching we organize the code with clear responsibilities for each 
branch and a clear purpose and stage of software being in a specific branch.

Following the meaning of a branch is explained and how we branch in 
different stages. 

The tabel shows the relation of branches between each other. To be read from
top, down to right, e.g. Master branches into Development. Hotfix merges into
Master.

--------------------------------------------------------------------------------
Master     Development       Feature     Release     Hotfix   
---------- ----------------- ----------- ----------- --------- -----------------
-          merge             -           merge       merge     Master           
 
branch     -                 merge       merge       merge     Development      
 
-          branch            -           -           -         Feature          
 
-          branch            -           -           -         Release          
 
branch     -                 -           -           -         Hotfix           
 
--------------------------------------------------------------------------------

### Master
The master branch contains code that is allways in a production state. All
software that is in the master branch is released. Each released version is 
tagged with a Git tag.

### Development
Branched off from Master

    $ git checkout -b development master

Code in the development branch most likely will have code that is between 
different releases it has more functions as the last release and is intended
to be released with the next version.

Branched into Master

    $ git checkout master
    $ git merge development

### Feature
Branched off from Development

    $ git checkout -b feature development

When a new feature for the software is developed this is done in a feature
branch that is branched off from development. In this branch only the specific
feature is developed. After the feature is tested and the tests are green it 
is merged back to development

Merged into Development

    $ git checkout development
    $ git merge feature

### Release
Branched off from Development

    $ git checkout -b release-0.1.0 develop

When the software is ready to be released as a new version it is as an
intermediate step branched into a release branch where it is tested. If the 
code has bugs these are fixed in the release branch. No new features are
added in the release branch.

A release branch goes through 3 stages indicated by a version suffix.

* Beta (version x.y.z-beta) is deployed to the beta server and tested by few
  persons to test the functionality.

* Staging (version x.y.z-staging) is deployed to the staging server and is
  tested simultaniously by more people to test load behaviour.

* Production (verion x.y.z). The release branch is merged to production and
  back to development.

Merged into Master
Merged into Development

    $ git checkout master
    $ git merge release-0.1.0
    $ git checkout development
    $ git merge release-0.1.0

### Hotfix
Branched off from Master

    $ git checkout -b hoftix-0.1.1

If a released software version has an identified bug the software is branched
off into a hotfix branch.

Merged back to Master
Merged to Deveopment
Merged to Release if currently open

    $ git checkout master
    $ git merge hotfix-0.1.1
    $ git checkout development
    $ git merge hotfix-0.1.1

## Versioning
A version number consist of 3 digits separated by dots `.` and optionally a 
suffix (beta, staging).

    Version 1.2.3-suffix
            | | | + stage of stability
            | | + Patch
            | + Minor
            + Major

* _Major_ changes if
    * new language implementation e.g. from Rails to Pheonix
    * Needs a new runtime environment, that is the application cannot be 
      deployed to the existing environment because of a new Rails version

* _Minor_ changes if
    * new features are added to the application e.g. a user statistics page

* _Patch_ changes if
    * an error is fixed
    * docmentation is extended
    * refactoring of code has done

* _Suffix_ has two stages
    * Beta - the application is deployed to beta server where a few users are
      testing the application based on a test catalog
    * Staging - the application is deployed to the staging server where several
      users do a load test
    * no suffix - the application is in production

## Versioning with sycversion
_sycersion_ is incrementing the current version of the application at the
position that is indicated as a parameter (major, minor, patch) and
optionally appended the suffix if provided.

    $ sycersion --increment minor --suffix staging

If the there is no version set yet this will create a version 0.1.0-beta.
Alternatively an initial version can be provided

    $ sycersion --major 1 --minor 1 --patch 0 --suffix beta

Which will create a version __1.1.0-beta__.

Determining the current version is following a retrievement strategy from 1
to 3:

1. Read from Git the current version tag
2. Read from a version file
3. Setting the version to 0.0.0

If the version file is available but the version cannot be read the
application informs about the issue and propose to set the version. The
original version file will then be backed up.

