require 'net/https'

module FastlyRails
  class Client
    API_ENDPOINT = 'api.fastly.com'

    def initialize(opts={})
      @api_key = opts[:api_key]
      @service_id = opts[:service_id]
    end

    def purge_by_key(key)
      http = Net::HTTP.new(API_ENDPOINT)

      request = Net::HTTP::Post.new(purge_url(key))
      request['Fastly-Key'] = @api_key
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.request(request)

      response.status == 200
    end

    def purge_url(key)
      "/service/#{@service_id}/purge/#{key}"
    end
  end
end
