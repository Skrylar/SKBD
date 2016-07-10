project('midithing', 'vala', 'c')

gobject = dependency('gobject-2.0')
glib = dependency('glib-2.0')
gtk = dependency('gtk+-3.0')

executable('midithing', 'midithing.vala', 'keyboard.vala',
    dependencies: [gobject, glib, gtk])
