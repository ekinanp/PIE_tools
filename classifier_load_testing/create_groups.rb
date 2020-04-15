#!/usr/bin/env ruby

require_relative './helpers'

num_nodes = get_arg("num_nodes", 0)
start_at = get_arg("start_at", 1).to_i

env_group_parent_id = get_group_id('all-snow-environments')
cv_group_parent_id = get_group_id('all-snow-classes-vars')

starting = Time.now

num_nodes.to_i.times do |node|
  node = node + start_at
  node_name = "node#{node}"
  if (node % 100) == 0
    ending = Time.now
    elapsed = ending - starting
    puts elapsed
    puts(node_name)
    starting = Time.now
  end

  if (node % 1000) == 0
    sleep 3
  end

  rule = ["=", "name", node_name]

  # Create the node's environment group
  classifier_request('Post', 'groups', {
    'name' => "#{node_name}_environment",
    'parent' => env_group_parent_id,
    'environment' => "#{node_name}_environment",
    'environment_trumps' => true,
    'rule' => rule,
    'classes' => {},
  })

  # Create the node's classes/variables group
  classifier_request('Post', 'groups', {
    'name' => "#{node_name}_classes_vars",
    'parent' => cv_group_parent_id,
    'rule' => rule,
    'classes' => {},
    'variables' => {'foo' => 5},
  })
end
