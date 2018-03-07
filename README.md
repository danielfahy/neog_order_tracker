rake db:drop db:create:all db:migrate db:seed
rails server (look at all seed orders with default progress as normal)
whenever --update-crontab --set environment='development'
service cron start

# if you don't have linux or crontab is not working simply run

`rake orders:status_updater` manually for status updates
