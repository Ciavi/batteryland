version_file = vcs_tag(
    command: ['git', 'describe', '--tags'],
    input: 'version.vala.in',
    output: 'version.vala'
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
    'app.vala', 'upower.vala', 'about_window.vala', 'indicator.vala', version_file
]

executable(meson.project_name(), sources, dependencies: dependencies)