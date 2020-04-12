# Get a token and set the env var
```bash
export PE_INSTANCE=<PE_MASTER SERVER NAME>
export PE_USER=<your PE USERNAME>
export PE_PASS=<your PE password>

export RBAC_TOKEN=`ruby classifier_load_testing/get_rbac_token.rb`
echo $RBAC_TOKEN
```

# Create initial groups
Save the output just in case you want it for later, but you likely won't.
```bash
$INIT_OUTPUT=`ruby classifier_load_testing/init.rb`
echo $INIT_OUPUT
```

# Delete a group
The workflow is to get a groupID and set an env var, and then call delete.
The delete operation itself has a nil return if successfull.

```bash
export GROUP_NAME=all-snow-classes-vars
export GROUP_ID=`ruby classifier_load_testing/get_group_id.rb`
ruby classifier_load_testing/delete_group.rb
```
