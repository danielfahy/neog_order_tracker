namespace :orders do
  desc "bulk update orders based on their tracking status"
  task status_updater: :environment do
    OrderStatusUpdaterService.new.run
  end
end
