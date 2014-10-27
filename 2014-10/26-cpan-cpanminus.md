# CPAN and CPANMinus
By Rafael Bodill

Install `cpan` and `cpanminus`.

Add to profile:
```sh
alias cpan="cpan -j $XDG_CONFIG_HOME/cpan/config.pm"
export PATH="${PATH}:$HOME/.local/bin"
export PERL_CPANM_OPT="-l $HOME/.local"
export PERL5LIB="$HOME/.local/lib/perl5${PERL5LIB+:}${PERL5LIB}"
export PERL_LOCAL_LIB_ROOT="$HOME/.local${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"
export PERL_MB_OPT="--install_base \"$HOME/.local\""
export PERL_MM_OPT="INSTALL_BASE=$HOME/.local"
```

Install `local::lib`: `$ cpanm local::lib`

Now you can install 
