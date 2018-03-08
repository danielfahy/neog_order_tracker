namespace :orders do
  desc "bulk update orders based on their tracking status"
  task status_updater: :environment do
    puts "running order status updater"
    a = OrderStatusUpdaterService.new.run
    puts "response was #{a}"
  end
end
