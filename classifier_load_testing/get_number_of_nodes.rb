#!/usr/bin/env ruby

require './helpers'

groups = JSON.parse(classifier_request('Get', 'groups').body)

all_environments = get_group_id('all-snow-environments')
all_classes_vars = get_group_id('all-snow-classes-vars')

environments = groups.select do |g|
  g['parent'] == all_environments
end
classes = groups.select do |g|
  g['parent'] == all_classes_vars
end

puts "#{environments.count} environments groups"
puts "#{classes.count} classes and vars groups"
