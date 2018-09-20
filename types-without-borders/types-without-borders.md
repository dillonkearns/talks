footer: [github.com/**DillonKearns**/talks](http://github.com/dillonkearns/talks) @dillontkearns
build-lists: true

# Types Without Borders

### [github.com/**DillonKearns**](http://github.com/dillonkearns)

### [incrementalelm.com](http://incrementalelm.com)

![original right](./img/idaho.jpg)

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

- This `case` does not have branches for all possibilities...

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

![original](./img/dopamine1.jpg)

# TODO

TODO Graphic with timeline of when you can know things, from compile-time to run-time to run with the right values/environment/global variables.

# APIs in Elm

```elm
type Character
    = Human { name : String, homePlanet : String }
    | Droid { name : String, primaryFunction : String }

decoder : Decode.Decoder Character
decoder =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\characterType ->
                case characterType of
                    "human" -> humanDecoder
                    "droid" -> droidDecoder
                    _ -> Decode.fail "Invalid Character")
```

^ Check assumptions at gate.
Still, duplicate contract.

# Nested Decoders

```elm
humanDecoder : Decode.Decoder Character
humanDecoder =
    Decode.map2 HumanAttributes
        (Decode.field "name" Decode.string)
        (Decode.field "homePlanet" Decode.string)
        |> Decode.map Human


droidDecoder : Decode.Decoder Character
droidDecoder =
    Decode.map2 DroidAttributes
        (Decode.field "name" Decode.string)
        (Decode.field "primaryFunction" Decode.string)
        |> Decode.map Droid
```

^ Tedious.
More important:
No guarantees.

---

# Expecting an object with a field named `name` but instead got...

^ Validate assumptions immediately 👍
Represent uncertainty 👍
Still, assumptions!

^ Feedback from wiring tests, manual inspection
Deeply run with permutations

# -

![](./img/sad1.jpg)

# Validate Assumptions

![original](./img/run-fix.jpg)

^ Not what we signed up for!

# We Prefer Guarantees!

![original](./img/compile-fix.jpg)

^ Still run
But with more guarantees

# -

![](./img/api/1.jpg)

# -

![](./img/api/2.jpg)

# -

![](./img/api/3.jpg)

# -

![](./img/api/4.jpg)

# -

![](./img/api/5.jpg)

# GraphQL

- Strong guarantees
- Check contract at the gate
- Robust type system

# GraphQL Objects

```haskell
type Character {
  name: String!
  appearsIn: [Episode]!
}
```

# GraphQL Arguments

```haskell
type Query {
  hero(episode: Episode): Character
  character(id: ID!): Character
}
```

# -

Runtime error for mutually exclusive options

![original fit](https://raw.githubusercontent.com/dillonkearns/graphqelm/master/assets/github-optional-arg-error.png)

# -

![](./img/api/5.jpg)

# -

![](./img/api/6.jpg)

# `dillonkearns/elm-graphql`

- Generates a "hardcoded library"
- `Json.Decode` is an implementation detail

# `dillonkearns/elm-graphql` Guarantees

- Correct request
- Well-typed
- Decodes correctly

# `Json.Decode.Pipeline`

```elm
type alias User =
  { username : String
  , name : Maybe String
  , createdAt : Time.Posix
  }

userDecoder =
  Decode.succeed User
    |> required "login" string
    |> required "name" (nullable string)
    |> optional "createdAt" dateTimeDecoder
```

^ Looks similar to `Json.Decode.Pipeline`

# `dillonkearns/elm-graphql`

```elm
type alias User =
  { username : String
  , name : Maybe String
  , createdAt : Github.Scalar.DateTime
  }

userSelection =
  Github.Object.User.selection User
    |> with Github.Object.User.login
    |> with Github.Object.User.name
    |> with Github.Object.User.createdAt
```

# Demo!

![original 70%](./img/elm-graphql.png)

# -

![](./img/api/6.jpg)

# -

![](./img/api/7.jpg)

# -

![](./img/dopamine4.jpg)

# -

![](./img/interop/1.jpg)

# -

![](./img/interop/2.jpg)

# -

![](./img/interop/3.jpg)

# -

![](./img/interop/4.jpg)

# -

![](./img/interop/5.jpg)

# TypeScript

Why not PureScript, ReasonML, etc.?

- Avoid double-interop
- Superset of JS
- Can add types for npm packages
- Editor integration, auto-complete
- Union Types
- Just add a `tsconfig.json`!

# -

![](./img/interop/5.jpg)

# -

![](./img/interop/6.jpg)

# -

![](./img/interop/7.jpg)

# `npm install @types/<npm-library>`

- Often comes included (`electron`, `moment`, etc.)

^ Show `moment`'s' `.d.ts` file.
^ Show generated code
Show that it knows the lookup results in `null | string`... it will be happy if we wrap it in an if. And then we can send it to the appropriate port.

# Demo!

`elm-typescript-interop`

# -

![](./img/interop/7.jpg)

# -

![](./img/interop/8.jpg)

# -

![](./img/dopamine6.jpg)

# Variable Contracts

- API responses
- Command-line interfaces
- SQL database
- Any user-defined contract

^ Encode contracts into libraries.
Can't always, contracts vary.

# Code Generation

- You already do it!
- Not scary, just templating
- Macros versus code generation
  - Macros mutate the AST
  - Makes it harder to trace what code is doing
  - Code gen is just like a custom-tailored library for your domain!
- Use it as a last resort

# Representing Contracts in Elm

- [Advanced Types posts](https://medium.com/@ckoster22/advanced-types-in-elm-opaque-types-ec5ec3b84ed2) - Charlie Koster
- [Making Impossible States Impossible](https://www.youtube.com/watch?v=IcgmSRJHu_8) - Richard
- [Make Data Structures](https://www.youtube.com/watch?v=x1FU3e0sT1I&list=PL-cYi7I913S-VgTSUKWhrUkReM_vMNQxG&index=11) - Richard
- [Scaling Elm Apps](https://www.youtube.com/watch?v=DoA4Txr4GUs) - Richard

* [Understanding Style](https://www.youtube.com/watch?v=NYb2GDWMIm0) - Matt Griffith
  (Building On Top of Low-Level, Weak Guarantee Contracts)

# Future Ideas

- Code generation libraries and blog posts
- AST with types & imports resolved
- `elm-electron` improvements
- Type-safe storage
- Your ideas!

# [Evergreen Elm](https://www.youtube.com/watch?v=4T6nZffnfzg)

![original 50%](./img/evergreen-elm.png)

^ Storage
Represent schema
Way to migrate from previous schema.

# Thank You!

### [github.com/**DillonKearns**](http://github.com/dillonkearns)

### [incrementalelm.com](http://incrementalelm.com)

![right](./img/idaho.jpg)
