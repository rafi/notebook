---
title: Bash Parameter Expansion
date: 2017-02-12
updated:
description:
categories:
tags:
---

| Operator | Parameter Set and Not Null | Parameter Set but Null | Parameter Unset |
|------|----------------------------|------------------------|-----------------|
| ${parameter:-word} | substitute parameter | substitute word | substitute word
| ${parameter-word}  | substitute parameter | substitute null | substitute word
| ${parameter:=word} | substitute parameter | assign word     | assign word
| ${parameter=word}  | substitute parameter | substitute null | assign word
| ${parameter:?word} | substitute parameter | error, exit     | error, exit
| ${parameter?word}  | substitute parameter | substitute null | error, exit
| ${parameter:+word} | substitute word      | substitute null | substitute null
| ${parameter+word}  | substitute word      | substitute word | substitute null

## References

* [Parameter Expansions - Bash Hackers Wiki](http://wiki.bash-hackers.org/syntax/pe)
* [10.2. Parameter Substitution](http://www.tldp.org/LDP/abs/html/parameter-substitution.html)
* [Bash Parameter Expansions](http://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)
