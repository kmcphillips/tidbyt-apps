load("render.star", "render")
load("time.star", "time")
load("http.star", "http")

WEATHER_URL = "https://www.7timer.info/bin/civil.php?lat=45.4&lon=-75.7&ac=0&unit=metric&output=json&tzshift=0"

def main(config):
  timezone = config.get("timezone") or "America/New_York"
  now = time.now().in_location(timezone)
  lines = fuzzy_time_lines(now)
  color = "#c7cafe"
  rows = [render.Box(height = 2)]

  if len(lines) == 2:
    rows.append(
      render.Text(
        content = lines[0],
        font = "tb-8",
        color = color,
      ),
    )
    rows.append(
      render.Text(
        content = lines[1],
        font = "tb-8",
        color = color,
      ),
    )

  else:
    if len(lines) == 1:
      line = lines[0]
    else:
      line = "BAD LINE LEN = %d" % len(lines)

    rows.append(
      render.Padding(
        pad = (0, 4, 0, 4),
        child = render.Text(
          content = lines[0],
          font = "tb-8",
          color = color,
        ),
      ),
    )

  rep = http.get(WEATHER_URL)
  if rep.status_code != 200:
    weather = "ERROR"
  else:
    weather = "%d" % rep.json()["dataseries"][0]["temp2m"]

  rows.append(
    render.Padding(
      pad = (0, 4, 0, 0),
      child = render.Text(
        content = weather,
        font = "tb-8",
        color = "#ffffff"
      ),
    ),
  )

  return render.Root(
    child = render.Box(
      padding = 0,
      child = render.Column(
        expanded = True,
        cross_align = "center",
        children = rows,
      ),
    ),
  )

def fuzzy_time_lines(now):
  hour = hour_word(now.hour)
  next_hour = hour_word((now.hour + 1) % 24)

  if now.minute <= 1 or (now.minute == 2 and now.second <= 30):
    return [hour]
  elif now.minute <= 6 or (now.minute == 7 and now.second <= 30):
    return ["JUST AFTER", hour]
  elif now.minute <= 11 or (now.minute == 12 and now.second <= 30):
    return ["TEN AFTER", hour]
  elif now.minute <= 16 or (now.minute == 17 and now.second <= 30):
    return ["QUARTER AFTER", hour]
  elif now.minute <= 21 or (now.minute == 22 and now.second <= 30):
    return ["TWENTY AFTER", hour]
  elif now.minute <= 26 or (now.minute == 27 and now.second <= 30):
    return ["ALMOST", "%s THIRTY" % back_to_twelve(hour) ]
  elif now.minute <= 31 or (now.minute == 32 and now.second <= 30):
    return [back_to_twelve(hour), "THIRTY"]
  elif now.minute <= 36 or (now.minute == 37 and now.second <= 30):
    return [back_to_twelve(hour), "THIRTY FIVE"]
  elif now.minute <= 41 or (now.minute == 42 and now.second <= 30):
    return ["TWENTY TO", next_hour]
  elif now.minute <= 46 or (now.minute == 47 and now.second <= 30):
    return ["QUARTER TO", next_hour]
  elif now.minute <= 51 or (now.minute == 52 and now.second <= 30):
    return ["TEN TO", next_hour]
  elif now.minute <= 56 or (now.minute == 57 and now.second <= 30):
    return ["ALMOST", next_hour]
  elif now.minute <= 59:
    return [next_hour]
  else:
    return ["%s-ISH" % hour]

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

def back_to_twelve(hour):
  if hour == "MIDNIGHT" or hour == "NOON":
    return "TWELVE"
  else:
    return hour
