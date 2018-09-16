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

No dopamine! ☹️

It doesn’t work the first time, no feedback except from verbose “wiring” tests and manual inspection. Often we have to not only run, but deeply run our program to know what is true (don't have any guarantees until we've hit that line... and with every permutation of state!).

# Is Elm "Type-Safe"?

You can build type-safe Elm... or not so type-safe Elm...

```elm
type alias Msg =
  {
    kind: String
    , user : Maybe User
    , commentToPost : Maybe String
    -- , ...
  }
```

You could even use Strings and lots of Maybes for your Msg type!

Elm's type-safety mechanisms are just tools available to you to enforce guarantees about your code. But you have to use them!

# Uncertainty in Elm

Sure, it's type-safe... but it's not the "if it compiles, it works" that we're used to with a lot of Elm code.
This doesn't feel like the dopamine-inducing Elm experience we're used to. What's the difference?

Compile-run-runtime error-fix cycle within Elm when we decode JSON
We're dealing with external contracts that we haven’t represented in Elm. So we have to represent uncertainty. In that sense it's type-safe, but there are still a lot of things we don't know until we hit that code. The main difference is that we represent that uncertainty (with the `Result` type, `Maybe`, etc.).

And you check that contract at the gate, so at least you don't have to deeply run your app to know whether the contract you thought it followed was indeed followed.

It's still "type-safe" in the sense that we represent that uncertainty. But it is exactly that... uncertain that
we'll get the data we want. Because what we're doing is making our best guess to replicate part of an
external contract (external API, etc.) in our Elm code. Using code generation, we can replace that
uncertainty with more guarantees! Which is what we love about Elm!

# Contracts & Guarantees

It's really about

1.  What can I guarantee? (not just "be pretty sure about")
2.  When I can I know it?

With JS, you don't know until you run a particular line, with every permutation.

With Elm, you can enforce contracts with the help of the compiler!

This is all great if your Elm code is the source of truth for the contract. But it doesn't help much if
the source of truth is an external system! It requires trial-and-error to duplicate the contract accurately.
Plus it could get out of sync at any time!

# Variable Contracts

We want to encode contracts into libraries.

But we can't always do that, because the contracts can vary.

- API responses
- Command-line interfaces
- SQL database

All are user-defined.

# Representing Contracts in Elm

- [Advanced Types posts](https://medium.com/@ckoster22/advanced-types-in-elm-opaque-types-ec5ec3b84ed2) - Charlie Koster
- [Making Impossible States Impossible](https://www.youtube.com/watch?v=IcgmSRJHu_8) - Richard
- [Make Data Structures](https://www.youtube.com/watch?v=x1FU3e0sT1I&list=PL-cYi7I913S-VgTSUKWhrUkReM_vMNQxG&index=11) - Richard
- [Scaling Elm Apps](https://www.youtube.com/watch?v=DoA4Txr4GUs) - Richard

## Building On Top of Low-Level, Weak Guarantee Contracts (catchy name?)

- [Understanding Style](https://www.youtube.com/watch?v=NYb2GDWMIm0) - Matt Griffith

# GraphQL

- GraphQL provides strong guarantees, and a robust type system.
- Only a couple of exceptions:
- Scalar types are not typed (yet...)

# -

Runtime error for mutually exclusive options

![original fit](https://raw.githubusercontent.com/dillonkearns/graphqelm/master/assets/github-optional-arg-error.png)

# `dillonkearns/elm-graphql`

- Generates a hardcoded library for your API!
- Uses `Json.Decode` library as byte-code, so you can only represent getting data that is 1) known to exist, and 2) will be correctly decoded

# TypeScript

Reasons why I prefer it to ReasonML, PureScript, etc...

- If I'm doing interop to a language from Elm, I don't want to then have to
  do another layer of interop from (PureScript, ReasonML, etc.) in order to finally
  get to the Web Platform API or NPM package I needed to use. (Reasonable people can
  come to different conclusions, but this is my thinking.)

# TypeScript Features I like

- Excellent editor integration.
- Surprisingly good autocompletion.
- Can represent Union Types (like Elm Custom Types, just a little more verbose)

# Installing Type Definitions `@types/...`

- Show the generated code to demystify the process.
- Show that it knows the lookup results in `null | string`... it will be happy if we wrap it in an if. And then we can send it to the appropriate port.

# Wrapping `LocalStorage`

# `elm-typescript-interop`

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
