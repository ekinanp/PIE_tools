#!/usr/bin/env ruby

require_relative './helpers'

num_nodes = get_arg("num_nodes", 0)

env_group_parent_id = get_group_id('all-snow-environments')
cv_group_parent_id = get_group_id('all-snow-classes-vars')

num_nodes.to_i.times do |node|
  node_name = "node#{node}"
  rule = ["~", "name", node_name]

  # Create the node's environment group
  classifier_request('Post', 'groups', {
    'name' => "#{node_name}",
    'parent' => env_group_parent_id,
    'environment' => "#{node_name}_environment",
    'environment_trumps' => true,
    'rule' => rule,
    'classes' => {},
  })

  # Create the node's classes/variables group
  classifier_request('Post', 'groups', {
    'name' => "#{node_name}",
    'parent' => cv_group_parent_id,
    'rule' => rule,
    'classes' => {
      'puppet_enterprise::profile::agent' => {},
    },
  })
end
