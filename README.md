# cmp-emmet-vim

[emmet-vim][emmet] completion source for [nvim-cmp][cmp].

## Features

* Snippet expansion/jumping with your favorite snippet manager
* Snippet completion/preview
* Takes advantage of treesitter for filetype detection
* Doesn't require an extra LSP or Node

## Setup

Install using your favorite plugin manager:

```viml
Plug 'dcampos/cmp-emmet-vim'
```

Enable:

```lua
require 'cmp'.setup {
  sources = {
    { name = 'emmet_vim' }
  }
}
```

## Related projects

* [jackieaskins/cmp-emmet][cmp-emmet]
* [aca/emmet-ls][emmet-ls]
* [thendo-rambane/emmet-compe][emmet-compe] (deprecated)

[emmet]: https://github.com/mattn/emmet-vim
[cmp]: https://github.com/hrsh7th/nvim-cmp
[cmp-emmet]: https://github.com/jackieaskins/cmp-emmet
[emmet-ls]: https://github.com/aca/emmet-ls
[emmet-compe]: https://github.com/thendo-rambane/emmet-compe
