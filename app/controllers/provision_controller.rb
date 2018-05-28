require 'pp'

class ProvisionController < ApplicationController
  protect_from_forgery except: ['index']

  def index
    p = params.require(:provision).permit(:uuid, :friendly_name, :friendly_location, :manufacturer, :model, :serial_number, :pin, devices: [ :uuid, :friendly_name, :friendly_location, :update_frequency, :accuracy, :precision, :index, :wo_topics, :ro_topics, :rw_topics ])

    args = { ip_address: request.remote_ip, status: :unanswered }.merge p
    requested_devices = args["devices"]
    args.except!("devices")

    if args["uuid"]
      puts "trying to find uuid #{args["uuid"]}"
      pr = ProvisionRequest.find args["uuid"]
    else
      puts "trying to find serial number #{args["serial_number"]} manufacturer #{args["manufacturer"]} model #{args["model"]}"
      pr = ProvisionRequest.find_by(serial_number: args["serial_number"],
                                    manufacturer: args["manufacturer"],
                                    model: args["model"])
    end

    if pr
      if pr.accepted?
        password = pr.mosquitto_account.generate_password!

        response = { uuid: pr.id,
                     status: 'provisioned',
                     mqtt_hostname: 'homebus',
                     mqtt_port: 1883,
                     mqtt_username: pr.mosquitto_account.id,
                     mqtt_password: password
                   }
      else
        response = { uuid: pr.id,
                     status: 'waiting',
                     retry_time: '60'
                   }
      end
    else
      pr = ProvisionRequest.create args
      if pr
        ma = pr.build_mosquitto_account(superuser: true)
        ma.generate_password!

        requested_devices.each do |device|
          dev = pr.devices.create device
        end
      end

      response = { uuid: pr.id,
                   status: 'waiting',
                   retry_time: '60'
                 }
    end

    respond_to do |format|
      if pr
        pp response

        format.json { render json: response, status: :created }
      else
        format.json { render json: provision_request.errors, status: :unprocessable_entity }
      end
    end


  end

end
