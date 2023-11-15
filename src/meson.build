utils_conf = configuration_data()
utils_conf.set('VCS_TAG', meson.project_version())
utils_conf.set('PACKAGE', meson.project_name())
utils_conf.set('PREFIX', prefix)
utils_conf.set('BINDIR', bindir)
utils_conf.set('DATADIR', datadir)

utils_file = configure_file(
    input: 'utils.vala.in',
    output: 'utils.vala',
    configuration: utils_conf
)

dependencies = [
    dependency('ayatana-appindicator3-0.1'),
    dependency('gio-2.0'),
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk+-3.0'),
    dependency('libsoup-2.4')
]

sources = [
    'app.vala', 'upower.vala', 'about_window.vala', 'indicator.vala', utils_file
]

executable('batteryland', sources, dependencies: dependencies, install: true, install_dir: bindir)