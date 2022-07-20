defmodule Timestamp do
  @minute 60
  @hour 60 * @minute
  @day 24 * @hour
  @month 30 * @day
  @year 12 * @month

  def relative_timestamp(datetime) do
    total_seconds = NaiveDateTime.diff(NaiveDateTime.utc_now(), datetime, :second)
    years = (total_seconds / @year) |> floor()
    months = ((total_seconds - years * @year) / @month) |> floor()
    days = ((total_seconds - (years * @year + months * @month)) / @day) |> floor()
    hours = ((total_seconds - (years * @year + months * @month + days * @day)) / @hour) |> floor()

    minutes =
      ((total_seconds - (years * @year + months * @month + days * @day + hours * @hour)) / @minute)
      |> floor()

    seconds =
      total_seconds -
        (years * @year + months * @month + days * @day + hours * @hour + minutes * @minute)

    cond do
      years == 1 -> "1 year ago"
      years > 1 -> "#{years} years ago"
      months == 1 -> "1 month ago"
      months > 1 -> "#{months} months ago"
      days == 1 -> "1 day ago"
      days > 1 -> "#{days} days ago"
      hours == 1 -> "1 hour ago"
      hours > 1 -> "#{hours} hours ago"
      minutes == 1 -> "1 minute ago"
      minutes > 1 -> "#{minutes} minutes ago"
      seconds == 1 -> "1 second ago"
      seconds > 1 -> "#{seconds} seconds ago"
      true -> "a moment ago"
    end
  end
end
