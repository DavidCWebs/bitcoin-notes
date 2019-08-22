i git pull, open the pr branch, launch the compilation, and while that's running open it up and read it in local dev
7:54 < jonatack_> pinheadmz: harding posted a good writeup on his review process during the first meeting https://gist.github.com/harding/168f82e7986a1befb0e785957fb600dd
7:55 < jonatack_> pinheadmz: and my messy WIP beginner study notes are here: https://github.com/jonatack/bitcoin-development/blob/master/how-to-review-bitcoin-core-prs.txt

Review Techniques: John Newbury (IRC)
-------------------------------------
* Download the PR branch, build and review locally
* Don't use the github webpage to review, just to leave comments
* Short script that checks out the PR branch and queries the github API to add a comment to that branch locally
* Makes it easier when I have a bunch of PRs checked out locally that I can run a `git branch` command and see what they are
* Once I have the branch locally, I'll set off a build in a VM while I look through the changes
* Run something like `git log --oneline upstream/master..` - gives me a list of all the commits in the PR branch, one per line
* Then I use a one-liner:
```sh
for commit in `git log master..HEAD --oneline | cut -d' ' -f1 | tac`; do git log -1 $commit; git difftool ${commit}{^,} --dir-diff; done
```
This is saved as `git-review` - steps through the commits one-by-one, printing the commit log to the console then opening my difftool program. I'll look at the diff, and when I quit the difftool program, git-review will step forward to the next commit.

First run through, I'll just skim everything, reading the commit logs and looking at the overall changes, so I get an idea of what the PR is doing. Then I'll go through again, but look at each commit in more detail, reviewing every line in detail.

I make extensive use of the functional tests by adding `import pdb; pdb.set_trace()` break points, and then manually running RPC commands on the nodes under test.

I pull the PR description from the github API and then use it to label the branch

Here's what my `git branch` output looks like:
```
gb
master                                fe47ae168 upstream/master                                                                          --
pr10102                               3440513a4                                                                                          -- [ryanofsky] [experimental] Multiprocess bitcoin - 
                  https://github.com/bitcoin/bitcoin/pull/10102
pr10823                               03fa5a1b4                                                                                          -- [greenaddress] Allow all mempool txs to be replaced after a configurable 
                  timeout (default 6h) - https://github.com/bitcoin/bitcoin/pull/10823
pr12360                               ab740a047                                                                                          -- [jnewbery] Bury bip9 deployments - 
                  https://github.com/bitcoin/bitcoin/pull/12360
pr13756                               66f3e9780                                                                                          -- [kallewoof] wallet: "avoid_reuse" wallet flag for improved privacy - 
                  https://github.com/bitcoin/bitcoin/pull/13756
```
There's an attribute of a git branch called `description` that you can update manually
18:56 < jb55> I personally use https://gist.github.com/piscisaureus/3342247 + git checkout -b pr${PR} refs/pull/origin/${PR}
18:56 < jnewbery> my `gb` doesn't map onto `git branch` exactly. I do some formatting on the output so it includes the description
18:57 < jnewbery> fanquake: I'm using vagrant, just the standard ubuntu bionic image
18:57 < jnewbery> I have a vagrant file that installs all the dependencies. I can share that if people want it
18:58 < jnewbery> Yes, I'll run make check and the functional tests. Not usually extended because I'm too impatient
19:00 < jnewbery> Here's my vagrant config: https://github.com/jnewbery/btc-dev YMMV


19:09 < jnewbery> There's another good resoure on profiling here: https://github.com/bitcoin/bitcoin/pull/12649/files#diff-d47c2f6882badae58f3881a6ce0a430cR89

