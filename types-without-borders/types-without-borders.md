footer: [github.com/**DillonKearns**/talks](http://github.com/dillonkearns/talks) @dillontkearns
build-lists: true

# Types Without Borders

### [github.com/**DillonKearns**](http://github.com/dillonkearns)

### [incrementalelm.com](http://incrementalelm.com)

![](../safe-web-dev/climbing.jpg)

# Type-Safe Elm

```elm
type Msg
  = Increment


update msg model =
  case msg of
    Increment ->
      (model + 1, Cmd.none)
```

# Add a Msg

```elm
type Msg
  = Increment
  | Decrement

update msg model =
  case msg of
    Increment ->
      (model + 1, Cmd.none)
```

This `case` does not have branches for all possibilities...

# Make it compile

```elm
type Msg
  = Increment
  | Decrement

update msg model =
  case msg of
    Increment ->
      (model + 1, Cmd.none)

    Decrement ->
      (model - 1, Cmd.none)
```

# -

![](./img/dopamine.jpeg)

# JS

```javascript
let json = Json.parse(stringFromServer);
```

# JS Feedback

```javascript
let json = Json.parse(stringFromServer);
```

Don't know until we hit that line!

# More Than Just Type-Checking

... It's About Guarantees, which are a superset of type-checking.

# Guarantees

```elm
module EvenNumber exposing (EvenNumber, two, value)


type EvenNumber
    = EvenNumber Int


two : EvenNumber
two =
    EvenNumber 0


add2 : EvenNumber -> EvenNumber
add2 (EvenNumber currentValue) =
    EvenNumber (currentValue + 2)


value : EvenNumber -> Int
value (EvenNumber currentValue) =
    currentValue
```

# Not Opaque

```elm
module EvenNumber exposing (EvenNumber(EvenNumber), two, value)


type EvenNumber
    = EvenNumber Int


two : EvenNumber
two =
    EvenNumber 0


add2 : EvenNumber -> EvenNumber
add2 (EvenNumber currentValue) =
    EvenNumber (currentValue + 2)


value : EvenNumber -> Int
value (EvenNumber currentValue) =
    currentValue
```

# What Is Type-Safety?

- The compiler doesn't magically make our code correct
- But it allows us to express some very simple, concise constraints that we can inspect
- It's like the difference between reasoning about a circuit-board being correct or an app.

# Type-Safety

It boils down to this:

- What can we know before we run our program?
- What can we know will always be true (invariants)?

# The Problem

We want to encode contracts into libraries.

# Static Contracts

This is great when we have a contract that does not vary based on the user.

- CSS

Weak (in terms of guarantees), Low-Level APIs

These are strongly-typed because Elm is a strongly typed language. But they're guarantees are not strong, there is a lot of uncertainty
, and there are a lot of ways to represent events that will never occur, or not handle events that will occur.

- `elm/browser` Keyboard API (keypress, keydown, keyup) - have to decode JSON response which is vague in terms of possibilities.
- -> [`ohanhi/keyboard`](https://package.elm-lang.org/packages/ohanhi/keyboard/latest/) treats this as byte-code
- Json.Decode

# Contract Wrangling

Although some contracts don't translate well to the strong guarantees we like to work with in Elm.

This is where simplifying contracts is helpful.

> Make Undesirable States Impossible

# Variable Contracts

But we can't always do that, because the contracts can vary.

- API responses
- Command-line interfaces
- SQL database

All are user-defined.

# Summary of Contract Scenarios

- Robust static contract - just hardcode (`remote-data`)
- Weak static contract - simplify then hardcode (`elm-ui`, `elm-plot`, `elm-cli-options-parser`)
  (Wrap the low-level stuff into a robust, high-level API... use it as "byte-code")
- Variable contract, Elm can be source of truth
- Variable contract, external source of truth - generate code using the same techniques as the above two (`dillonkearns/elm-graphql`)

# Representing Contracts in Elm

- [Advanced Types posts](https://medium.com/@ckoster22/advanced-types-in-elm-opaque-types-ec5ec3b84ed2) - Charlie Koster
- [Making Impossible States Impossible](https://www.youtube.com/watch?v=IcgmSRJHu_8) - Richard
- [Make Data Structures](https://www.youtube.com/watch?v=x1FU3e0sT1I&list=PL-cYi7I913S-VgTSUKWhrUkReM_vMNQxG&index=11) - Richard
- [Scaling Elm Apps](https://www.youtube.com/watch?v=DoA4Txr4GUs) - Richard

## Building On Top of Low-Level, Weak Guarantee Contracts (catchy name?)

- [Understanding Style](https://www.youtube.com/watch?v=NYb2GDWMIm0) - Matt Griffith

# Strong Contract - GraphQL

- GraphQL provides strong guarantees, and a robust type system.
- Only a couple of exceptions:
- Scalar types are not typed (yet...)

# -

Runtime error for mutually exclusive options

![original fit](https://raw.githubusercontent.com/dillonkearns/graphqelm/master/assets/github-optional-arg-error.png)

# `dillonkearns/elm-graphql`

- Generates a hardcoded library for your API!
- Uses `Json.Decode` library as byte-code, so you can only represent getting data that is 1) known to exist, and 2) will be correctly decoded

# TODO

Example of doing that with JS, it doesn’t work the first time, no feedback except from verbose “wiring” tests and manual inspection

# **Type-Safety**

# What is type-safety?

So Elm is type-safe, and JS isn't, right???

# You can build type-safe Elm... or not so type-safe Elm... show example of using Strings instead of union types... you could even do that for your Msg type!

# Example of the compile-inspect cycle within Elm when we decode JSON (i.e. deal with external contracts that we haven’t represented in Elm)

# Contrast that with a simple contract that we do represent in Elm (style elements, elm-cli-options-parser... but not Elm CSS, because it’s not much of a contract... make undeserisable states impossible)

# Type-Safety

- Too theoretical, let's not get stuck on definitions.
- How can we know stuff about our program sooner
- How can we guarantee certain constraints with our programs, and have them enforced by the compiler so it's impossible to forget it.
- Basically, this allows us to reduce the cognitive load (don't have to keep thinking whether we're respecting certain invariants, we think about it once, in one place, then take it for granted everywhere else)
- In other words: let's make good use of our compiler!

# Conversely, is a MultipleOf3 module type-safe with all its internals exposed? Is it more type-safe with them hidden and opaque? I would argue that it is, because you are _using the compiler to help you make guarantees about your program before you run it_. Of course, this needs human help. But the really powerful kind of type-safety requires some thought, creativity, and domain modeling. It’s more than just making sure you pass an Int instead of a String, or a data type with a firstName, lastName.

# Future Ideas

- Code generation libraries and blog posts
- `elm-electron` improvements

# What I'd like to see next

- Type-safe storage solution... you'd need to represent the schema, and provide a way to migrate from previous versions of the schema.
  Could use ideas like Mario's [Evergreen Elm talk](https://www.youtube.com/watch?v=4T6nZffnfzg).

# Thank You!

### [github.com/**DillonKearns**](http://github.com/dillonkearns)

### [incrementalelm.com](http://incrementalelm.com)

![](../safe-web-dev/climbing.jpg)
