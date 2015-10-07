# Logic required by node and hub
class selenium::common{
  include selenium::conf
  include selenium::common::jar

  ensure_supported({'Ubuntu' => ['12'], 'CentOS' => ['6'], 'Darwin' => ['10']}, true)

  if $conf::manage_user {
    include selenium::common::user
  }

  file { $conf::install_dir:
    ensure  => directory,
    owner   => $conf::user_name,
    group   => $conf::user_group,
    recurse => true,
  }

  if $conf::cleanup {
    include selenium::cleanup
  }
}
