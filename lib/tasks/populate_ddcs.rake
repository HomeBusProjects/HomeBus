desc 'Populate device/ddc table'
task populate_ddcs: :environment do
  Device.all.each do |d|
    d.provision_request.wo_ddcs.each do |ddc_name|
      puts ddc_name

      ddc = Ddc.where(name: ddc_name).first_or_create(description: '', reference_url: '')
      d.ddcs << ddc

      perms = d.ddcs_devices.find_by(ddc: ddc)
      perms.publishable = true
      perms.save
    end

    d.provision_request.ro_ddcs.each do |ddc_name|
      puts ddc_name

      ddc = Ddc.where(name: ddc_name).first_or_create(description: '', reference_url: '')
      d.ddcs << ddc

      perms = d.ddcs_devices.find_by(ddc: ddc)
      perms.consumable = true
      perms.save
    end
  end
end

