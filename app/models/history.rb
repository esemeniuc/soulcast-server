class History < ApplicationRecord
  belongs_to :soul
  belongs_to :device

  def self.get_history_by_device_id (device_id)
    Soul.where(id: History.where(device: device_id).pluck(:soul_id))
  end

  def self.make_history(inputSoul, inputDevices)
    puts "made history for " + inputDevices.count.to_s + " devices (incl blocked)"

    inputDevices.each do |currentDevice|
      if currentDevice.not_blocked?(inputSoul.device)
        History.create(soul: inputSoul, device: currentDevice)
      end
    end
  end
end
