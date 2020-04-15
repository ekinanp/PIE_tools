#!/usr/bin/env ruby

require_relative './helpers'

num_nodes = get_arg("num_nodes", 0)

env_group_parent_id = get_group_id('all-snow-environments')
cv_group_parent_id = get_group_id('all-snow-classes-vars')

allGroups = classifier_request('Get', 'groups').response.body

allGroups = JSON.parse(allGroups)

num_nodes.to_i.times do |node|
  node_name = "node#{node}"
  if (node % 100) == 0
    puts(node_name)
  end

  currentEnvGroup = get_group("#{node_name}_environment", allGroups)
  classifier_request('Put', "groups/#{currentEnvGroup['id']}", currentEnvGroup)

  currentVarsGroup = get_group("#{node_name}_classes_vars", allGroups)
  classifier_request('Put', "groups/#{currentVarsGroup['id']}", currentVarsGroup)
end
