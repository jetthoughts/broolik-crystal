require "json"

module Broolik
  class Batch
    enum State
      Created
      LinksAttached
      ReportComplete
    end

    JSON.mapping(
      id: {type: String},
      status: State,
      links_report: {type: String, nilable: true},
      updated_at: {type: Time, converter: Time::Format.new("%FT%X.%3NZ"), nilable: true}
    )

    def created?
      status == State::Created
    end

    def report_complete?
      status == State::ReportComplete
    end

    def links_attached?
      status == State::LinksAttached
    end
  end
end
