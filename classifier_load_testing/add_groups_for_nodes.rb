require_relative './helpers'
require 'securerandom'

loopcount = ENV['LOOPCOUNT']

allGroups = classifier_request('Get', 'groups').response.body

allGroups = JSON.parse(allGroups)

all_snow_classes_vars = allGroups.find do |g|
  g['name'] == 'all-snow-classes-vars'
end

all_snow_environments = allGroups.find do |g|
  g['name'] == 'all-snow-environments'
end

raise "all_snow_classes_vars not found" if all_snow_classes_vars.nil?
raise "all_snow_environments not found" if all_snow_environments.nil?

loopcount.to_i.times do
  uuid = SecureRandom.uuid

  data = {
    name: "#{uuid}-environment",
    parent: all_snow_environments['id'],
    environment: 'production',
    classes: {
      'role::example': {}
    },
  }

  response = classifier_request('Post', 'groups', data)
  response
end