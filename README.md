# AWS Documentation

## Overview

This repo contains submodules for each of the documentation repositories owned
by <https://github.com/awsdocs>. The submodules were added via the
[`clone-repos.sh`](clone-repos.sh) script, which leverages the GitHub API.

In order to update existing submodules, simply run the following command:
```
git submodule update --remote --depth 1
```

## Upcoming features

1. Invoking `clone-repos.sh` will clone repositories that have been added to
   the `awsdocs` organization since the last invocation of `clone-repos.sh`.

2. A new script called `prune-repos.sh` will remove repositories that have
   since been removed from the `awsdocs` organization.

3. A `Makefile` will be added to allow generation of different offline
   documentation formats, including Texinfo (for reference inside Emacs).
