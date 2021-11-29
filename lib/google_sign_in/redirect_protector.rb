require 'uri'

module GoogleSignIn
  module RedirectProtector
    extend self

    class Violation < StandardError; end

    QUALIFIED_URL_PATTERN = /\A#{URI::DEFAULT_PARSER.make_regexp}\z/

    def ensure_same_origin(target, source)
      if target.blank? || (target =~ QUALIFIED_URL_PATTERN && origin_of(target) != host_with_port(source))
        raise Violation, "Redirect target #{origin_of(target)} does not have same origin as request (expected #{host_with_port(source)})"
      end
    end

    private
      def origin_of(url)
        uri = URI(url)
        "#{uri.scheme}://#{uri.host}:#{uri.port}"
      rescue ArgumentError
        nil
      end

      def host_with_port(r)
        r.protocol + r.host_with_port
      end
  end
end
