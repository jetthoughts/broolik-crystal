module Broolik
  class Link
    enum ValidationStatus
      Success
      InProgress
      Error
    end

    JSON.mapping(
      id: { type: String },
      status: ValidationStatus,
      device: String,
      url: String,
      last_url: { type: String, nilable: true },
      country: { type: String, nilable: true },
      response_code: { type: UInt16, nilable: true },
      updated_at: { type: Time, converter: Time::Format.new("%FT%X.%3NZ"), nilable: true },
      redirects: { type: Array(Redirection), nilable: true }
    )

    def in_progress?
      status == ValidationStatus::InProgress
    end

    def success?
      status == ValidationStatus::Success
    end

    struct Redirection
      JSON.mapping(
        url: String,
        status_code: { type: UInt16, nilable: true }
      )
    end
  end
end
