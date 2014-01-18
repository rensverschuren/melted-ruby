require 'net/telnet'

module Melted
	class Client
		def initialize(host, port)
			@connector = Net::Telnet::new("Host" => host, "Port" => port)
		end

		def units
	end
end