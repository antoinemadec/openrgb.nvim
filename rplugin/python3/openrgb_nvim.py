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
        # vim variables
        self.vim.vars['openrgb_connection_failed'] = False
        self.mode_to_color_dict = self.vim.vars['openrgb_mode_to_color_dict']

    def connect(self):
        if self.connection_failed or self.is_connected:
            return
        try:
            self.client = OpenRGBClient(port=self.port)
            self.device = self.client.get_devices_by_type(self.device_type)[0]
            self.is_connected = True
        except:
            self.connection_failed = True
            self.vim.vars['openrgb_connection_failed'] = True
            self.vim.command(
                'echom "[vim-openrgb] cannot connect to openrgb server"')

    @pynvim.function('OpenRGBChangeColor')
    def change_color(self, args):
        vim_color = args[0]
        self.connect()
        if self.is_connected:
            r = eval("0x" + vim_color[1:3])
            g = eval("0x" + vim_color[3:5])
            b = eval("0x" + vim_color[5:7])
            self.device.set_color(RGBColor(r, g, b))

    @pynvim.function('OpenRGBChangeColorFromMode')
    def change_color_from_mode(self, args):
        vim_mode = args[0]
        vim_color = self.mode_to_color_dict.get(vim_mode, self.mode_to_color_dict['n'])
        self.change_color([vim_color])
