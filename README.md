# mountSharePoints

## Variables:

**credFile**=/path/to/file/with/credentials

**mountPoints**="List of" "share Points" "to" "backup"

**hostname**=serve.example.ca

## Credentials

The credentials file requires a read-only username and password in plain text.  This should be protected with root-only access (600), in a directory such as /var/root/

**username**=example

**password**=changeit

## LaunchDaemon

Using Launchd, this script can run automatically.  The attached LaunchDaemon is set for every 15 minutes.
