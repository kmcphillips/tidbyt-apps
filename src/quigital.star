load("render.star", "render")
load("animation.star", "animation")

def main():
    return render.Root(
        child = render.Box(
          child = render.Column(
            expanded = True,
            main_align = "center",
            children = [
              animation.Transformation(
                child = render.Text(
                  content="Quigital",
                  color="#46addf",
                  font="6x13"
                ),
                duration = 20,
                delay = 20,
                height = 14,
                width = 46,
                origin = animation.Origin(0.3, 1.0),
                fill_mode = "forwards",
                keyframes = [
                  animation.Keyframe(
                    percentage = 0.0,
                    transforms = [animation.Rotate(0)],
                    curve = "ease_in_out",
                  ),
                  animation.Keyframe(
                    percentage = 0.4,
                    transforms = [animation.Rotate(-4)],
                  ),
                  animation.Keyframe(
                    percentage = 0.6,
                    transforms = [animation.Rotate(4)],
                  ),
                  animation.Keyframe(
                    percentage = 1.0,
                    transforms = [animation.Rotate(0)],
                  ),
                ],
              ),
            ],
          ),
        ),
    )
