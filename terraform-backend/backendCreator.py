
import sys

resource_group_name=sys.argv[1]
storage_account_name=sys.argv[2]
container_name=sys.argv[3]
storage_key= sys.argv[4]

fillers = {
    "resource-group-name":resource_group_name,
    "storage-account-name": storage_account_name,
    "container-name": container_name,
    "storage-key": storage_key
}

with open('backend.template', 'r') as file :
  filedata = file.read()

# Replace the target string
for key, value in fillers.items():
    filedata = filedata.replace(key, value)

# Write the file out again
with open('backend.tf', 'w') as file:
  file.write(filedata)