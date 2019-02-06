footer: bit.ly/**typeswithoutborders**
build-lists: true
slide-dividers: #

#

[.hide-footer]

![fit](img/opening.jpg)

# The Problem

[Mobster download page](http://mobster.cc/)

# [The Query](https://developer.github.com/v4/explorer/?query=%7B%0A%20%20repository%28owner%3A%20%22dillonkearns%22%2C%20name%3A%20%22mobster%22%29%20%7B%0A%20%20%20%20releases%28last%3A%201%29%20%7B%0A%20%20%20%20%20%20totalCount%0A%20%20%20%20%20%20nodes%20%7B%0A%20%20%20%20%20%20%20%20releaseAssets%28last%3A%2030%29%20%7B%0A%20%20%20%20%20%20%20%20%20%20edges%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20node%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20downloadUrl%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20name%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20downloadCount%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20description%0A%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%20%20%20%20stargazers%20%7B%0A%20%20%20%20%20%20totalCount%0A%20%20%20%20%7D%0A%20%20%7D%0A%7D%0A)

```javascript
{
  repository(owner: "dillonkearns", name: "mobster") {
    releases(last: 1) {
      totalCount
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
        description
      }
    }
    stargazers {
      totalCount
    }
  }
}
```

# Well, Kind Of

- [Tried using a client](https://github.com/dillonkearns/mobster/blob/2ad66f514579a09a9679b75b6c1b2956e7879b46/web/src/GithubGraphql.elm)
- Too many domain concepts:

  ```elm
  ValueSpec NonNull ObjectType StarGazerCount ()
  ```

- No guardrails
- Ended up using a [plain HTTP Request & JSON Decoder](https://github.com/dillonkearns/mobster/blob/2ad66f514579a09a9679b75b6c1b2956e7879b46/web/src/Github.elm)

^ - Needed to run, check, run, check.
^ I ended up just using a regular Http request. I could easily copy-paste a query that I knew worked.

# Landscape of Clients

- GraphQL Query => Elm (for old Elm version).
- Manually define Json Decoders => GraphQL Query & Json Decoder
- GraphQL Schema => Elm API -- my vision

# The Vision

- Typed responses
- Impossible to write an incorrect query
- Started with my itch

^ Wanted guardrails

# The Refined Vision

- Elm gives me clear feedback
- Elm code is 1st class (not `gql` queries)
- Meaningful data structures

^ - Didn't even know if it was possible
^ - Picked a clear strategy with confidence.

^ - I don't want to accept auto-generated data structures as the way to structure my data. I want to choose exactly which data structures I want, and never have the intermediary data structures exist anywhere in my app (immediately map/transform them)

^ - Queries aren't the first-class citizen
^ - CODE is!
^ - Code changes, code is reused, code is refactored.

# Lesson

- Start with a hypothesis
- Clear, focused vision
- It can change over time, but it should always be narrow and clearly defined

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

# [Day 1](https://github.com/dillonkearns/elm-graphql/blob/56495760aabc7dd4944cfaebe998271b38eaca66/tests/Tests.elm)

```elm
type alias Human =
    { name : String }


query : Field.FieldDecoder { name : String }
query =
    Human.human Human { id = "1000" } []
        |> Field.with Human.name
```

# [Day 1](https://github.com/dillonkearns/elm-graphql/blob/56495760aabc7dd4944cfaebe998271b38eaca66/tests/Tests.elm)

```elm
test "generate query document" <| \_ ->
  Field.fieldDecoderToQuery query
    |> Expect.equal
      """{ human(id: "1000") { name } }"""
```

# Day 1

```elm
test "decodes properly" <| \() ->
  """{ "data": { "human": { "name": "Luke Skywalker" } } }"""
  |> Json.Decode.decodeString (Field.decoder query)
  |> Expect.equal (Ok { name = "Luke Skywalker" })
```

# Overview

- History of Elm GraphQL clients
  _ Query generators
  _ Untyped query builders \* Mine - first typed query builder
- Clear vision
- Idiomatic packages
- User feedback
- Stick to a simple core of features/philosophy... refer to that philosophy in issues to guide your discussion and decisions

* API Design

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
