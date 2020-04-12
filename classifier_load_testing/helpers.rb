require 'base64'
require 'json'

require 'net/http'

def classifier_request(verb, endpoint, data = nil)
  
  instance = ENV['PE_INSTANCE']
  token = ENV['RBAC_TOKEN']

  throw "PE_INSTANCE environmet variable is null" if instance.nil?
  throw "RBAC_TOKEN environment variable is null" if token.nil?

  uri = URI.parse("https://#{instance}:4433/classifier-api/v1/#{endpoint}")

  Net::HTTP.start(uri.host, uri.port,
                  use_ssl: uri.scheme == 'https',
                  verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
    header = {'Content-Type' => 'application/json', 'X-Authentication' => token }
    request = Object.const_get("Net::HTTP::#{verb.capitalize}").new("#{uri.path}?#{uri.query}", header)
    request.body = data.to_json unless data.nil?
    response = http.request(request)
    raise response.body if response.code.to_i >= 400
    response
  end
end