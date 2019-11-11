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
