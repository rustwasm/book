# Adding Interactivity

We will continue to explore the JavaScript and WebAssembly interface by adding
some interactive features to our Game of Life implementation. We will enable
users to toggle whether a cell is alive or dead by clicking on it, and
allow pausing the game, which makes drawing cell patterns a lot easier.

## Pausing and Resuming the Game

Let's add a button to toggle whether the game is playing or paused. To
`wasm-game-of-life/www/index.html`, add the button right above the `<canvas>`:

```html
<button id="play-pause"></button>
```

In the `wasm-game-of-life/www/index.js` JavaScript, we will make the following
changes:

* Keep track of the identifier returned by the latest call to
  `requestAnimationFrame`, so that we can cancel the animation by calling
  `cancelAnimationFrame` with that identifier.

* When the play/pause button is clicked, check for whether we have the
  identifier for a queued animation frame. If we do, then the game is currently
  playing, and we want to cancel the animation frame so that `renderLoop` isn't
  called again, effectively pausing the game. If we do not have an identifier
  for a queued animation frame, then we are currently paused, and we would like
  to call `requestAnimationFrame` to resume the game.

Because the JavaScript is driving the Rust and WebAssembly, this is all we need
to do, and we don't need to change the Rust sources.

We introduce the `animationId` variable to keep track of the identifier returned
by `requestAnimationFrame`. When there is no queued animation frame, we set this
variable to `null`.

```js
let animationId = null;

// This function is the same as before, except the
// result of `requestAnimationFrame` is assigned to
// `animationId`.
const renderLoop = () => {
  drawGrid();
  drawCells();

  universe.tick();

  animationId = requestAnimationFrame(renderLoop);
};
```

At any instant in time, we can tell whether the game is paused or not by
inspecting the value of `animationId`:

```js
const isPaused = () => {
  return animationId === null;
};
```

Now, when the play/pause button is clicked, we check whether the game is
currently paused or playing, and resume the `renderLoop` animation or cancel the
next animation frame respectively. Additionally, we update the button's text
icon to reflect the action that the button will take when clicked next.

```js
const playPauseButton = document.getElementById("play-pause");

const play = () => {
  playPauseButton.textContent = "⏸";
  renderLoop();
};

const pause = () => {
  playPauseButton.textContent = "▶";
  cancelAnimationFrame(animationId);
  animationId = null;
};

playPauseButton.addEventListener("click", event => {
  if (isPaused()) {
    play();
  } else {
    pause();
  }
});
```

Finally, we were previously kick-starting the game and its animation by calling
`requestAnimationFrame(renderLoop)` directly, but we want to replace that with a
call to `play` so that the button gets the correct initial text icon.

```diff
// This used to be `requestAnimationFrame(renderLoop)`.
play();
```

Refresh [http://localhost:8080/](http://localhost:8080/) and we should now be
able to pause and resume the game by clicking on the button!

## Toggling a Cell's State on `"click"` Events

Now that we can pause the game, it's time to add the ability to mutate the cells
by clicking on them.

To toggle a cell is to flip its state from alive to dead or from dead to
alive. Add a `toggle` method to `Cell` in `wasm-game-of-life/src/lib.rs`:

```rust
impl Cell {
    fn toggle(&mut self) {
        *self = match *self {
            Cell::Dead => Cell::Alive,
            Cell::Alive => Cell::Dead,
        };
    }
}
```

To toggle the state of a cell at given row and column, we translate the row and
column pair into an index into the cells vector and call the toggle method on
the cell at that index:

```rust
/// Public methods, exported to JavaScript.
#[wasm_bindgen]
impl Universe {
    // ...

    pub fn toggle_cell(&mut self, row: u32, column: u32) {
        let idx = self.get_index(row, column);
        self.cells[idx].toggle();
    }
}
```

This method is defined within the `impl` block that is annotated with
`#[wasm_bindgen]` so that it can be called by JavaScript.

In `wasm-game-of-life/www/index.js`, we listen to click events on the `<canvas>`
element, translate the click event's page-relative coordinates into
canvas-relative coordinates, and then into a row and column, invoke the
`toggle_cell` method, and finally redraw the scene.

```js
canvas.addEventListener("click", event => {
  const boundingRect = canvas.getBoundingClientRect();

  const scaleX = canvas.width / boundingRect.width;
  const scaleY = canvas.height / boundingRect.height;

  const canvasLeft = (event.clientX - boundingRect.left) * scaleX;
  const canvasTop = (event.clientY - boundingRect.top) * scaleY;

  const row = Math.min(Math.floor(canvasTop / (CELL_SIZE + 1)), height - 1);
  const col = Math.min(Math.floor(canvasLeft / (CELL_SIZE + 1)), width - 1);

  universe.toggle_cell(row, col);

  drawGrid();
  drawCells();
});
```

Rebuild with `wasm-pack build` in `wasm-game-of-life`, then refresh
[http://localhost:8080/](http://localhost:8080/) again and we can now draw our
own patterns by clicking on the cells and toggling their state.

## Exercises

* Introduce an [`<input type="range">`][input-range] widget to control how many
  ticks occur per animation frame.

* Add a button that resets the universe to a random initial state when
  clicked. Another button that resets the universe to all dead cells.

* On `Ctrl + Click`, insert a
  [glider](https://en.wikipedia.org/wiki/Glider_(Conway%27s_Life)) centered on
  the target cell. On `Shift + Click`, insert a pulsar.

[input-range]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/range
