
import sys

CONTAINER_NAME=sys.argv[1]
SUBSCRIPTION_ID= sys.argv[2]
RESOURCEGROUP_NAME= sys.argv[3]
TENANT_ID= sys.argv[4]
PRINCIPAL_ID=sys.argv[5]
PROJECT_ID= sys.argv[6]
PROJECT_NAME= sys.argv[7]
SUBSCRIPTION_NAME= sys.argv[8]

fillers = {
    "CONTAINER-NAME":CONTAINER_NAME,
    "SUBSCRIPTION-ID": SUBSCRIPTION_ID,
    "RESOURCEGROUP-NAME": RESOURCEGROUP_NAME,
    "TENANT-ID": TENANT_ID,
    "PRINCIPAL-ID":PRINCIPAL_ID,
    "PROJECT-ID": PROJECT_ID,
    "PROJECT-NAME": PROJECT_NAME,
    "SUBSCRIPTION-NAME": SUBSCRIPTION_NAME
}

with open('config.json.template', 'r') as file :
  filedata = file.read()

# Replace the target string
for key, value in fillers.items():
    filedata = filedata.replace(key, value)

# Write the file out again
with open('config2.json', 'w') as file:
  file.write(filedata)