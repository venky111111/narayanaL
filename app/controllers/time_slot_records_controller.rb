class TimeSlotRecordsController < ApplicationController



  def date_from_to
    monday = Date.today
    tuesday = monday.next_day
    wednesday = tuesday.next_day
    thursday = wednesday.next_day
    friday = thursday.next_day

    # binding.pry

    @next_five_dates = [
      { day: monday.strftime("%a"), date: monday.strftime("%d/%m/%Y") },
      { day: tuesday.strftime("%a"), date: tuesday.strftime("%d/%m/%Y") },
      { day: wednesday.strftime("%a"), date: wednesday.strftime("%d/%m/%Y") },
      { day: thursday.strftime("%a"), date: thursday.strftime("%d/%m/%Y") },
      { day: friday.strftime("%a"), date: friday.strftime("%d/%m/%Y") }
    ]

    render json: { data: { next_five_dates: @next_five_dates, time_slot: "6AM to 9PM" } }, status: :ok
  end
  
end
