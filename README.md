
Tree-sitter offers different features than emacs’ native
parser. two things are required to activate it:
    1. Install a Tree-sitter library for the required language.
    2. A major mode that invokes the Tree-sitter backend.

Usual naming of ts-major mode would be LANG-ts-mode,
e.g. erlang-ts-mode. i.e. we should consider renaming trerl to
erlang-ts.

# Prerequisites
- treesit (built-in for Emacs 29+)
- treesit Erlang parser binary (i.e. .so-file from [WhatsApp](https://github.com/WhatsApp/tree-sitter-erlang))
  (will be automatically installed if not already available; requires Git and
   a C/C++ compiler. See `C-h f treesit-install-language-grammar[RET]`)

# To run
`/usr/bin/emacs -Q -L trerl/ -l trerl/trerl-mode.el some/erlang/source.erl`
