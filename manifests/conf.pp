# Single place to define common settings for node and hub.
class selenium::conf(
  $manage_user    = true,
  $user_name      = 'selenium',
  $user_options   = {},
  $java_command   = 'java',
  $java_classpath = [],
  $java_classname = 'java',
  $install_dir    = '/usr/local/selenium',
  $cleanup        = true,
){
  $user_group   = pick($user_options['group'], $user_name)
  $user_homedir = pick($user_options['homedir'], "/home/${user_name}")
  $confdir      = "${selenium::conf::install_dir}/conf"
  $rundir       = "${selenium::conf::install_dir}/run"
  $logdir       = "${selenium::conf::install_dir}/logs"
}
