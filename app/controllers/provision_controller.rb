require 'pp'

class ProvisionController < ApplicationController
  protect_from_forgery except: ['index']

  def index
    pp 'PROVISION REQUEST'
    p = params.permit!.to_h
    pp p
    pp '>>> AUTH', request.headers['Authorization']
    pp JsonWebToken.decode(request.headers['Authorization']);

    network = Network.find_from_auth_token request.headers['Authorization']
    unless network
      raise ActionController::InvalidAuthenticityToken
    end

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

    args[:friendly_name] = "#{args[:manufacturer]}-#{args[:model]}-#{args[:serial_number]}"

    args[:requested_uuid_count] = p[:provision][:requested_uuid_count]

    args[:ro_ddcs] = p[:provision][:ddcs][:'read-only']
    args[:wo_ddcs] = p[:provision][:ddcs][:'write-only']

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
        # generating a password is the only time we have it in plain text to return to the client
        password = pr.mosquitto_account.generate_password!

        broker = Broker.first

        response = {
          status: 'provisioned',
          credentials: {
            mqtt_username: pr.mosquitto_account.id,
            mqtt_password: password,
          },
          broker: {
            mqtt_hostname: broker.name,
            insecure_mqtt_port: 1883,
            secure_mqtt_port: 8883
          },
          uuids: pr.devices.map { |d| d.id },
          refresh_token: pr.get_refresh_token
        }
      else
        response = { refresh_token: pr.get_refresh_token(pr.network.users.first),
                     status: 'waiting',
                     retry_time: 60
                   }
      end
    else
      args[:network] = network
      pr = ProvisionRequest.create args

#### FIXME
#      NotifyRequestMailer.with(provision_request: pr, user: pr.network.users.first).new_provisioning_request.deliver_now

      response = { uuid: pr.id,
                   status: 'waiting',
                   retry_time: 60
                 }
    end

    respond_to do |format|
      if pr
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

    p[:requested_uuid_count] ||= 1

    return true
  end

  def refresh_token
    
  end
end
