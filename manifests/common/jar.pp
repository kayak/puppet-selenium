# By default, downloads the selenium server standalone jar from
# Google cloud storage.
class selenium::common::jar(
  $download         = true,
  $download_version = '2.41.0',
  $download_md5sum  = undef,
  $custom_path      = undef,
){

  include selenium::conf

  $path = "${conf::install_dir}/selenium-server-standalone.jar"

  file { $path:
    ensure => link,
    owner  => $conf::user_name,
    group  => $conf::user_group,
  }

  if $download {
    $host     = 'http://selenium-release.storage.googleapis.com'
    $version   = $download_version

    $templ = '<%= @version.split(".").first(2) * "." %>'
    $major_minor_version = inline_template($templ)

    $download_filename = "selenium-server-standalone-${version}.jar"
    $download_path = "${conf::install_dir}/${download_filename}"
    $jar_url = "${host}/${major_minor_version}/${download_filename}"

    staging::file { $download_filename:
      source  => $jar_url,
      target  => "${conf::install_dir}/${download_filename}",
      require => File[$conf::install_dir];
    }

    file { [$conf::rundir, $conf::logdir, $conf::confdir]:
      ensure  => directory,
      owner   => $conf::user_name,
      group   => $conf::user_group,
      recurse => true,
      require => File[$conf::install_dir];
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
