footer: [github.com/**DillonKearns**/talks](http://github.com/dillonkearns/talks) @dillontkearns
build-lists: true

# Developing For The Web With Extreme Safety

<!-- ## **Dillon Kearns** -->

## [github.com/**DillonKearns**](http://github.com/dillonkearns)

![](climbing.jpg)

---

![fit](modern-agile.jpg)

---

# **Safety Tips**

1. Domain Modeling
1. Traceability
1. Consumer-Driven APIs

![](climbing-gear.jpg)

---

# Elm ![](https://upload.wikimedia.org/wikipedia/commons/f/f3/Elm_logo.svg)

* Language for client-side web apps
* Compiles to JavaScript
* Unlike TypeScript, ES2015, PureScript, etc., Elm lives in a sandbox
* Elm can call JavaScript, but not directly
* Based on Haskell
* Language choices favor  simplicity
* Explicit over terse
* No runtime errors

![left](/Users/dillon/Downloads/IMG_4262.JPG)

---

# 1) **Domain Modeling**

* [Make Impossible States Impossible](https://www.youtube.com/watch?v=IcgmSRJHu_8)
* Contract-Driven Design
* More compiler guarantees =>
  More focused tests & fewer bugs

![left filtered](climbing-gear2.jpg)

---

# 1) **Domain Modeling**

```elm, [.highlight: 1]
contracts -- decoders
impossibleStates -- union types
```

* Without contracts, errors creep deep into the system
  => harder to trace
* Untyped => Typed
* No exceptions, errors are just data
* Annoyance at first, can't live without it once you get used to it

---

### The `Result` type

```elm
type Result data error
  = Ok data
  | Err error
```

### Decoding JSON

```elm
  json = """{ "first": "Beverly", "last": "Crusher" }"""

  decodeString (field "first" string) json
    == Ok "Beverly"
```

---

```elm
  json = """{ "first": "Beverly", "last": "Crusher" }"""

  Decode.decodeString (Decode.field "name" Decode.string) json
  -- =>
  Err "Expecting an object with a field named `name` but instead got: ..."
```

---

# **Data Modeling Example**

JavaScript

```javascript
{
    hasError: true,
    errorMessage : 'Error message from server',
    doneLoading: true,
    data: null
}
```

---

![fit](/Users/dillon/Downloads/Remote Data Truth Table - Sheet1 \(1\).pdf)

---

# Elm Data Modeling

```elm
type RemoteData data  -- we're defining a union type
    = NotAsked
    | Loading
    | Failure Http.Error
    | Success data
```

#### Constructing Union Types

```elm
Success { first = "James", last = "Kirk" }
Failure Http.Timeout
Loading
```

---

[krisajenkins/remotedata](http://package.elm-lang.org/packages/krisajenkins/remotedata/latest)

---

# 2) **Traceability**

## Managed effects

* Funnel all side-effects to one place
* Managed Effects
  * Single place where non-determinism/side effects stem from
  * Single place where the results of non-determinism/side-effects funnels into

![right ](13.jpg)

---

# 2) **Traceability**

## Dealing with uncertainty

* Errors are data
* No null, Maybe union instead
* Errors are traceable

![right ](13.jpg)

---

# 2) **Traceability**

```elm, [.highlight: 1]
dealingWithUncertainty
managedEffects
```

* Errors are data
* No null, Maybe union instead
* Errors are traceable

![right ](13.jpg)

---

# 3) **Consumer-Driven APIs**

### What does UX for APIs have to do with safety?

* Guide towards correct use
* Minimal interface
* Trying to support everything is a hazard
* Start opinionated, minimal
* Introduce flexibility as needed

![left ](2.jpg)

---

![fit](elm-architecture.jpeg)
