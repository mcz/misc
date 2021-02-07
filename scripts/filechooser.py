#!/usr/bin/env python3

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk
import argparse

parser = argparse.ArgumentParser(description='Pick a File and output its path to STDOUT')
parser.add_argument('-d', '--directory', action="store_true", default=False, help="Pick directory instead")
parser.add_argument('-t', '--title', action="store", default="Pick...", help="Title of the dialog")
args = parser.parse_args()

if args.directory:
    dlg = Gtk.FileChooserDialog(title=args.title, parent=None, action=Gtk.FileChooserAction.SELECT_FOLDER)
else:
    dlg = Gtk.FileChooserDialog(title=args.title, parent=None, action=Gtk.FileChooserAction.SAVE)

dlg.add_button(Gtk.STOCK_CANCEL, Gtk.ResponseType.CANCEL)
dlg.add_button(Gtk.STOCK_OK, Gtk.ResponseType.ACCEPT)
response = dlg.run()
if response == Gtk.ResponseType.ACCEPT:
    print(dlg.get_filename())
    dlg.destroy()
    exit(0)
else:
    exit(1)
