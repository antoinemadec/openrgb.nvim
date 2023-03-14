if exists('g:loaded_openrgb')
  finish
endif
let g:loaded_openrgb = 'yes'


"--------------------------------------------------------------
" variables
"--------------------------------------------------------------
let g:openrgb_connection_failed = 0

let g:openrgb_is_ready = 0
augroup OpenRgbNvim
  autocmd!
  autocmd VimEnter * call OpenRGBSync() | let g:openrgb_is_ready = 1
augroup END

if !exists("g:openrgb_mode_dict")
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

  " keys definition
  let s:keys_arrow =
        \ ['Key: Right Arrow', 'Key: Left Arrow', 'Key: Up Arrow', 'Key: Down Arrow',
        \ 'Key: H', 'Key: J', 'Key: K', 'Key: L', ]
  let s:keys_special = ['Key: Escape', 'Key: Space']

  " customize dict
  let s:color_normal = '#a89984'
  let s:color_insert = '#b0b846'
  let s:color_visual = '#db4740'
  let s:color_replace = '#e9b143'
  let s:color_command = '#80aa9e'
  let s:color_terminal = '#d3869b'
  " -- normal
  let g:openrgb_mode_dict['n']['main_color'] = s:color_normal
  let g:openrgb_mode_dict['n']['led_names'] = [s:keys_arrow, s:keys_special]
  " -- visual
  let g:openrgb_mode_dict['v']['main_color'] = s:color_visual
  let g:openrgb_mode_dict['v']['led_names'] = [s:keys_arrow, s:keys_special]
  let g:openrgb_mode_dict['V'] = g:openrgb_mode_dict['v']
  let g:openrgb_mode_dict[''] = g:openrgb_mode_dict['v']
  " -- insert
  let g:openrgb_mode_dict['i']['main_color'] = s:color_insert
  let g:openrgb_mode_dict['i']['led_names'] = [s:keys_arrow, s:keys_special]
  " -- replace
  let g:openrgb_mode_dict['R']['main_color'] = s:color_replace
  let g:openrgb_mode_dict['R']['led_names'] = [s:keys_arrow, s:keys_special]
  " -- command
  let g:openrgb_mode_dict['c']['main_color'] = s:color_command
  let g:openrgb_mode_dict['c']['led_names'] = [s:keys_arrow, s:keys_special]
  let g:openrgb_mode_dict['r'] = g:openrgb_mode_dict['c']
  " -- terminal
  let g:openrgb_mode_dict['t']['main_color'] = s:color_terminal
  let g:openrgb_mode_dict['t']['led_names'] = [s:keys_arrow, s:keys_special]
endif
