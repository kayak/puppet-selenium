# Installs geckodriver on a node
class selenium::node::geckodriver(
  $version = $selenium::node::geckodriver_version,
  $md5sum  = undef,
) {

  $dist = $::kernel ? {
    'Windows' => 'win',
    'Darwin'  => 'macos',
    default   => 'linux'
  }

  if $dist == 'macos' {
    $arch = ''
  } else {
    $arch = $::architecture ? {
      'amd64'  => '64',
      'x86_64' => '64',
      default  => '32',
    }
  }

  if $dist == 'win' {
    $archive_ext = '.zip'
    $binary_ext  = '.exe'
  } else {
    $archive_ext = '.tar.gz'
    $binary_ext  = ''
  }


  $url_base = "https://github.com/mozilla/geckodriver/releases/download/v${version}"
  $filename = "geckodriver-v${version}-${dist}${arch}${archive_ext}"
  $zippath  = "${selenium::conf::install_dir}/${filename}"
  $path     = "${selenium::conf::install_dir}/geckodriver${binary_ext}"

  staging::deploy {
    $filename:
      source  => "${url_base}/${filename}",
      target  => $selenium::conf::install_dir,
      user    => $selenium::conf::user_name,
      group   => $selenium::conf::user_group,
      creates => "${selenium::conf::install_dir}/geckodriver${binary_ext}",
    ;
  }
}
