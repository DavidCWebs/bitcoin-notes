# Git Workflow: Pull Requests
For testing purposes, merge a remote branch associated with a pull request.

Select the pull request on the `origin` (e.g. GitHub, Bitbucket) repo.

Get the ID number of the pull request, and give it a descriptive branch name (for local use only). You can then fetch the reference to the pull request based on the ID number, into the new branch:

* Under the repo on GitHub, click "Pull Requests"
* Find the Pull Request to merge
* Get the Pull Request ID and download according to the following format:

```bash
git fetch origin pull/<ID>/head:<Local branch name>
```

Example
-------
If the pull request id is `#666`, and you decide that the branch should be 'cool-new-feature':

```bash
git fetch origin pull/666/head:cool-new-feature
```
The pull request is fetched to a new branch, whcih you can now switch to.

```bash
git branch # list branches
git checkout cool-new-feature 
```

View Differences
----------------

```bash
git diff master cool-new-feature 
git diff --names-only master cool-new-feature
```

You can now make local changes, before pushing the new branch up:

```bash
git push origin cool-new-feature
```
References
----------
* [Checking out pull requests locally][1]
* [Merging pull request][2]


[1]: https://help.github.com/en/articles/checking-out-pull-requests-locally
[2]: https://help.github.com/en/articles/merging-a-pull-request
