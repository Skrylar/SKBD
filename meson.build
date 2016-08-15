project('skbd', 'vala', 'c')

gnome = import('gnome')

gobject = dependency('gobject-2.0')
glib = dependency('glib-2.0')
gtk = dependency('gtk+-3.0')
jack = dependency('jack')

resource_xml = files ('skbd.gresources.xml')
resource = gnome.compile_resources ('skbd', 'skbd.gresources.xml', source_dir: '.', c_name: 'skbd')

executable('skbd',
    'midithing.vala', 'keyboard.vala', 'jack-adapter.vala', 'event.vala', 'capture-key.vala', 'settings.vala', resource,
    vala_args: ['--vapidir', meson.source_root(), '--pkg', 'jack', '--pkg', 'posix', '--target-glib=2.38', '--gresources', resource_xml],
    c_args: ['-w'],
    dependencies: [gobject, glib, gtk, jack])
