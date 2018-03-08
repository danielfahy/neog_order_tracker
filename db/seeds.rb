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
      (1..20).map.with_index do |i|
        puts "creating yesterdays normal delivered orders #{i}"

        zip = ['10001','10002'].sample
        tracking_id = "#{zip}#{i}"
        vendor_id = [1,2].sample
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
            vendor_id: vendor_id
          }]
        )
        TrackingEvent.create(
          [{ tracking_id: tracking_id,
             status: 0,
             vendor_id: vendor_id,
             zip_code: zip,
             duration: 1800,
             created_at: 1.day.ago
           },
           { tracking_id: tracking_id,
             status: 1,
             vendor_id: vendor_id,
             zip_code: zip,
             duration: 3600,
             created_at: 1.day.ago
            },
           { tracking_id: tracking_id,
             status: 2,
             vendor_id: vendor_id,
             zip_code: zip,
             duration: 3600,
             created_at: 1.day.ago
            },
           { tracking_id: tracking_id,
             status: 3,
             vendor_id: vendor_id,
             zip_code: zip,
             duration: 3600,
             created_at: 1.day.ago
            },
           { tracking_id: tracking_id,
             status: 4,
             vendor_id: vendor_id,
             zip_code: zip,
             duration: 0, # delivery stage has no duraiton
             created_at: 1.day.ago
            }
          ])
      end

    (1..1000).map.with_index do |i|
        puts "creating not normal order #{i}"

        zip = '10001'
        tracking_id = "not_normal_10001#{i}"
        Order.create(
          [{ number: "not_normal_number#{i}",
            tracking_id: tracking_id,
            tracking_status: 2,
            total: 4000,
            created_at: 120.minutes.ago,
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
             duration: 1800,
             created_at: 120.minutes.ago
           },
           { tracking_id: tracking_id,
             status: 1,
             vendor_id: 1,
             zip_code: zip,
             duration: 5400,
             created_at: 110.minutes.ago
            }
          ])
      end

      (0..1000).map.with_index do |i|
        puts "creating late order #{i}"

        zip = '10001'
        tracking_id = "late_#{zip}#{i}"
        Order.create(
          [{ number: "late_number#{i}",
            tracking_id: tracking_id,
            total: 4000,
            created_at: 1.5.hours.ago,
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
             duration: nil, # not set yet because hasn't left warehouse
             created_at: 1.5.hours.ago
           }
          ])
      end

      (0..1000).map.with_index do |i|
        puts "creating late order #{i}"

        zip = '10002'
        tracking_id = "late_#{zip}#{i}"
        Order.create(
          [{ number: "late_number1#{i}",
            tracking_id: tracking_id,
            total: 4000,
            created_at: 1.5.hours.ago,
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
             duration: nil, # not set yet because hasn't left warehouse
             created_at: 1.5.hours.ago
           }
          ])
      end

    puts 'deleting fake delayed jobs'
    Delayed::Job.delete_all # couldn't figure out how to prevent callbacks

    DailyAggregateJobsQueuerService.new.run_foreground

    puts "finsihed running aggregation service #{Time.now.utc}"

    puts 'VendorOrderDurationAggregates same as DailyAggregates since all orders yesterday anyway..'

    DailyVendorOrderDurationAgg.all.each do |a|
      attrs = a.attributes
      attrs.delete('date')
      VendorOrderDurationAggregate.create(attrs)
    end

