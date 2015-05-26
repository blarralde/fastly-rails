module FastlyRails
  module CacheControlHeaders
    extend ActiveSupport::Concern

    helper_method :csrf_disabled?

    # Sets Cache-Control and Surrogate-Control HTTP headers
    # Surrogate-Control is stripped at the cache, Cache-Control persists (in case of other caches in front of fastly)
    # Defaults are:
    #  Cache-Control: 'public, no-cache'
    #  Surrogate-Control: 'max-age: 30 days
    # custom config example:
    #  {cache_control: 'public, no-cache, maxage=xyz', surrogate_control: 'max-age: blah'}
    def set_cache_control_headers(max_age = FastlyRails.configuration.max_age, opts = {})
      if flash.empty?  # don't cache if there's something in the flash
        request.session_options[:skip] = true    # no cookies
        disable_csrf!
        response.headers['Cache-Control'] = opts[:cache_control] || "public, no-cache"
        response.headers['Surrogate-Control'] = opts[:surrogate_control] || "max-age=#{max_age}"
      end
    end

    private
      def disable_csrf!
        @csrf_disabled = true
      end

      def csrf_disabled?
        @csrf_disabled
      end
  end
end
