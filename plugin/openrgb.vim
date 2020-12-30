if exists('g:loaded_openrgb')
  finish
endif
let g:loaded_openrgb = 'yes'

let g:openrgb_connection_failed = 0

if !exists("g:openrgb_mode_to_color_dict")
  let g:openrgb_mode_to_color_dict = {'n': "#a89984", 'i': "#83a598", 't': "#b8bb26", 'R': "#8ec07c", 'v': "#fe8019", '': "#fe8019", 'V': "#fe8019"}
endif
