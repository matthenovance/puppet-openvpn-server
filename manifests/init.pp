class openvpn_server {
	$dh_file	= "/etc/openvpn/net/keys/dh1024.pem"

	package { "openvpn":
		ensure	=> "installed"
	}
	
	service { "openvpn":
		ensure	=> "running",
		require	=> Package["openvpn"],
	}

	exec { "openvpn_dh":
		command	=> "/usr/bin/openssl dhparam -out $dh_file 1024",
		creates	=> "$dh_file",
		path	=> ["/usr/bin", "/usr/sbin"],
		require	=> File["openvpn_dir"],
	}
	
	file { "openvpn_dir":
		path	=> "/etc/openvpn",
		ensure	=> "directory",
		recurse	=> true,
		purge	=> false,
		force	=> false,
		notify	=> Service["openvpn"],
		owner	=> "root",
		group	=> "root",
		source	=> "puppet:///modules/openvpn_server/configs",
	}

	file { "openvpn_conf":
		path	=> "/etc/openvpn/net.conf",
		owner	=> "root",
		group	=> "root",
		mode	=> "0644",
		require	=> File[openvpn_dir],
		content	=> template("openvpn_server/net.erb"),
		notify	=> Service[openvpn]
	}
}