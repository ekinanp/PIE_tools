require 'base64'
require 'json'

require 'net/http'
require 'openssl'

def get_env_var(var)
  value = ENV[var]
  raise "#{var} environment variable is null" if value.nil?
  value
end

def get_arg(name, arg)
  value = ARGV[arg]
  raise "ARGV[#{arg}] (#{name}) is null" if value.nil?
  value
end

def classifier_request(verb, endpoint, data = nil)
  instance = get_env_var('PE_INSTANCE')
  token = get_env_var('RBAC_TOKEN')

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

def get_group_id(group_name, allGroups = nil)
  group = get_group(group_name, allGroups)
  group['id']
end

def get_group(group_name, allGroups = nil)
  allGroups = classifier_request('Get', 'groups').response.body if allGroups.nil?

  allGroups = JSON.parse(allGroups) unless allGroups.class == Array

  group = allGroups.find do |g|
    g['name'] == group_name
  end
  raise "'#{group_name}' group not found" if group.nil?
  group
end

def delete_children(parent_group_id)
  body = JSON.parse(classifier_request("get", "group-children/#{parent_group_id}?depth=1").body)
  body[0]['children'].each do |child|
    classifier_request("delete", "groups/#{child['id']}")
  end
end

def with_retry(op_name, retries, retry_delay, &block)
  nth_invocation = -1
  begin
    nth_invocation = nth_invocation + 1
    block.call()
  rescue => e
    puts("Failed '#{op_name}': #{e}")
    # Raising in begin will cause an infinite loop due to the rescue
    if nth_invocation >= retries
      raise "'#{op_name}' failed after #{retries} retries"
    end
    puts("Retrying in #{retry_delay} seconds ...")
    sleep retry_delay
    retry
  end
end

def time_block(&block)
  startTime = Time.now
  block.call()
  endTime = Time.now
  endTime - startTime
end
