require 'pp'

class ProvisionController < ApplicationController
  protect_from_forgery except: ['index']

  def index
    pp 'PROVISION REQUEST'
#    p = params.permit!
    p = params.permit!.to_h
    pp p
    pp '>>> AUTH', request.headers['Authorization']
    pp JsonWebToken.decode(request.headers['Authorization']);

#    p = params.require(:provision).permit(:uuid,  identity: [ :manufacturer, :model, :serial_number, :pin, ], ddcs: [ 'write-only': [], 'read-only': [], 'read-write': [] ])

    pp p[:provision][:identity]
    pp 'SERIAL ', p[:provision][:identity][:serial_number]
    pp 'DDCS ', p[:provision][:ddcs]
    pp p[:provision][:ddcs][:'write-only']

    unless validate_provision(p)
      raise ActionController::ParameterMissing
    end

    args = { ip_address: request.remote_ip, status: :unanswered }
    args[:manufacturer] = p[:provision][:identity][:manufacturer]
    args[:model] = p[:provision][:identity][:model]
    args[:serial_number] = p[:provision][:identity][:serial_number]
    args[:pin] = p[:provision][:identity][:pin]
    args[:ro_ddcs] = p[:provision][:ddcs][:'read-only']
    args[:wo_ddcs] = p[:provision][:ddcs][:'write-only']
    args[:rw_ddcs] = p[:provision][:ddcs][:'read-write']

    args[:requested_uuids] = 1
    
    pp 'ARGS', args
    if args["uuid"]
      puts "trying to find uuid #{args["uuid"]}"
      pr = ProvisionRequest.find args["uuid"]
    else
      puts "trying to find serial number #{args[:serial_number]} manufacturer #{args[:manufacturer]} model #{args[:model]}"
      pr = ProvisionRequest.find_by(serial_number: args[:serial_number],
                                    manufacturer: args[:manufacturer],
                                    model: args[:model])
    end

    if pr
      if pr.accepted?
        password = pr.mosquitto_account.generate_password!

        devices = pr.devices.map { |device| device.slice(:id, :index) }
        devices.each { |device| device[:uuid] = device.delete(:id) }

        response = { uuid: pr.id,
                     status: 'provisioned',
                     mqtt_hostname: Socket.gethostname,
                     mqtt_port: 1883,
                     mqtt_username: pr.mosquitto_account.id,
                     mqtt_password: password,
                     devices: devices
                   }
      else
        response = { uuid: pr.id,
                     status: 'waiting',
                     retry_time: '60'
                   }
      end
    else
      pr = ProvisionRequest.create args
      pr.save

      if pr
        ma = pr.create_mosquitto_account(superuser: true, password: '')
        ma.generate_password!

        requested_devices.each do |device|
          dev = pr.devices.create device
        end
      end

      NotifyRequestMailer.with(provision_request: pr).new_provisioning_request.deliver_now

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

  private

  def validate_provision(params)
    p = params[:provision]

    unless p
      return false
    end


    unless p[:identity] && p[:ddcs]
      return false
    end

    i = p[:identity]
    unless i[:manufacturer]
      return false
    end

    i[:model] ||= ''
    i[:serial_number] ||= ''
    i[:pin] ||= ''

    ddcs = p[:ddcs]
    ddcs[:'read-only'] ||= []
    ddcs[:'write-only'] ||= []
    ddcs[:'read-write'] ||= []

    return true
  end
end
