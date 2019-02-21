# Use this file to templatize your application's native configuration files.
# See the docs at https://www.habitat.sh/docs/create-packages-configure/.
# You can safely delete this file if you don't need it.
#

secret_key_base="432bb028e0e7028534c0d482717634fc7930db5b8411ee34fc5d9c465265f9e5d1ea59f1c8bec6cb2f56fcf759aa49292be2255d4fff3a90e6a7464c6de6d7c9"
rails_env='production'

[db]
#database="<%= ENV['DATABASE_NAME'] %>"
#user="<%= ENV['DATABASE_USER'] %>"
#password="<%= ENV['DATABASE_PASS'] %>"
user="vulcanadm"
password="1qaz!QAZ1qaz!QAZ"
host="vulcan.ctp9kse964go.us-east-1.rds.amazonaws.com"
#adapter="postgresql"
#port="5432"
