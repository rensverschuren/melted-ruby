module Melted
	class UnknownCommand < StandardError; end

	class OperationTimedOut < StandardError; end

	class ArgumentMissing < StandardError; end

	class UnitNotFound < StandardError; end

	class FailedToLocateOrOpenClip < StandardError; end

	class ArgumentOutOfRange < StandardError; end

	class ServerError < StandardError; end
end