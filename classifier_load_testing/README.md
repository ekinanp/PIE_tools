# Get a token and set the env var
```bash
export PE_INSTANCE=<PE_MASTER SERVER NAME>
export PE_USER=<your PE USERNAME>
export PE_PASS=<your PE password>

export RBAC_TOKEN=`./get_rbac_token.rb`
echo $RBAC_TOKEN
```

# Create initial groups
Save the output just in case you want it for later, but you likely won't.

This script will create two parent groups:
`all-snow-classes-vars` to hold the top level classes and variables for each node.
`all-snow-environments` to specify the environment for each node individually.

```bash
$INIT_OUTPUT=`./create_parents.rb`
echo $INIT_OUPUT
Created the environment group parent (all-snow-environments) Created the classes/variables group parent (all-snow-classes-vars)
```

# Create groups for nodes

```bash
./create_groups.rb '20'
```

# Delete a group
If the group you want to delete has children, delete them first.

```bash
./delete_children.rb 'all-snow-classes-vars'
./delete_children.rb 'all-snow-environments'
./delete_group.rb 'all-snow-classes-vars'
./delete_group.rb 'all-snow-environments'
```
