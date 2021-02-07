#!/usr/bin/env python3

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk
import argparse

parser = argparse.ArgumentParser(description='Pick a File and output its path to STDOUT')
parser.add_argument('-t', '--title', action="store", default="Pick a color...", help="Title of the dialog")
parser.add_argument('-X', '--X', action="store_true", default=False, help="Output in a form suitable for X")
parser.add_argument('-a', '--all', action="store_true", default=False, help="Output in multiple formats and precisions")
args = parser.parse_args()

dlg = Gtk.ColorSelectionDialog(title=args.title)

response = dlg.run()
if response == Gtk.ResponseType.OK:

    col = dlg.get_color_selection().get_current_rgba()
    red = hex(int(col.red * 0xffff))[2:]
    green = hex(int(col.green * 0xffff))[2:]
    blue = hex(int(col.blue * 0xffff))[2:]

    if not args.X:
        print('R:', col.red, '\nG:', col.green, '\nB:', col.blue)
        print('#' + red[:2] + green[:2] + blue[:2])
        print('#' + red + green + blue)

    print('rgb:' + red + '/' + green  + '/' + blue)

    dlg.destroy()
    exit(0)

else:
    exit(1)
