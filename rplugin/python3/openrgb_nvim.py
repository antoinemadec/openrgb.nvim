import colorsys

from openrgb import OpenRGBClient
from openrgb.utils import DeviceType, RGBColor
import pynvim


@pynvim.plugin
class OpenRGBNvim(object):
    """interface with OpenRGB"""

    def __init__(self, vim):
        self.vim = vim
        self.port = 6742
        self.device_type = DeviceType.KEYBOARD
        self.is_connected = False
        self.connection_failed = False
        self.led_names = []
        self.prev_vim_mode = ''
        # vim variables
        self.vim.vars['openrgb_connection_failed'] = False
        self.vim.vars['openrgb_led_names'] = []
        self.mode_dict = self.vim.vars['openrgb_mode_dict']

    def vim_color_to_rgb(self, vim_color):
        r = eval("0x" + vim_color[1:3])
        g = eval("0x" + vim_color[3:5])
        b = eval("0x" + vim_color[5:7])
        return (r, g, b)

    def vim_color_to_rgb_color(self, vim_color):
        return RGBColor(*self.vim_color_to_rgb(vim_color))

    def get_complementary_rgb_colors(self, vim_color, nb_colors):
        crgbs = []
        (r, g, b) = self.vim_color_to_rgb(vim_color)
        (h, s, v) = colorsys.rgb_to_hsv(r, g, b)
        cs = max(s, 0.7)
        cv = max(v, 128)
        for i in range(nb_colors):
            j = i-1
            if j < 0:
                delta = 0
            else:
                h_step = 0.25 / (nb_colors//2)
                sign = (-1, 1)[j % 2]
                delta = sign*((j//2)+1)*h_step
            ch = (h+0.5+delta) % 1.0
            (cr, cg, cb) = (int(x) for x in colorsys.hsv_to_rgb(ch, cs, cv))
            crgbs.append(RGBColor(cr, cg, cb))
        return crgbs

    def led_names_to_ids(self, names):
        ids = []
        for name in names:
            ids.append(self.led_names.index(name))
        return ids

    def connect(self):
        if self.connection_failed or self.is_connected:
            return
        try:
            self.client = OpenRGBClient(port=self.port)
            self.device = self.client.get_devices_by_type(self.device_type)[0]
            self.led_names = [self.device.data.leds[x].name for x in range(
                len(self.device.data.leds))]
            self.is_connected = True
            self.vim.vars['openrgb_led_names'] = self.led_names
        except:
            self.connection_failed = True
            self.vim.vars['openrgb_connection_failed'] = True
            self.vim.command(
                'echom "[vim-openrgb] cannot connect to openrgb server"')

    @pynvim.function('OpenRGBChangeColor')
    def change_color(self, args):
        vim_color = args[0]
        led_names = [[]]
        led_vim_colors = []
        if len(args) > 1:
            led_names = args[1]
        if len(args) > 2:
            led_vim_colors = args[2]
        # fill led_rgb_colors
        led_rgb_colors = []
        if len(led_names):
            if len(led_vim_colors):
                led_rgb_colors = [self.vim_color_to_rgb_color(
                    vim_color) for vim_color in led_vim_colors]
            else:
                # choose led_rgb_colors automatically
                led_rgb_colors = self.get_complementary_rgb_colors(
                    vim_color, len(led_names))
        self.connect()
        if self.is_connected:
            # main color
            rgb_color = self.vim_color_to_rgb_color(vim_color)
            for c in range(len(self.device.colors)):
                self.device.colors[c] = rgb_color
            # led colors
            for i, rgb_color in enumerate(led_rgb_colors):
                for c in self.led_names_to_ids(led_names[i]):
                    self.device.colors[c] = rgb_color
            # show
            self.device.show()

    @pynvim.function('OpenRGBChangeColorFromMode')
    def change_color_from_mode(self, args):
        vim_mode = args[0]
        if vim_mode == self.prev_vim_mode:
            return
        self.prev_vim_mode = vim_mode
        d = self.mode_dict.get(vim_mode, self.mode_dict['default'])
        self.change_color([d['vim_color'], d['led_names'], d['led_vim_colors']])
