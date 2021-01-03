# Bring RGB to life in Neovim

Change your RGB devices' color depending on Neovim's mode.\
Fast and asynchronous plugin to live your vim-life to the fullest.

| ![](https://raw.githubusercontent.com/antoinemadec/gif/master/openrgb/normal_custom.jpg) | ![](https://raw.githubusercontent.com/antoinemadec/gif/master/openrgb/insert_default.jpg) |
|:---:|:---:|
| ![](https://raw.githubusercontent.com/antoinemadec/gif/master/openrgb/normal_default.jpg) | ![](https://raw.githubusercontent.com/antoinemadec/gif/master/openrgb/visual_default.jpg) |

## Why?

- 🚀 **Fast**: snappy and completely asynchronous
- 🌍 **Universal**: works with all devices supported by [OpenRGB][OpenRGB]
- ❤️ **Flexible**: each mode's colors are customizable

## Installation

Make sure to have the following plugin in your **vimrc**:
```vim
Plug 'antoinemadec/openrgb.nvim', {'do': 'UpdateRemotePlugins'}
```

Install:
 - [OpenRGB][OpenRGB] : this is the RGB server
 - [openrgb-python][openrgb-python] : this is the RGB client

## Setup

Make sure the [OpenRGB][OpenRGB] server is running:
```bash
openrgb --server
```

And add the folowing in your **vimrc** :
  - if you don't use any **statusline** plugin, add this in your **vimrc**:
```vim
function OpenRGBStatuslineFunc()
  if g:openrgb_is_ready
    call OpenRGBChangeColorFromMode(mode())
  endif
  return ''
endfunction

if empty(&statusline)
  set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
endif
set statusline+=%{OpenRGBStatuslineFunc()}

autocmd FocusGained * call OpenRGBChangeColorFromMode(mode(), 1)
```
  - if you use [lightline][lightline], add this in your **vimrc**:
```vim
" default lightline values
let g:lightline = {}
let g:lightline.active = {
      \ 'left': [ [ 'mode', 'paste' ],
      \           [ 'readonly', 'filename', 'modified' ] ],
      \ 'right': [ [ 'lineinfo' ],
      \            [ 'percent' ],
      \            [ 'fileformat', 'fileencoding', 'filetype' ] ] }
let g:lightline.inactive = {
      \ 'left': [ [ 'filename' ] ],
      \ 'right': [ [ 'lineinfo' ],
      \            [ 'percent' ] ] }
let g:lightline.tabline = {
      \ 'left': [ [ 'tabs' ] ],
      \ 'right': [ [ 'close' ] ] }

" openrgb modifications
let g:lightline.active.left[0][0] = 'mymode'
let g:lightline.component_function = {'mymode': 'MyMode'}
function MyMode() abort
  if g:openrgb_is_ready
    call OpenRGBChangeColorFromMode(mode())
  endif
  return lightline#mode()
endfunction
autocmd FocusGained * call OpenRGBChangeColorFromMode(mode(), 1)
```

## Customization
If you don't like the default RGB colors, here is how to change it:
```vim
" default dict
let s:default_dict = {
      \ 'main_color': '#000000',
      \ 'led_names': [[]],
      \ 'led_colors': []
      \ }
let g:openrgb_mode_dict = {}
for mode in ['n', 'v', 'V', '', 'i', 'R', 'c', 'r', 't', 'default']
  let g:openrgb_mode_dict[mode] = copy(s:default_dict)
endfor

" customize dict:
"     - if dict[mode] is not found, it falls back to dict['default']
"     - each group of keys in 'led_names' are lit using the same color
"     - look at 'g:openrgb_led_names' to see the available 'led_names'
"     - if empty(led_colors):
"           colors are assigned automatically
"       else:
"           led_colors are used
" -- normal
let g:openrgb_mode_dict['n']['main_color'] = '#ffff00'
let g:openrgb_mode_dict['n']['led_names'] = [
      \ ['Key: Right Arrow', 'Key: Left Arrow', 'Key: Up Arrow', 'Key: Down Arrow'],
      \ ['Key: H', 'Key: J', 'Key: K', 'Key: L'],
      \ ['Key: Left Control', 'Key: Left Windows', 'Key: Left Alt', 'Key: Left Shift'],
      \ ['Key: Insert', 'Key: Delete', 'Key: Home', 'Key: End', 'Key: Page Up', 'Key: Page Down'],
      \ ['Key: F1', 'Key: F2', 'Key: F3', 'Key: F4'],
      \ ['Key: F5', 'Key: F6', 'Key: F7', 'Key: F8'],
      \ ['Key: F9', 'Key: F10', 'Key: F11', 'Key: F12'],
      \ ['Key: 0', 'Key: 1', 'Key: 2', 'Key: 3', 'Key: 4', 'Key: 5', 'Key: 6', 'Key: 7', 'Key: 8', 'Key: 9'],
      \ ]
" -- insert
let g:openrgb_mode_dict['i']['main_color'] = '#007020'
let g:openrgb_mode_dict['i']['led_names'] = [
      \ ['Key: F', 'Key: R'],
      \ ['Key: A', 'Key: N'],
      \ ['Key: C', 'Key: E'],
      \ ]
let g:openrgb_mode_dict['i']['led_colors'] = [
      \ '#0000ff',
      \ '#ffffff',
      \ '#ff0000'
      \ ]
```

Here is the API if you want to trigger color changes manually:
```vim
" calling OpenRGBChangeColor() using 'g:openrgb_mode_dict' info
OpenRGBChangeColorFromMode(mode, force)
" calling OpenRGBChangeColor() directly
call OpenRGBChangeColor(main_color, led_names, led_colors, force)
```

## License

MIT

[OpenRGB]:        https://gitlab.com/CalcProgrammer1/OpenRGB
[openrgb-python]: https://github.com/jath03/openrgb-python
[lightline]:      https://github.com/itchyny/lightline.vim
