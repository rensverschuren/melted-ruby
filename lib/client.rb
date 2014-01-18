require 'net/telnet'

module Melted

	class UnknownCommand < StandardError; end

	class OperationTimedOut < StandardError; end

	class ArgumentMissing < StandardError; end

	class UnitNotFound < StandardError; end

	class FailedToLocateOrOpenClip < StandardError; end

	class ArgumentOutOfRange < StandardError; end

	class ServerError < StandardError; end

	class Client
		def initialize(host, port)
			@connector = Net::Telnet::new("Host" => host, "Port" => port)
			#@connector.cmd("String" => "STATUS", "Match" => /100 VTR Ready/)
		end

		def send_command(command)
			lines = []

			# Receive data and do some cleaning up
			@connector.cmd("String" => command, "Match" => /./) do |res|
				lines.concat(res.lines)
				# Remove all newline characters
				lines.map! { |line| line.gsub("\n", "") }
				# Remove empty strings
				lines.delete_if { |line| line.empty? }
			end

			status_code = lines.first[0..2].to_i
			lines.delete_at(0)

			case status_code
			when 200
				# Just OK message
				response = lines
			when 201
				# Multiline
				response = lines
			when 202
				# Singleline
				response = lines
			when 400
				raise Melted::UnknownCommand
			when 401
				raise Melted::OperationTimedOut
			when 402
				raise Melted::ArgumentMissing
			when 403
				raise Melted::UnitNotFound
			when 404
				raise Melted::FailedToLocateOrOpenClip
			when 405
				raise Melted::ArgumentOutOfRange
			when 500
				raise Melted::ServerError
			end
		end

		def get_root
			self.send_command("GET root").first
		end

		def set_root(root)
			self.send_command("SET root=#{root}")
		end

		def devices
			self.send_command("NLS")
		end

		def load_clip(unit_id, file_name)
			self.send_command("LOAD #{unit_id} #{file_name}")
		end

		def play(unit_id)
			self.send_command("PLAY #{unit_id}")
		end

		def add_unit(unit)
			self.send_command("UADD #{unit}")
		end
	end
end