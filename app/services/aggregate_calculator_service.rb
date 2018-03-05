class AggregateCalculatorService
  def initialize(zip:, vendor_id:)
    @zip = zip
    @vendor = Vendor.find(vendor_id)
  end

  attr_reader :zip, :vendor

  def run
    #TODO
    # implement service that iterates over all daily aggregates
    # and generates one per zip & vendor
    # DailyVendorOrderDurationAgg
  end
end