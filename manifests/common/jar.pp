# By default, downloads the selenium server standalone jar from
# Google cloud storage.
class selenium::common::jar(
  $download         = true,
  $download_version = '2.41.0',
  $download_md5sum  = undef,
  $custom_path      = undef,
){

  include selenium::conf

  $path = "${selenium::conf::install_dir}/selenium-server-standalone.jar"

  file { $path:
    ensure => link,
    owner  => $selenium::conf::user_name,
    group  => $selenium::conf::user_group,
  }

  if $download {
    $host     = 'http://selenium-release.storage.googleapis.com'
    $version   = $download_version

    $templ = '<%= @version.split(".").first(2) * "." %>'
    $major_minor_version = inline_template($templ)

    $download_filename = "selenium-server-standalone-${version}.jar"
    $download_path = "${selenium::conf::install_dir}/${download_filename}"
    $jar_url = "${host}/${major_minor_version}/${download_filename}"

    staging::file { $download_filename:
      source  => $jar_url,
      target  => "${selenium::conf::install_dir}/${download_filename}",
      require => File[$selenium::conf::install_dir];
    }

    file { [ $selenium::conf::rundir, $selenium::conf::logdir, $selenium::conf::confdir ]:
      ensure  => directory,
      owner   => $selenium::conf::user_name,
      group   => $selenium::conf::user_group,
      recurse => true,
      require => File[$selenium::conf::install_dir];
    }

    File[$path] {
      target => $download_path,
    }
  } else {

    if $custom_path == undef {
      fail('custom_path argument must be specified')

    } else {
      File[$path] {
        target => $custom_path,
      }
    }
  }

}
