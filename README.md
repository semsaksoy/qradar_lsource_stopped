# Qradar Log Source Stopped Alert

This script will send an alert email automatically if log sources have been inactive for a given period of time.

Unlike the built-in rule engine, it is easy to match the recipient groups to the log source groups. The alert e-mail is also set to send an easily readable format and additional information.

*It needs cron setup and doesn't depend on api versions because it is based on to Qradar database (postgres)*

![ss1](https://user-images.githubusercontent.com/1064270/54886371-70719c00-4e98-11e9-9662-fc8a7ad1d21a.png)



Scripts are not official IBM solutions. IBM highlights [Modified (YUM) is not supported through all other installations of non-QRadar software modules, RPMs, or Yellowdog Updater](https://www-01.ibm.com/support/docview.wss?uid=swg21991208). Use at your own risk.
