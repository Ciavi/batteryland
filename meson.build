project('it.lichtzeit.batteryland', 'vala', 'c', version: run_command('git', 'describe', '--tags').stdout().strip())

i18n = import('i18n')
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language: 'c')

prefix = get_option('prefix')
bindir = get_option('bindir')
datadir = get_option('datadir')

install_subdir('resources', install_dir: datadir)

subdir('po')
subdir('src')
