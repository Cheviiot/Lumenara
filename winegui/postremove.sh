#!/bin/bash
# Postremove script for WineGUI

# Update icon cache
if command -v gtk-update-icon-cache &> /dev/null; then
    gtk-update-icon-cache -f -t /usr/share/icons/hicolor 2>/dev/null || true
fi

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database /usr/share/applications 2>/dev/null || true
fi

# Compile GSettings schemas
if command -v glib-compile-schemas &> /dev/null; then
    glib-compile-schemas /usr/share/glib-2.0/schemas 2>/dev/null || true
fi

exit 0
