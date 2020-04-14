#!/usr/bin/env ruby

require_relative './helpers'

user = get_env_var('PE_USER')
password = get_env_var('PE_PASS')
instance = get_env_var('PE_INSTANCE')

uri = URI.parse("https://#{instance}:4433/rbac-api/v1/auth/token")

data = {
  login: user,
  password: password,
  lifetime: '1d',
  description: 'token from get_rbac_token script',
  label: 'Personal Workstation Token',
}.to_json

Net::HTTP.start(uri.host, uri.port,
                use_ssl: uri.scheme == 'https',
                verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
  header = { 'Content-Type' => 'application/json' }
  request = Net::HTTP::Post.new("#{uri.path}?#{uri.query}", header)
  request.body = data
  response = http.request(request)
  raise response.body if response.code.to_i >= 400
  puts (JSON.parse(response.body))['token']
end
