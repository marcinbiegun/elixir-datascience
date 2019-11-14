# elixir-datascience
A few examples of using Elixir to work large amounts of data

## Yelp DB markov chains reviews

1. Read `busines.json` to create `business -> categories` map.
   (parallel)
2. Join the above.
3. Pick one of popular categories.
4. Read `reviews.json` to pick reviews belonging to businesses having
   the selected category. (parallel)
5. Parse selected reviews into markov chain data. (parallel)
6. Join the above.
7. Generate fake reviews.

## Elixir Flow

TIP: Using `File.stream!\1` instead of `File.read!\1` makes the program read the file by single lines instead of loading the whole file to memory. It allows us to save RAM but does not make the computations faster.

Simple example, let's read the smallest Yelp dataset file `photos.json` containing 200_000 lines and parse each one.

Single process version using Enum:

```elixir
File.stream!(Datascience.Yelp.path(:photo))
|> Enum.map(&Jason.decode!/1)
|> Enum.reduce(0, fn _el, acc -> acc + 1 end)
# => 200_000
```

Multiple processes (by default one per core) version using Flow:

```elixir
File.stream!(Datascience.Yelp.path(:photo))
|> Flow.from_enumerable()
|> Flow.map(&Jason.decode!/1)
|> Enum.reduce(0, fn _el, acc -> acc + 1 end)
# => 200_000
```