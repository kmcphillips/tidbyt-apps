load("render.star", "render")
load("time.star", "time")

def main(config):
  timezone = config.get("timezone") or "America/New_York"
  now = time.now().in_location(timezone)

  return render.Root(
    child = render.Box(
      padding=4,
      child = render.WrappedText(
        content = fuzzy_time_string(now),
        font = "5x8",
        color = "#c7cafe"
      ),
    ),
  )

def fuzzy_time_string(now):
  hour = hour_word(now.hour)
  next_hour = hour_word((now.hour + 1) % 24)

  if now.minute <= 1 or (now.minute == 2 and now.second <= 30):
    return "%s" % hour
  elif now.minute <= 6 or (now.minute == 7 and now.second <= 30):
    return "JUST AFTER %s" % hour
  elif now.minute <= 11 or (now.minute == 12 and now.second <= 30):
    return "TEN AFTER %s" % hour
  elif now.minute <= 16 or (now.minute == 17 and now.second <= 30):
    return "QUARTER AFTER %s" % hour
  elif now.minute <= 21 or (now.minute == 22 and now.second <= 30):
    return "TWENTY AFTER %s" % hour
  elif now.minute <= 26 or (now.minute == 27 and now.second <= 30):
    return "ALMOST %s THIRTY" % hour
  elif now.minute <= 31 or (now.minute == 32 and now.second <= 30):
    return "%s THIRTY" % hour
  elif now.minute <= 36 or (now.minute == 37 and now.second <= 30):
    return "%s THIRTY FIVE" % hour
  elif now.minute <= 41 or (now.minute == 42 and now.second <= 30):
    return "TWENTY TO %s" % next_hour
  elif now.minute <= 46 or (now.minute == 47 and now.second <= 30):
    return "QUARTER TO %s" % next_hour
  elif now.minute <= 51 or (now.minute == 52 and now.second <= 30):
    return "TEN TO %s" % next_hour
  elif now.minute <= 56 or (now.minute == 57 and now.second <= 30):
    return "ALMOST %s" % next_hour
  elif now.minute <= 59:
    return "%s" % next_hour
  else:
    return "ABOUT %s-ISH" % hour

def hour_word(hour):
  if hour == 0:
    return "MIDNIGHT"
  elif hour == 12:
    return "NOON"
  elif hour > 12:
    return hour_word(hour - 12)
  elif hour == 1:
    return "ONE"
  elif hour == 2:
    return "TWO"
  elif hour == 3:
    return "THREE"
  elif hour == 4:
    return "FOUR"
  elif hour == 5:
    return "FIVE"
  elif hour == 6:
    return "SIX"
  elif hour == 7:
    return "SEVEN"
  elif hour == 8:
    return "EIGHT"
  elif hour == 9:
    return "NINE"
  elif hour == 10:
    return "TEN"
  elif hour == 11:
    return "ELEVEN"
  else:
    return "???"
