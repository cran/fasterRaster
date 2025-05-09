
library(data.table)

dt <- data.table(
   x = 1:10,
   y = letters[1:10],
   z = rnorm(10)
)

# make some values NA
dt[x == 4 | x == 8, y := NA_character_]
dt

# Replace NAs:
replaceNAs(dt, replace = -99, cols = "y")
dt

# Drop rows:
dropped <- dropRows(dt, 8:10)
dropped

# NB May not print... in that case, use:
print(dropped)

# We can also use replaceNAs() on vectors:
y <- 1:10
y[c(2, 10)] <- NA
replaceNAs(y, -99)

# Same as:
y <- 1:10
y[c(2, 10)] <- NA
y[is.na(y)] <- -99
