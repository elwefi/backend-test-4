class Api::TwilioController < ApplicationController
  before_action :set_call, only: [:ivr_welcome, :call_status_change]

  def ivr_welcome
    service = Twilio::IvrCallService.new(@call, call_params, params['Digits'])
    service.perform
    return render xml: service.response.to_s, status: :ok if service.success
  end

  # Update the status whene the call is completed.
  def call_status_change
    @call.update_attributes(
      status: params['CallStatus'],
      duration: params['CallDuration']
    )
  end

  private

    # Find or initialize the call
    def set_call
      @call ||= Call.find_or_initialize_by(sid: params['CallSid'])
    end

    def call_params
      {
        from: params['From'],
        to: params['To'],
        status: params['CallStatus'],
        recording_url: params['RecordingUrl'],
        recording_duration: params['RecordingDuration']
      }
    end
end