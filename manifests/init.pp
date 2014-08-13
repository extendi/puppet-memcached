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
  file { '/etc/init.d/./memcached':
    ensure => absent
  }

  service {'stop memcached':
    ensure => stopped
  }

  file {'/etc/init/memcached.conf':
    owner => 'root',
    group => 'root',
    mode => 'u=rw,go=r',
    content => template("${module_name}/memcached.conf.erb"),
  }

  service {'memcached':
    ensure => running,
    provider => upstart
  }

  Package['memcached'] -> Exec['remove memcached from rc.d'] -> File['/etc/init.d/./memcached'] -> Service['stop memcached'] -> File['/etc/init/memcached.conf'] -> Service['memcached']
}