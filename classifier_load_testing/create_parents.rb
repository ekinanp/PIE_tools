#!/usr/bin/env ruby

require_relative './helpers'

# Create the environment group parent
begin
  allEnvironmentsID = get_group_id('All Environments')
  classifier_request('Post','groups', {
    name: 'all-snow-environments',
    environment_trumps: true,
    parent: allEnvironmentsID,
    description: 'snow environments collection',
    classes: {},
  })
rescue => e
  raise "Error creating the environment group parent: #{e}"
end

puts("Created the environment group parent (all-snow-environments)")

# Create the classes/variables group parent
begin
  allNodesID = get_group_id('All Nodes')
  classifier_request('Post','groups', {
    name: 'all-snow-classes-vars',
    parent: allNodesID,
    description: 'snow classes and vars',
    classes: {},
  })
rescue => e
  raise "Error creating the classes/variables group parent: #{e}"
end

puts("Created the classes/variables group parent (all-snow-classes-vars)")

