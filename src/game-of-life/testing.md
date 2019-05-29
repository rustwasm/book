# Testing Conway's Game of Life

Now that we have our Rust implementation of the Game of Life rendering in the 
browser with JavaScript, let's talk about testing our Rust-generated 
WebAssembly functions.

We are going to test our `tick` function to make sure that it gives us the 
output that we expect.

Next, we'll want to create some setter and getter 
functions inside our existing `impl Universe` block in the
`wasm_game_of_life/src/lib.rs` file. We are going to create a `set_width`
and a `set_height` function so we can create `Universe`s of different sizes.

```rust
#[wasm_bindgen]
impl Universe { 
    // ...

    /// Set the width of the universe.
    ///
    /// Resets all cells to the dead state.
    pub fn set_width(&mut self, width: u32) {
        self.width = width;
        self.cells = (0..width * self.height).map(|_i| Cell::Dead).collect();
    }

    /// Set the height of the universe.
    ///
    /// Resets all cells to the dead state.
    pub fn set_height(&mut self, height: u32) {
        self.height = height;
        self.cells = (0..self.width * height).map(|_i| Cell::Dead).collect();
    }

}
```

We are going to create another `impl Universe` block inside our
`wasm_game_of_life/src/lib.rs` file without the `#[wasm_bindgen]` attribute.
There are a few functions we need for testing that we don't want to expose to
our JavaScript. Rust-generated WebAssembly functions cannot return
borrowed references. Try compiling the Rust-generated WebAssembly with the
attribute and take a look at the errors you get.

We are going to write the implementation of `get_cells` to get the contents of
the `cells` of a `Universe`. We'll also write a `set_cells` function so we can
set `cells` in a specific row and column of a `Universe` to be `Alive.`

```rust
impl Universe {
    /// Get the dead and alive values of the entire universe.
    pub fn get_cells(&self) -> &[Cell] {
        &self.cells
    }

    /// Set cells to be alive in a universe by passing the row and column
    /// of each cell as an array.
    pub fn set_cells(&mut self, cells: &[(u32, u32)]) {
        for (row, col) in cells.iter().cloned() {
            let idx = self.get_index(row, col);
            self.cells[idx] = Cell::Alive;
        }
    }

}
```

Now we're going to create our test in the `wasm_game_of_life/tests/web.rs` file.

Before we do that, there is already one working test in the file. You can
confirm that the Rust-generated WebAssembly test is working by running
`wasm-pack test --chrome --headless` in the `wasm-game-of-life` directory.
You can also use the `--firefox`, `--safari`, and `--node` options to
test your code in those browsers.

In the `wasm_game_of_life/tests/web.rs` file, we need to export our
`wasm_game_of_life` crate and the `Universe` type.

```rust
extern crate wasm_game_of_life;
use wasm_game_of_life::Universe;
```

In the `wasm_game_of_life/tests/web.rs` file we'll want to create some
spaceship builder functions.

We'll want one for our input spaceship that we'll call the `tick` function on
and we'll want the expected spaceship we will get after one tick. We picked the
cells that we want to initialize as `Alive` to create our spaceship in the
`input_spaceship` function. The position of the spaceship in the
`expected_spaceship` function after the tick of the `input_spaceship` was
calculated manually. You can confirm for yourself that the cells of the input
spaceship after one tick is the same as the expected spaceship.

```rust
#[cfg(test)]
pub fn input_spaceship() -> Universe {
    let mut universe = Universe::new();
    universe.set_width(6);
    universe.set_height(6);
    universe.set_cells(&[(1,2), (2,3), (3,1), (3,2), (3,3)]);
    universe
}

#[cfg(test)]
pub fn expected_spaceship() -> Universe {
    let mut universe = Universe::new();
    universe.set_width(6);
    universe.set_height(6);
    universe.set_cells(&[(2,1), (2,3), (3,2), (3,3), (4,2)]);
    universe
}
```

Now we will write the implementation for our `test_tick` function. First, we
create an instance of our `input_spaceship()` and our `expected_spaceship()`.
Then, we call `tick` on the `input_universe`. Finally, we use the `assert_eq!`
macro to call `get_cells()` to ensure that `input_universe` and
`expected_universe` have the same `Cell` array values. We add the
`#[wasm_bindgen_test]` attribute to our code block so we can test our
Rust-generated WebAssembly code and use `wasm-pack test` to test the
WebAssembly code.

```rust
#[wasm_bindgen_test]
pub fn test_tick() {
    // Let's create a smaller Universe with a small spaceship to test!
    let mut input_universe = input_spaceship();

    // This is what our spaceship should look like
    // after one tick in our universe.
    let expected_universe = expected_spaceship();

    // Call `tick` and then see if the cells in the `Universe`s are the same.
    input_universe.tick();
    assert_eq!(&input_universe.get_cells(), &expected_universe.get_cells());
}
```

Run the tests within the `wasm-game-of-life` directory by running
`wasm-pack test --firefox --headless`.
