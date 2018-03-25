module Twilio
  class IvrCallService
    attr_reader :response, :success

    DIRECTION_NUM = "+33752443774"
    DIGITS_OPTION = {
      forward_call: "1",
      record_voicemail: "2"
    }

    def initialize(call, params, digits)
      @call     = call
      @params   = params
      @success  = true
      @digits   = digits
      @response = Twilio::TwiML::VoiceResponse.new
    end

    def perform
      if @params[:recording_url].present?
        end_call
        update
      elsif @digits.blank?
        menu_message
        update
      elsif @digits == DIGITS_OPTION[:forward_call]
        forward_call
        @params.merge!({direction: DIRECTION_NUM})
        update
      elsif @digits == DIGITS_OPTION[:record_voicemail]
        record_voicemail
      else
        menu_message(try_again: true)
      end
    end

    private

    def forward_call
      say('Thank you for your selection. Your call will now be forwarded.')
      @response.dial(number: DIRECTION_NUM)
    end

    def record_voicemail
      say('Please, leave your message after beep. You can press star to finish your message.')
      @response.record(timeout: 10, playBeep: true, finishOnKey: '*', max_length: 15)
    end

    def menu_message(try_again: false)
      message = 'Please select an option from the following menu. Press 1 to have your call forwarded. Press 2 to leave a voicemail.'
      message = 'The input is not valid! ' + message if try_again
      say(message)
      @response.gather(timeout: 5, num_digits: 1)
    end

    def end_call
      say('Thank you. Goodbye')
      @response.hangup
    end

    def say(message)
      @response.say(message, voice: 'woman', language: 'en')
    end

    def update
      @success = @call.update_attributes(@params)
    end

  end
end