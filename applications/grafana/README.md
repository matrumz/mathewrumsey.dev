TODO
- Allow alloy to run as root to streamline docker socket access
- grafana does some user perm checking during startup, so I'm avoiding any user customization for now to prevent potential issues. If I want to customize the user in the future, I'll need to make sure grafana can identify the user and group by their IDs
- compose visualization, similar to k8s dashboard, to show how the services are connected and what volumes are being used
- utilizing `network_mode: none` for containers without manually-set networks prevents the creation of the "*_default" network, which is nice for keeping the network list clean and avoiding confusion about which network a container is on.
- prometheus not yet set up to be super useful
