# Installs chromedriver on a node
class selenium::node::chromedriver(
  $version = $selenium::node::chromedriver_version,
  $md5sum  = undef,
){

  $dist = $::kernel ? {
    'Windows' => 'win',
    'Darwin'  => 'mac',
    default   => 'linux'
  }

  # NOTE (mdelaney)
  # At the time of this update, there *is not* a 64-bit
  # chrome driver for Mac OS X so if we're on Darwin, we'll
  # force the 32-bit version
  #
  if $dist == 'mac' {
    $arch = '32'
  }
  else {
    $arch = $::architecture ? {
      'amd64'  => '64',
      'x86_64' => '64',
      default  => '32',
    }
  }

  $host      = 'http://chromedriver.storage.googleapis.com'
  $filename  = "chromedriver_${dist}${arch}.zip"
  $zippath   = "${conf::install_dir}/${filename}"
  $path      = "${conf::install_dir}/chromedriver"

  staging::deploy {
    $filename:
      source      => "${host}/${version}/${filename}",
      target      => $conf::install_dir,
      user        => $conf::user_name,
      group       => $conf::user_group,
      creates     => "${conf::install_dir}/chromedriver";
  }
}
