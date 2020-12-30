if exists('g:loaded_openrgb')
  finish
endif
let g:loaded_openrgb = 'yes'

let g:openrgb_connection_failed = 0

if !exists("g:openrgb_mode_dict")
  " keys definition
  let s:keys_arrow =
        \ ['Key: Right Arrow', 'Key: Left Arrow', 'Key: Up Arrow', 'Key: Down Arrow']
  let s:keys_special = ['Key: Escape', 'Key: Left Control', 'Key: Left Windows',
        \ 'Key: Left Alt', 'Key: Left Shift']
  let s:keys_operator = ['Key: C', 'Key: D', 'Key: Y', 'Key: G']
  let s:keys_inner_a = ['Key: A', 'Key: I']
  let s:keys_text_object = ['Key: W', 'Key: P', 'Key: [',  'Key: ]', 'Key: 9', 'Key: 0']
  " default dict
  let s:default_dict = {
    \ 'vim_color': '#00000000',
    \ 'led_names': [s:keys_arrow + s:keys_special],
    \ 'led_vim_colors': []
    \ }
  let g:openrgb_mode_dict = {
        \ 'n':       copy(s:default_dict),
        \ 'i':       copy(s:default_dict),
        \ 't':       copy(s:default_dict),
        \ 'R':       copy(s:default_dict),
        \ 'v':       copy(s:default_dict),
        \ '':      copy(s:default_dict),
        \ 'V':       copy(s:default_dict),
        \ 'default': copy(s:default_dict)
        \ }
  " customize dict
  " -- normal
  let g:openrgb_mode_dict['n']['vim_color'] = '#a89984'
  let g:openrgb_mode_dict['n']['led_names'] = [
        \ s:keys_arrow + s:keys_special,
        \ s:keys_operator,
        \ s:keys_inner_a + s:keys_text_object,
        \ ]
  " -- insert
  let g:openrgb_mode_dict['i']['vim_color'] = '#83a598'
  " -- terminal
  let g:openrgb_mode_dict['t']['vim_color'] = '#b8bb26'
  " -- replace
  let g:openrgb_mode_dict['R']['vim_color'] = '#8ec07c'
  " -- visual
  let g:openrgb_mode_dict['v']['vim_color'] = '#fe8019'
  let g:openrgb_mode_dict['V'] = g:openrgb_mode_dict['v']
  let g:openrgb_mode_dict[''] = g:openrgb_mode_dict['v']
  " -- default
  let g:openrgb_mode_dict['default'] = g:openrgb_mode_dict['n']
endif
