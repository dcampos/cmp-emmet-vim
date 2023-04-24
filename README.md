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

Note: if you don't have `mattn/emmet-vim`, install it first:

```viml
Plug 'mattn/emmet-vim'
```

## Configuration

Currently there is a single option available.

```lua
require 'cmp'.setup {
  sources = {
    {
        name = 'emmet_vim',
        option = {
            filetypes = { ... },
        }
    }
  }
}
```

### filetypes (type: string[])

***Default***: `{ 'html', 'xml', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'heex' }`

 Filetypes, including embedded filetypes, for which to enable this source.

## Related projects

* [jackieaskins/cmp-emmet][cmp-emmet]
* [aca/emmet-ls][emmet-ls]
* [thendo-rambane/emmet-compe][emmet-compe] (deprecated)

[emmet]: https://github.com/mattn/emmet-vim
[cmp]: https://github.com/hrsh7th/nvim-cmp
[cmp-emmet]: https://github.com/jackieaskins/cmp-emmet
[emmet-ls]: https://github.com/aca/emmet-ls
[emmet-compe]: https://github.com/thendo-rambane/emmet-compe
