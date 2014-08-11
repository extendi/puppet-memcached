class memcached {
  package {'memcached'}

  tidy { '/etc/init.d/memcached',
    require => Package['memcached']
  }

  include upstart
  upstart::job { 'memcached':
    description => "Memcached upstart",
    version => "1.0",
    respawn => true,
    respawn_limit => "5 10",
    user => 'memcache',
    exec => '/usr/bin/memcached -v -m 1024 -p 11211 -u memcache -l 0.0.0.0 -c 1024 -I 1'
    require => Tidy['/etc/init.d/memcached'],
  }
}