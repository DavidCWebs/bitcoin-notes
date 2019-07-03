i git pull, open the pr branch, launch the compilation, and while that's running open it up and read it in local dev
17:43 < jonatack_> if anyone is looking for a recent PR to review that's not too long, there's https://github.com/bitcoin/bitcoin/pull/15996 that could use review
17:44 < jb55> looks like #15741 was merged...
17:45 < jonatack_> there has been progress on the last two PR review club PRs too...
17:45 < jonatack_> https://github.com/bitcoin/bitcoin/pull/15450 is active again
17:46 < jonatack_> and https://github.com/bitcoin/bitcoin/pull/15834
17:54 < jonatack_> pinheadmz: harding posted a good writeup on his review process during the first meeting https://gist.github.com/harding/168f82e7986a1befb0e785957fb600dd
17:55 < pinheadmz> jonatack_: tnx!
17:55 < jonatack_> pinheadmz: and my messy WIP beginner study notes are here: https://github.com/jonatack/bitcoin-development/blob/master/how-to-review-bitcoin-core-prs.txt
17:56 < jnewbery> let's discuss review/test techniques during the meeting, so people don't miss out
17:56 < pinheadmz> ah great resource too, thanks again
17:56 < jonatack_> jnewbery: sure. didn't want to derail.
17:56 < jnewbery> it's definitely on-topic!
17:57 < jnewbery> we can split the meeting today - spend some time on the PR and some on more general review techniques
17:57 < jonatack_> nice
17:57 < jnewbery> A couple of you have asked for more general advice
17:58 < ariard> yes, would be great to have more feedback on review techniques!

18:48 < jnewbery> ok, well first off, I'll always download the PR branch to my machine so I can build and review locally. I don't use the github webpage to review, just to leave comments
18:49 < jnewbery> I've got a short script that checks out the PR branch and queries the github API to add a comment to that branch locally
18:49 < jnewbery> that just makes it easier when I have a bunch of PRs checked out locally that I can run a `git branch` command and see what they are
18:50 < jnewbery> once I have the branch locally, I'll set off a build in a VM while I look through the changes
18:50 < jnewbery> first, I run something like `git log --oneline upstream/master..`
18:50 < jnewbery> that gives me a list of all the commits in the PR branch, one per line
18:51 < jnewbery> and then I use a one-liner:
18:51 < jnewbery> for commit in `git log master..HEAD --oneline | cut -d' ' -f1 | tac`; do git log -1 $commit; git difftool ${commit}{^,} --dir-diff; done
18:51 < jnewbery> which I have saved as git-review
18:52 < jnewbery> that steps through the commits one-by-one, printing the commit log to the console then opening my difftool program
18:52 < jnewbery> I'll look at the diff, and when I quit the difftool program, git-review will step forward to the next commit
18:52 < jnewbery> First run through, I'll just skim everything, reading the commit logs and looking at the overall changes, so I get an idea of what the PR is doing
18:53 < jnewbery> Then I'll go through again, but look at each commit in more detail, reviewing every line in detail
18:53 < jnewbery> hmm, what else?
18:54 < jnewbery> I make extensive use of the functional tests by adding `import pdb; pdb.set_trace()` break points, and then manually running RPC commands on the nodes under test
18:54 < jb55> jnewbery: do you pull the PR description from the api or just use the website?
18:54 < jnewbery> I pull the PR description from the github API and then use it to label the branch
18:54 < jb55> label in what sense?
18:54 < jnewbery> Here's what my `git branch` output looks like:
18:54 < jnewbery> → gb
18:55 < jnewbery> master                                fe47ae168 upstream/master                                                                          --
18:55 < jnewbery>  pr10102                               3440513a4                                                                                          -- [ryanofsky] [experimental] Multiprocess bitcoin - 
                  https://github.com/bitcoin/bitcoin/pull/10102
18:55 < jnewbery>  pr10823                               03fa5a1b4                                                                                          -- [greenaddress] Allow all mempool txs to be replaced after a configurable 
                  timeout (default 6h) - https://github.com/bitcoin/bitcoin/pull/10823
18:55 < jnewbery>  pr12360                               ab740a047                                                                                          -- [jnewbery] Bury bip9 deployments - 
                  https://github.com/bitcoin/bitcoin/pull/12360
18:55 < jnewbery>  pr13756                               66f3e9780                                                                                          -- [kallewoof] wallet: "avoid_reuse" wallet flag for improved privacy - 
                  https://github.com/bitcoin/bitcoin/pull/13756
18:55 < jnewbery> ...
18:55 < jnewbery> There's an attribute of a git branch called `description` that you can update manually
18:55 < jb55> whoa
18:55 < jb55> I did not know that
18:56 < fanquake> jnewbery what OS VM are you building in? using depends?
18:56 < jb55> I personally use https://gist.github.com/piscisaureus/3342247 + git checkout -b pr${PR} refs/pull/origin/${PR}
18:56 < fanquake> Running make check and the functional (--extended?) test after compiling?
18:56 < jnewbery> my `gb` doesn't map onto `git branch` exactly. I do some formatting on the output so it includes the description
18:57 < jnewbery> fanquake: I'm using vagrant, just the standard ubuntu bionic image
18:57 < jnewbery> I have a vagrant file that installs all the dependencies. I can share that if people want it
18:58 < michaelfolkson> Yes please
18:58 < jnewbery> Yes, I'll run make check and the functional tests. Not usually extended because I'm too impatient
18:59 < michaelfolkson> You're running tests using Travis
18:59 < michaelfolkson> ?
18:59 < jnewbery> I, like most developers, am pretty embarrassed about my workflow. It's just a bunch of stuff that's built up over the years and I'm sure there's plenty of space for optimizations
18:59 < jnewbery> Yes, I have travis set up on jnewbery/bitcoin, so whenever I push a branch to my github repo it'll get built in travis
19:00 < jnewbery> Although there's not much reason to look at that for reviewing, since the branch is already built in bitcoin/bitcoin travis
19:00 < jnewbery> Here's my vagrant config: https://github.com/jnewbery/btc-dev YMMV


19:09 < jnewbery> There's another good resoure on profiling here: https://github.com/bitcoin/bitcoin/pull/12649/files#diff-d47c2f6882badae58f3881a6ce0a430cR89

