pkg_name=vulcan
pkg_origin=mitre
pkg_version="0.1.0"
pkg_scaffolding="core/scaffolding-ruby"


pkg_dep=(
  core/sqlite
  core/libxml2
  core/imagemagick
  core/coreutils
  core/glibc
  core/sassc
  core/bundler
)

pkg_build_deps=(
  core/libxml2
  core/imagemagick
  core/coreutils 
  core/gcc-libs
  core/gcc
  core/glibc
)

#do_build() {
#  attach
#  make
#}


#do_prepare() {
#    do_default_prepare
#    _bundler_version="1.17.3"
#}
