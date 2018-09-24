footer: [github.com/**DillonKearns**/talks](http://github.com/dillonkearns/talks) @dillontkearns
build-lists: true

# Types Without Borders

### [github.com/**DillonKearns**](http://github.com/dillonkearns)

### [incrementalelm.com](http://incrementalelm.com)

![original right](./img/idaho.jpg)

# JS

```javascript
let json = Json.parse(stringFromServer);
```

- `Uncaught ReferenceError: Json is not defined`
- Don't know until runtime.

# -

![60%](./img/picard3.png)

^ Run app to know things?

# Elm Compiler

- Knows a lot!
- Make impossible states impossible
- If it compiles it works! ™

^ Elm is one solution.

# Custom `Msg` Types

```elm
type Msg
  = Increment


update msg model =
  case msg of
    Increment ->
      (model + 1, Cmd.none)
```

# Add to `Msg`

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

# Single Source of Truth

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

^ If it compiles it works.

# -

![130%](./img/happy-picard1.jpg)

^ Compiler knows everything!
Happy place!

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

# `BadPayload`

Expecting an object with a field named `name` but instead got...

^ Validate assumptions immediately 👍
Represent uncertainty 👍

# -

![fit](./img/picardhd1.jpg)

^ Thought we were past this...

# Implicit Assumptions

```javascript
greet(jsonResponse.name);
```

- `"Hello [object Object]!"`
- Explicit assumptions are nice (e.g. `Result`)
- No assumptions is best

^ Explicit is better.
Still assumptions.

# When Can I Know?

![120% original](./img/knowledge-timeline1.jpg)

# When Can I Know?

![120% original](./img/knowledge-timeline2.jpg)

^ Implicit assumptions flow deep.
Get more compiler guarantees somehow...

# Uncertainty

- Two kinds:
- Unavoidable
- Avoidable

![left](./img/fry2.jpg)

# Unavoidable Uncertainty

```elm, [.highlight: 1-4]
type Error
    = BadStatus (Response String)
    | Timeout
    | NetworkError
```

- Can't guarantee WiFi
- Representing unavoidable uncertainty 👍

^ Can't guarantee wifi
Representing unavoidable 👍

# Avoidable Uncertainty

```elm, [.highlight: 5]
type Error
    = BadStatus (Response String)
    | Timeout
    | NetworkError
    | BadUrl String
```

- Could make this impossible.

^ Not talking about that!
Let's focus on #TypesWithoutBorders

# Avoidable Uncertainty

```elm, [.highlight: 6]
type Error
    = BadStatus (Response String)
    | Timeout
    | NetworkError
    | BadUrl String
    | BadPayload String (Response String)
```

- Two sources of truth

^ Assumptions about the response.

# Avoidable Uncertainty

![original](./img/run-fix.jpg)

^ Not what we signed up for!

# With Certainty

![original](./img/compile-fix.jpg)

^ Still run
But with more guarantees

# Single Source of Truth

```elm
type Msg
  = Increment
  | Decrement

update msg model =
  case msg of
    Increment ->
      (model + 1, Cmd.none)

    -- You forgot a case!
```

^ Single source.
Elm knows about it!

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
- Enforces contract
- Robust type system

# Enums

```haskell
enum SortOrder {
  ASCENDING
  DESCENDING
}
```

# GraphQL Objects

```haskell
type Character {
  name: String!
  homePlanet: String
  avatarUrl: String!
  friends: [Character!]!
}
```

^ Represent nullability.

# GraphQL Arguments

```haskell
type Query {
  character(id: ID!): Character
  all: [Character!]!
}
```

^ May not find ID.

# -

![original 140%](./img/graphql-graph1.jpg)

# -

![original 140%](./img/graphql-graph.jpg)

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
  , createdAt : Time.Posix
  }

userSelection =
  GithubUser.selection User
    |> with GithubUser.login
    |> with GithubUser.name
    |> with (GithubUser.createdAt |> mapToPosix)
```

^ Defines a request.

# Demo!

![original 70%](./img/elm-graphql.png)

# -

![](./img/api/6.jpg)

# -

![](./img/api/7.jpg)

# -

![](./img/dopamine10.jpg)

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

- Superset of JavaScript
- Editor integration, auto-complete
- Union Types
- Just add a `tsconfig.json`!

# `npm install @types/<npm-library>`

- Often comes included (`electron`, `moment`, etc.)

^ Show `moment`'s' `.d.ts` file.
^ Show generated code
Show that it knows the lookup results in `null | string`... it will be happy if we wrap it in an if. And then we can send it to the appropriate port.

# Why not PureScript, ReasonML, etc.?

- Avoid double-interop

# -

![](./img/interop/5.jpg)

# -

![](./img/interop/6.jpg)

# -

![](./img/interop/7.jpg)

# Demo!

`elm-typescript-interop`

# -

![](./img/interop/7.jpg)

# -

![](./img/interop/8.jpg)

# -

![](./img/dopamine6.jpg)

# Variable Contracts

- APIs
- Databases
- Message-passing protocols
- Any user-defined contract

^ Encode contracts into libraries.
Can't always, contracts vary.

# #TypesWithoutBorders

- Code generation is more tedious than difficult
- Avoid brittle data sources
- Community-backed standards over one-offs

^ Don't get coupled to unreliable sources.

# Representing Contracts in Elm

- [Advanced Types posts](https://medium.com/@ckoster22/advanced-types-in-elm-opaque-types-ec5ec3b84ed2) - Charlie Koster
- [Making Impossible States Impossible](https://www.youtube.com/watch?v=IcgmSRJHu_8) - Richard
- [Make Data Structures](https://www.youtube.com/watch?v=x1FU3e0sT1I&list=PL-cYi7I913S-VgTSUKWhrUkReM_vMNQxG&index=11) - Richard
- [Scaling Elm Apps](https://www.youtube.com/watch?v=DoA4Txr4GUs) - Richard
- [Understanding Style](https://www.youtube.com/watch?v=NYb2GDWMIm0) - Matt Griffith

# [Evergreen Elm](https://www.youtube.com/watch?v=4T6nZffnfzg)

![original 50%](./img/evergreen-elm.png)

^ Storage
Represent schema
Way to migrate from previous schema.

# Sharing About Code Generation

- Blog posts, talks
- End-to-end testing techniques
- Extract libraries

# Let's Eliminate Avoidable Uncertainty!

![inline 130% original](./img/compile-fix.jpg)

^ Not just model it!

# Let's Know Things Early!

![inline 130% original](./img/knowledge-timeline1.jpg)

# -

## #TypesWithoutBorders

## What are your ideas?

![](img/map.jpg)

# Thank You!

### [github.com/**DillonKearns**](http://github.com/dillonkearns)

### [incrementalelm.com](http://incrementalelm.com)

![right](./img/idaho.jpg)
