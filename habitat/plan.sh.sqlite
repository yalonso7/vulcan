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
  core/libxslt
  #core/ruby
  #core/bundler
)

pkg_build_deps=(
  core/libxml2
  core/imagemagick
  core/coreutils 
  core/gcc-libs
  core/gcc
  core/glibc
  core/libffi
  core/make
  core/sassc
  core/libxslt
  #core/ruby
  core/sqlite
)

#do_build() {
#  attach
#  make
#}


do_prepare() {
    do_default_prepare
    _bundler_version="1.17.3"

  #local _bundler_dir
  #_bundler_dir=$(pkg_path_for bundler)

  #export GEM_HOME=${pkg_path}/vendor/bundle
  #export GEM_PATH=${_bundler_dir}:${GEM_HOME}

  # Bundler/gem seems to set the rpath for compiled extensions using LD_RUN_PATH.
  # Dynamic linking fails if this is not set
  LD_RUN_PATH="$(pkg_path_for gcc-libs)/lib:$(pkg_path_for libffi)/lib:$(pkg_path_for sqlite)/lib:$(pkg_path_for libxml2)/lib:$(pkg_path_for imagemagick)/lib:$(pkg_path_for coreutils)/lib:$(pkg_path_for sassc)/lib:$(pkg_path_for glibc)/lib:$(pkg_path_for libxslt)/lib"
  export LD_RUN_PATH
}
