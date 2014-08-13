class memcached (
  $port = '11211',
  $user = 'memcache',
  $maxconn = '1024',
  $cachesize = '64',
  $address = '0.0.0.0'
) {

  package {'memcached':
    ensure => present,
  }

  exec {'remove memcached from rc.d':
    command => "/usr/sbin/update-rc.d -f memcached remove"
  }

  # hack to not create dependency cycle
  file { 'remove config file':
    path => '/etc/init.d/./memcached',
    ensure => absent,
  }

  exec {'stop memcached':
    command => "/etc/init.d/memcached stop",
    path => "/root",
    onlyif => 'test -f /etc/init.d/memcached'
  }

  file {'/etc/init/memcached.conf':
    owner => 'root',
    group => 'root',
    mode => 'u=rw,go=r',
    content => template("${module_name}/memcached.conf.erb"),
  }

  service {'start memcached':
    name => 'memcached',
    ensure => running,
    provider => upstart
  }

  Package['memcached'] -> Exec['stop memcached'] -> Exec['remove memcached from rc.d'] -> File['remove config file'] -> File['/etc/init/memcached.conf'] -> Service['start memcached']
}