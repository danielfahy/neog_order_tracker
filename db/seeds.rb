# This file should contain all the record creation needed to seed the database with its default
# values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first

    vendors = Vendor.create([{ name: 'Jet' }, { name: 'Apple' },{ name: 'Boxed' },{ name: 'Wallmart' }])
    puts 'created vendors'
      (0..10).map.with_index do |i|
        puts "creating order #{i}"

        zip = '10001'
        tracking_id = "10001#{i}"
        Order.create(
          [{ number: "number#{i}",
            tracking_id: tracking_id,
            total: 4000,
            created_at: 1.day.ago,
            address_attributes: {
              street: '94 3rd Avenue',
              city: 'New York',
              state: 'NY',
              zip_code: zip
            },
            vendor_id: 1
          }]
        )
        TrackingEvent.create(
          [{ tracking_id: tracking_id,
             status: 0,
             vendor_id: 1,
             zip_code: zip,
             duration: rand(3600),
             created_at: 1.day.ago
           },
           { tracking_id: tracking_id,
             status: 1,
             vendor_id: 1,
             zip_code: zip,
             duration: rand(18000),
             created_at: 1.day.ago
            },
           { tracking_id: tracking_id,
             status: 2,
             vendor_id: 1,
             zip_code: zip,
             duration: rand(3600),
             created_at: 1.day.ago
            },
           { tracking_id: tracking_id,
             status: 3,
             vendor_id: 1,
             zip_code: zip,
             duration: rand(3600),
             created_at: 1.day.ago
            },
           { tracking_id: tracking_id,
             status: 4,
             vendor_id: 1,
             zip_code: zip,
             duration: rand(3600),
             created_at: 1.day.ago
            }
          ])
      end

    (0..10).map.with_index do |i|
        puts "creating not normal order #{i}"

        zip = '10001'
        tracking_id = "not_normal_10001#{i}"
        Order.create(
          [{ number: "not_normal_number#{i}",
            tracking_id: tracking_id,
            tracking_status: 2,
            total: 4000,
            created_at: 1.days.ago,
            address_attributes: {
              street: '94 3rd Avenue',
              city: 'New York',
              state: 'NY',
              zip_code: zip
            },
            vendor_id: 1
          }]
        )
        TrackingEvent.create(
          [{ tracking_id: tracking_id,
             status: 0,
             vendor_id: 1,
             zip_code: zip,
             duration: 3600,
             created_at: 1.day.ago
           },
           { tracking_id: tracking_id,
             status: 1,
             vendor_id: 1,
             zip_code: zip,
             duration: 36000,
             created_at: 1.day.ago
            }
          ])
      end

      (0..3).map.with_index do |i|
        puts "creating late order #{i}"

        zip = '10001'
        tracking_id = "late_10001#{i}"
        Order.create(
          [{ number: "late_number#{i}",
            tracking_id: tracking_id,
            total: 4000,
            created_at: 1.day.ago,
            address_attributes: {
              street: '94 3rd Avenue',
              city: 'New York',
              state: 'NY',
              zip_code: zip
            },
            vendor_id: 1
          }]
        )
        TrackingEvent.create(
          [{ tracking_id: tracking_id,
             status: 0,
             vendor_id: 1,
             zip_code: zip,
             duration: rand(1800),
             created_at: 1.day.ago
           },
           { tracking_id: tracking_id,
             status: 1,
             vendor_id: 1,
             zip_code: zip,
             duration: rand(36000),
             created_at: 1.day.ago
            }
          ])
      end

    puts 'deleting fake delayed jobs'
    Delayed::Job.delete_all # couldn't figure out how to prevent callbacks
    agg_service = DailyAggregateCalculatorService.new(zip:'10001',vendor_id:1,date:Date.yesterday)
    puts ""
    puts "started running aggregation service #{Time.now.utc}"
    agg_service.run
    puts ""
    puts "finsihed running aggregation service #{Time.now.utc}"

    puts 'VendorOrderDurationAggregate same as DailyAggregate since all orders yesterday anyway..'
    attrs = DailyVendorOrderDurationAgg.first.attributes
    attrs.delete('date')
    VendorOrderDurationAggregate.create(attrs)

