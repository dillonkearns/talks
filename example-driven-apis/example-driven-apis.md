footer: bit.ly/**elm-ftf**
build-lists: true
slide-dividers: #

#

[.hide-footer]

![fit](img/opening.jpg)

# Lessons

- Problem-First (Outcome-Driven)
- Vision-First
  - Clear, Focused, & Explicit
- Example-First
- Approval-Tests-First
- Problem => Vision => Examples => Tests => Features

^ Vision informs examples informs features.

# The Timeline

1. How Do I GraphQL in Elm? 🤷
1. Survey Tools
1. Vision
1. Working Example (No Code Gen)
1. End-To-End Tests & Code Gen
1. Hash-based aliases
1. Eliminate `Field`s

^ TODO: include these topics? 1. Exhaustive types 1. Polymorphic fragment is just a field

# 1. How Do I GraphQL in Elm? 🤷

[Mobster download page](http://mobster.cc/)

# [The Query](https://developer.github.com/v4/explorer/?query=query%20%7B%0A%20%20repository%28owner%3A%20%22dillonkearns%22%2C%20name%3A%20%22mobster%22%29%20%7B%0A%20%20%20%20stargazers%20%7B%0A%20%20%20%20%20%20totalCount%0A%20%20%20%20%7D%0A%20%20%7D%0A%7D%0A)

```elm
query {
  repository(owner: "dillonkearns", name: "mobster") {
    stargazers {
      totalCount
    }
  }
}
```

# [Full Query](https://developer.github.com/v4/explorer/?query=%7B%0A%20%20repository%28owner%3A%20%22dillonkearns%22%2C%20name%3A%20%22mobster%22%29%20%7B%0A%20%20%20%20stargazers%20%7B%0A%20%20%20%20%20%20totalCount%0A%20%20%20%20%7D%0A%20%20%20%20releases%28last%3A%201%29%20%7B%0A%20%20%20%20%20%20nodes%20%7B%0A%20%20%20%20%20%20%20%20releaseAssets%28last%3A%2030%29%20%7B%0A%20%20%20%20%20%20%20%20%20%20edges%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20node%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20downloadUrl%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20name%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20downloadCount%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%20%20%7D%0A%7D%0A)

```elm
{
  repository(owner: "dillonkearns", name: "mobster") {
    stargazers {
      totalCount
    }
    releases(last: 1) {
      nodes {
        releaseAssets(last: 30) {
          edges {
            node {
              downloadUrl
              name
              downloadCount
            }
          }
        }
      }
    }
  }
}
```

# [Tried An Elm Client](https://github.com/dillonkearns/mobster/blob/2ad66f514579a09a9679b75b6c1b2956e7879b46/web/src/GithubGraphql.elm)

- Abandoned the attempt
- Too many domain concepts:

  ```elm
  ValueSpec NonNull ObjectType StarGazerCount ()
  ```

- No guardrails
- Ended up using a [plain HTTP Request & JSON Decoder](https://github.com/dillonkearns/mobster/blob/2ad66f514579a09a9679b75b6c1b2956e7879b46/web/src/Github.elm)

^ - Needed to run, check, run, check.

^ - Used regular Http request

^ - Copy-paste query that I knew worked

# 2. Survey Tools

- `gql` => Elm
  - No Elm 0.18 support
- Build up Json Decoders and `gql` query together
  - Manual process, error-prone
- GraphQL Schema => Elm API
  - My hypothesis

# 3. Vision

- Typed responses
- Impossible to write an incorrect query

^ - Started with my itch

^ - Wanted guardrails

# 3. Vision (Refined)

- Elm gives me clear feedback
- Elm (not `gql`) is 1st-class
- Meaningful data structures

^ - Didn't even know if it was possible
^ - Picked a clear strategy with confidence.

^ - I don't want to accept auto-generated data structures as the way to structure my data. I want to choose exactly which data structures I want, and never have the intermediary data structures exist anywhere in my app (immediately map/transform them)

^ - Queries aren't the first-class citizen
^ - CODE is!
^ - Code changes, code is reused, code is refactored.

# 3. [Explicit Vision](https://github.com/dillonkearns/elm-graphql)

- Users can evaluate whether it fits their needs
- [Communicate with values at the core](https://github.com/dillonkearns/elm-graphql/issues/27#issuecomment-361008781)
  - Creates empathy
  - Instead of clashing over two preferred strategies, collaborate to brainstorm how to achieve a shared goal

# Lesson

- Start with a hypothesis
- Clear, focused vision
- It can change over time, but it should always be narrow and clearly defined

^ It's okay for hypothesis to be invalidated.

# 4. Working Example [From Day 1](https://github.com/dillonkearns/elm-graphql/blob/56495760aabc7dd4944cfaebe998271b38eaca66/tests/Tests.elm)

```elm
type alias Human =
    { name : String }

query : Field.FieldDecoder Human
query =
    Human.human Human { id = "1000" } []
        |> Field.with Human.name
```

# 4. Working Test [From Day 1](https://github.com/dillonkearns/elm-graphql/blob/56495760aabc7dd4944cfaebe998271b38eaca66/tests/Tests.elm)

```elm
test "generate query document" <| \_ ->
  Field.fieldDecoderToQuery query
    |> Expect.equal
      """{ human(id: "1000") { name } }"""
```

- [Commits](https://github.com/dillonkearns/elm-graphql/commits/bc12334291dc68d786da1206c4d9a8569dce8a49)

# 4. Working Test [From Day 1](https://github.com/dillonkearns/elm-graphql/blob/56495760aabc7dd4944cfaebe998271b38eaca66/tests/Tests.elm)

```elm
test "decodes properly" <| \() ->
  """{ "data": { "human": { "name": "Luke Skywalker" } } }"""
  |> Json.Decode.decodeString (Field.decoder query)
  |> Expect.equal (Ok { name = "Luke Skywalker" })
```

# 5. What Are Approval Tests?

- AKA "Gold Master"
- Fail if diff
- Fix code to make it green
- Or accept patch

# 5. Approval Test Scripts

- [Initial script](https://github.com/dillonkearns/elm-graphql/commit/d4799c44e9c63ad2c82d0e5369be4766db8d7978) - very early
- [Mature script](https://github.com/dillonkearns/elm-graphql/blob/master/bin/approve)
- Demo

# Examples Versus Tests

- Unit tests at first
- Still meaningful from the start
- [Evolved to examples folder (which _is_ the approval test suite)](https://github.com/dillonkearns/elm-graphql/commit/c3d1cda62adbabb7fae9fc5535c28a9052cca989#diff-2d5fe20321b71db836c3b16a8828d630)
- Evaluate the design with zero friction
- [Upgrade guide is free!](https://github.com/dillonkearns/elm-graphql/blob/master/CHANGELOG-ELM-PACKAGE.md#150---2018-11-27)

^ - Avoid toy examples

# 6. Hash-Based Aliases

- Solved a problem, but opened up possibilities
- Based on user feedback
- [Blog post](https://medium.com/@dillonkearns/how-elm-guides-towards-simplicity-3d34685dc33c)

# 7. [Eliminate `Field`s](https://github.com/dillonkearns/elm-graphql/pull/96/files#diff-a7a8067991f96a0cd74633c0fc477539R42)

- [Requesting user feedback](https://github.com/dillonkearns/elm-graphql/pull/96#issue-235218568)

# Event: Exhaustive Types

- Wouldn't be possible without query-builder approach...
- Or at least it would be awkward. Your code would suddenly go from returning a `String` to a `Maybe String`

# Evaluating Feature Requests

- "Your library should do X."
- "How does X help you achieve your outcome, Y?"
- "What are some ways we could achieve Y that honor the principles laid out at the top of the README?"
- Evaluate the suggested strategy
  - I'm not a fan of that approach.
  - I don't like that style.
  - I think this would be the best way to do it.
- Versus
- Evaluate an implementation strategy's ability to achieve an outcome, while honoring the values.

^ - It becomes more empathetic.
^ - Easier to respond
^ - Not personal
^ - Easy to invite alternatives
^ - Not an open invitation to do the feature however you envision it, there are common values to evaluate openly

# User Feedback

- Like legal concept: "Standing"

^ - Might be useful to somebody, somewhere...

^ - fine, talk to _that_ person, let their needs guide the design

# Idiomatic Elm Package Guide

https://github.com/dillonkearns/idiomatic-elm-package-guide

# Intro to `elm-graphql`

```elm
query {
  human(id: "1001") {
    name
    homePlanet
  }
}
```

#### [`Run query`]((http://elm-graphql.herokuapp.com/?query=query%20%7B%0A%20%20human(id%3A%20%221001%22\)%7B%0A%20%20%20%20name%0A%20%20%20%20homePlanet%0A%20%20%7D%0A%7D%0A)

# Intro to `elm-graphql`

```elm
query : SelectionSet (Maybe Human) RootQuery
query =
    Query.human { id = Id "1001" } humanSelection

type alias Human =
    { name : String
    , homePlanet : Maybe String
    }

humanSelection : SelectionSet Human StarWars.Object.Human
humanSelection =
    SelectionSet.map2 Human
        Human.name
        Human.homePlanet
```
