# Order Tracker set up

First we want to clean, migrate and seed the db seeding takes a while...

`rake db:drop db:create:all db:migrate db:seed`

Using one terminal you can start the rails server
look at all seed orders with default progress (normal)

`rails server`

If you have Linux & crontab installed you can set the jobs to run in the background using

`whenever --update-crontab --set environment='development'`
`service cron start`

Alternatively you can just run the rake tasks manually

Bulk update all active orders `rake orders:status_updater`
