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

- It boils down to this: what can we know before we run our program?
- What can we know will always be true (invariants)?

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

---

# Thank You!

### [github.com/**DillonKearns**](http://github.com/dillonkearns)

### [incrementalelm.com](http://incrementalelm.com)

![](../safe-web-dev/climbing.jpg)
