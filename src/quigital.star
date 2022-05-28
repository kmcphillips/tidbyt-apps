load("render.star", "render")

def main():
    return render.Root(
      child = render.Column(
        expanded = True,
        main_align = "center",
        children = [
          render.Marquee(
            child = render.Text(
              content="Quigital loves you!",
              color="#46addf",
              font="6x13"
            ),
            width = 64
          ),
        ],
      ),
    )
