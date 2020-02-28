build-lists: true
autoscale: true
slide-dividers: #
theme: Franziska, 8

# Demystifying Elm

* Elm is magical before you ingrain a few simple concepts ✨
* 🚫 Large, ever-growing syntax
* 🚫 Macros
* 🚫 Reflection
* 🚫 Dynamic
* 🚫 Magic


# Two contexts in Elm code
* Types  
* Values

[.code-highlight: all]
[.code-highlight: 1]
[.code-highlight: 2-3]

```elm
sum : Int -> Int -> Int
sum a b =
    a + b
```

# Type Alias

```elm
type alias Email
    = String
```

* What context is `Email` in (type or value)?

# Record Constructor Functions


```elm
type alias Person =
  { name: String
  , age: Int
  }
``` 

* What context is `Person` in (type or value)?

# Json Decoder pattern

```elm
type alias Person =
  { name: String
  , age: Int
  }

decoder : Decoder Person
decoder =
  Decode.map2 Person
  (Decode.field "name" Decode.string)
  (Decode.field "age" Decode.int)
```

# Custom Types (aka Unions)
```elm
type Money = Money Int Int

fromCents cents = Money (cents // 100) (cents |> modBy 100)

-- fromCents 123
```


^ moneyToString (Money dollars cents) = "$" ++ String.fromInt dollars ++ "." ++ String.fromInt cents

^ Money 1 823

# Read the docs
* Understanding how to read type signatures


# Reading Type Signatures
^ "Hello!"
List.map
List.map String.toUpper
List.map String.toUpper [ "Hello", "World" ]

# See what's going on?
* 2 possible Values in Elm
	* Fully resolved value
	* A function that takes an argument and returns a value
	* ONE argument
	* But it might return a function
	* Currying

# Public constructors
```elm
module Money exposing (Money(..))

type Money
  = Money Int Int
```

```elm
-- outside of Money.elm
Money.Money 10 823 -- works 😢
```

# Private constructors
```elm
module Money exposing (Money)

type Money
  = Money Int Int
```

```elm
-- outside of Money.elm
Money.Money 10 823 -- doesn't compile! 😎
```

* Remember the two contexts (type and value)?
* `exposing (Money(..))` exposes a type and a value (constructor function)
* `exposing (Money)` only exposes type

# Public constructors
```elm
module PositiveInt exposing (PositiveInt(..))

type PositiveInt
  = PositiveInt Int

-- ...
```

```elm
-- outside of PositiveInt.elm
PositiveInt.PositiveInt -1
```

# Private constructors
```elm
module PositiveInt exposing (PositiveInt)

type PositiveInt
  = PositiveInt Int

-- ...
```

```elm
-- outside of PositiveInt.elm
PositiveInt.PositiveInt -1 -- doesn't compile
```

# Private constructors
```elm
module PositiveInt exposing (PositiveInt)

type PositiveInt
  = PositiveInt Int

zero : PositiveInt
zero = PositiveInt 0

increment : PositiveInt -> PositiveInt
increment (PositiveInt raw) = PositiveInt (raw + 1)
```

```elm
-- outside of PositiveInt.elm
PositiveInt.zero |> PositiveInt.increment
```

# Can be overwhelming
* Big error messages
* Often when you're new to Elm, you try to do a lot at once
* Some things, Elm can help you take on a lot all at once
	* Refactoring a type over 1000 modules (easy!)
	* Hiding a constructor and replacing it with a function
* Some things are going to be more frustrating than they need to be with this approach

# Key ideas
* Break it down
* Get a test to tell you useful information
* Get the compiler to tell you useful information
* Mix, match, repeat

# Frame Then Fill In
* I do this often using `let` bindings with type annotations
	* Note: let bindings can have type annotations
* Difference between an error somewhere in this function, vs. somewhere in this tiny little `let` within this function

# Cunningham's Law
> The best way to get the right answer on the Internet is not to ask a question; it's to post the wrong answer.

-- Ward Cunningham

Sometimes the compiler won't help you much... unless you get it to correct an incorrect type.

# Fake it till you make it with succeed

# Debug.todo
* This value is of this type, vs. "is there any type that will make the rest of these types line up?"
* Common example for me is building up a `foldl`

```elm
orgNameDict : List OrganizationData -> Dict OrganizationId String
orgNameDict orgs =
  Dict.empty
```

```elm
orgNameDict orgs =
  orgs
  |> List.map (\_ -> Debug.todo "")
  |> Dict.fromList
```

```elm
orgNameDict orgs =
  let
    transformStep = (\_ -> Debug.todo "")
  in
  orgs
  |> List.map transformStep
  |> Dict.fromList
```

```elm
orgNameDict orgs =
  let
    transformStep : Int -> Int
    transformStep = (\_ -> Debug.todo "")
  in
  orgs
  |> List.map transformStep
  |> Dict.fromList
```



## When to use todo vs. succeed?


# Write a test
* How many people know how to run our Elm test suite?
* Run a specific test?
* Run it in watch mode?
* Testing a decoder
* `only`
* `Debug.log`
* TDD in Elm
