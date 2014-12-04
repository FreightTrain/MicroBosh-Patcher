MicroBosh-Patcher
=================

Silly little compatibility changes for default MicroBOSH deployments.

Patches Fog to:
	- Send config_drive = true with each nova request

Patches Excon to:
	- Have higher send/receive timeouts to allow for glance image conversion to succeed on upload

Symlinks /var/vcap tmp directories:
	- So that RAW stemcells have space to unpack before being upload to the IaaS
