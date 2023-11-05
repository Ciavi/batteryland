project('batteryland', 'vala', 'c', version: run_command('git', 'describe', '--tags').stdout().strip())

i18n = import('i18n')
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language: 'c')

subdir('po')
subdir('src')
