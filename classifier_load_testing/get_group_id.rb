require_relative './helpers'

group_name = ENV['GROUP_NAME']

allGroups = classifier_request('Get', 'groups').response.body

group = JSON.parse(allGroups).find do |g|
  g['name'] == group_name
end

puts group['id']
