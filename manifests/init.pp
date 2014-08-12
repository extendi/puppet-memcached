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

  include upstart
  upstart::job { 'memcached':
    description => "Memcached upstart",
    version => "1.0",
    respawn => true,
    respawn_limit => '5 10',
    user => 'memcache',
    exec => "/usr/bin/memcached -v -m $cachesize -p $port -u $user -l $address -c $maxconn",
  }

  Package['memcached'] -> Exec['remove memcached from rc.d'] -> File['/etc/init.d/./memcached'] -> Upstart::Job['memcached']
}