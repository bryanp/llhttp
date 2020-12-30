# frozen_string_literal: true

require 'mkmf'

#### config ####
llhttp_version = '3.0.0'

pwd = ::File.dirname(::File.expand_path(__FILE__))

#### download the dependencies ####
release_archive_path = ::File.join(pwd, 'vendor', "release-#{llhttp_version}.tgz")
vendor_root = ::File.dirname(release_archive_path)
unless ::File.file?(release_archive_path)
  ::FileUtils.mkdir_p(vendor_root)
  `wget https://github.com/nodejs/llhttp/archive/release/v#{llhttp_version}.tar.gz -O #{release_archive_path}`
end
`tar -xf #{release_archive_path} --directory #{vendor_root} --strip-components 1`

dir_config 'llhttp_ext'
find_header('llhttp.h', *::Dir
  .glob(::File.join(pwd, '**', '*'))
  .select(&::File.method(:directory?)))

$srcs ||= []
::Dir.glob(
  ::File.join(pwd, '**', '*.c')
).each do |file|
  $srcs << file
end

::Dir.glob(
  ::File.join(vendor_root, '**', '*.c')
).map(&::File.method(:dirname)).uniq.each do |dir|
  $VPATH << dir
end

create_makefile 'llhttp_ext'
