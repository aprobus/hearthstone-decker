
Time::DATE_FORMATS[:date] = lambda do |time|
  time.strftime("%m/%d/%Y")
end