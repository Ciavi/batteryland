project('batteryland', 'vala', 'c', version: '0.1a')

dependencies = [
    dependency('ayatana-appindicator3-0.1'),
    dependency('gio-2.0'),
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk+-3.0')
]

sources = files('app.vala', 'upower.vala')

i18n = import('i18n')
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language: 'c')

subdir('po')

executable('batteryland', sources, dependencies: dependencies)