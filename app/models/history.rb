class History < ApplicationRecord
  belongs_to :soul
  belongs_to :device

  def self.get_history_by_device_id (device_id) #returns an relation of soul objects that the device received up to 2 days ago
    return Soul.where(id: History.where(device: device_id).where('created_at >= ?', 2.days.ago).pluck(:soul_id))
  end

  def self.get_history_by_history_obj (history_object) #returns an relation of soul objects that the device received up to 2 days ago
    return Soul.where(id: History.where(device: history_object.device_id).where('created_at >= ?', 2.days.ago).pluck(:soul_id))
    #equiv to SELECT * FROM souls IN (matching soul_ids)
  end

  def self.make_history(inputSoul, inputDevices)
    puts "##########################################Make history******************"
    puts "devices = " + inputDevices.length.to_s

    inputDevices.each do |currentDevice|
      if currentDevice.not_blocked?(inputSoul.device)
        History.create(soul: inputSoul, device: currentDevice)
      end
    end
  end
end
