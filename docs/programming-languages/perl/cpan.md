---
title: CPAN, CPANMinus and XDG Conformity
date: '2014-10-26'
tags:
- cpan
- cpanminus
---

Install `cpan` and `cpanminus`.

Add to bash profile:

```bash
alias cpan="cpan -j $XDG_CONFIG_HOME/cpan/config.pm"
export PATH="${PATH}:$HOME/.local/bin"
export PERL_CPANM_OPT="-l $HOME/.local"
export PERL5LIB="$HOME/.local/lib/perl5${PERL5LIB+:}${PERL5LIB}"
export PERL_LOCAL_LIB_ROOT="$HOME/.local${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"
export PERL_MB_OPT="--install_base \"$HOME/.local\""
export PERL_MM_OPT="INSTALL_BASE=$HOME/.local"
```

Re-login to your terminal and try to install a package:

```bash
cpanm local::lib
```
