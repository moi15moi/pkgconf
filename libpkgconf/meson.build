configure_file(input : 'config.h.meson',
  output : 'config.h',
  configuration : cdata)

headers = [
  'libpkgconf.h',
  'stdinc.h',
  'iter.h',
  'bsdstubs.h',
  'libpkgconf-api.h',
]
install_headers(headers, subdir : 'pkgconf/libpkgconf')
