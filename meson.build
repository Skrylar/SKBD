project('midithing', 'vala', 'c')

gobject = dependency('gobject-2.0')
glib = dependency('glib-2.0')
gtk = dependency('gtk+-3.0')
jack = dependency('jack')

executable('midithing', 'midithing.vala', 'keyboard.vala', 'jack-adapter.vala',
    vala_args: ['--vapidir', meson.source_root(), '--pkg', 'jack', '--pkg', 'posix'],
    c_args: ['-w'],
    dependencies: [gobject, glib, gtk, jack])
