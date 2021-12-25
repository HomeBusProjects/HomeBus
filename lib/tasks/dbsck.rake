# frozen_string_literal: true

desc 'Sanity check certain database tables'
task dbsck: :environment do
  DevicesNetwork.all.each do |dn|
    count = DevicesNetwork.where(device_id: dn.device_id, network_id: dn.network_id).count
    if count > 1
      ids = DevicesNetwork.where(device_id: dn.device_id, network_id: dn.network_id).pluck(:id)
      ids.shift
      DevicesNetwork.where(id: ids).delete_all
    end
  end

  NetworksUser.all.each do |nu|
    count = NetworksUser.where(user_id: nu.user_id, network_id: nu.network_id).count
    if count > 1
      puts "NetworksUser: problem with #{count}: #{nu.user_id}, #{nu.network_id}"
    end
  end

end
