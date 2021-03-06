footer: [github.com/**DillonKearns**/talks](http://github.com/dillonkearns/talks) @dillontkearns
build-lists: true

# Developing For The Web With Extreme Safety

^ Elm has language features that support safety
Also has ethos that promotes safety
Lots of innovation inspired by features & ethos

## [github.com/**DillonKearns**](http://github.com/dillonkearns)

![](climbing.jpg)

---

![left 90%](elm.png)
![right 50%](modern-agile.jpg)

---

# **What Does Safety Look Like In Your Codebase?**

![](10.jpg)

---

# **Elm** ![](https://upload.wikimedia.org/wikipedia/commons/f/f3/Elm_logo.svg)

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

# **Safety Tips**

1. Traceability
1. Domain Modeling
1. Consumer-Driven APIs

![](climbing-gear.jpg)

---

# 1) **Traceability**

* Uncertainty as data
* Managed effects

![right ](13.jpg)

---

# 1) **Traceability**

```elm, [.highlight: 1]
uncertaintyAsData -- How do you deal with uncertainty?
managedEffects
```

* No null, Maybe union instead

---

# **Uncertainty as Data**

### The `Maybe` type

```elm
type Maybe value
  = Just value
  | Nothing
```

#### Examples

```elm
List.head [100, 200, 300] == Just 100

List.head [] == Nothing
```

---

# **`Maybe` Compiler Feedback**

```elm
describeFirst myList =
    case List.head myList of
        Just firstItem ->
            "The first item is: " ++ firstItem
```

![inline](compiler-errors/Maybe-error.png)

---

# **`Maybe` Compiler Feedback**

```elm, [.highlight: 6-7]
describeFirst myList =
    case List.head myList of
        Just firstItem ->
            "The first item is: " ++ firstItem

        Nothing ->
            "The first item is not present!"
```

---

# 1) **Traceability**

```elm, [.highlight: 1]
uncertaintyAsData -- How do you deal with uncertainty?
managedEffects
```

* Can't raise exceptions
* No global exception handlers squelching errors
* No propagating hard-to-debug nulls from exception handlers
* Errors are traceable
* Exceptions are like `GOTO`s
* ...Except the destination line is determined by outside context
* `goto ???`

---

# **Handling `Result`s**

```elm
intOrNegativeOne userInputString =
    case String.toInt userInputString of
        Ok intValue ->
            intValue
```

---

![fit](compiler-errors/Result-error.png)

---

# **Handling `Result`s**

```elm
intOrNegativeOne userInputString =
    case String.toInt userInputString of
        Ok intValue ->
            intValue

        Err errorMessage ->
            -1
```

---

# **Uncertainty as Data**

### The `Result` type

```elm
type Result data error
  = Ok data
  | Err error
```

#### Examples

```elm
String.toInt "-42" == Ok -42
String.toInt "3.1" == Err "could not convert string '3.1' to an Int"
```

---

# Dealing With Uncertainty

```elm
intOrNegativeOne userInputString =
    case String.toInt userInputString of
        Ok intValue ->
            intValue

        Err errorMessage ->
            -1
```

### `case` can also be written as

```elm
userInputString
  |> String.toInt
  |> Result.withDefault -1
```

---

# 1) **Traceability**

```elm, [.highlight: 2]
uncertaintyAsData
managedEffects
```

* Funnel all side-effects to one place
* Single place where non-determinism/side effects stem from
* Single place where the results of non-determinism/side-effects funnels into

---

![fit](elm-architecture.jpeg)

---

# 2) **Domain Modeling**

* [Make Impossible States Impossible](https://www.youtube.com/watch?v=IcgmSRJHu_8)
* Contract-Driven Design
* More compiler guarantees =>
  More focused tests & fewer bugs

![left filtered](climbing-gear2.jpg)

---

# 2) **Domain Modeling**

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

# **Decoding JSON**

`````javascript
json = { "first": "Beverly", "last": "Crusher" }
```

### Discover contract violations at the gate

```elm
decodeString (field "first" string) json
-- =>
Err "Expecting an object with a field named `name` but instead got: ..."
```

---

# **Decoding JSON**

````javascript
json = { "first": "Beverly", "last": "Crusher" }
```

...

```elm
Decode.decodeString (Decode.field "name" Decode.string) json
-- =>
Ok "Beverly"
`````

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

![fit](remote-data-truth-table.png)

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

# 3) **Consumer-Driven APIs**

### What does UX for APIs have to do with safety?

* Guide towards correct use
* Minimal interface
* Trying to support everything is a hazard
* Start opinionated, minimal
* Introduce flexibility as needed

![left](2.jpg)

---

# **Style Elements Package**

* Fully specify your layouts inline
* No cascading, no indirection
* Plain code, no separate DSL for classes, ids, stylesheets
* If there is a layout problem, you know exactly where to look
* Helps enforce accessibility

^ If you add, change, delete, refactor something about layout, it won’t modify the layout of any other thing unless that thing specifically points to an abstraction that you are changing (a constant or a function). Contrast this with CSS: perhaps another CSS file is being added that you’re not aware of and you’re overriding one of its rules when you do `table td a { color: chartreuse }`

![](5.jpg)

---

# Misleading Error

![fit original](misleading-cli-error-message.png)

---

```javascript, [.highlight: 17]
var args = minimist(process.argv.slice(2), {
  alias: {
    help: "h",
    fuzz: "f",
    seed: "s",
    compiler: "c",
    "add-dependencies": "a",
    report: "r",
    watch: "w"
  },
  boolean: ["warn", "version", "help", "watch"],
  string: ["add-dependencies", "compiler", "seed", "report", "fuzz"]
});
function runElmTest() {
  checkNodeVersion();

  if (args._[0] == "init") {
    var cmdArgs = Init.init();
    var cmd = [pathToElmPackage, "install", "--yes"].concat(cmdArgs).join(" ");

    child_process.execSync(cmd, { stdio: "inherit", cwd: Init.elmPackageDir });

    process.exit(0);
  }
```

[Github source](https://github.com/rtfeldman/node-test-runner/blob/4f9147f687e5636e0c2fd0b661ab5262c9e90faf/lib/elm-test.js#L287)

---

# **elm-cli**

* Declarative vs. Imperative
* Upfront contract enforcement (eager)
* Can't access data that won't be present
* Helps enforce good UX

^ Instead of checking if certain things are present and letting uncertainty slip through,
catch contract violations at the gate and don't let them through.

---

# GraphQL **Enforce Contracts at the Gate**

```elm
{
  human(id: "1000") {
    name
    height
  }
}
```

---

# **Minimize Constructs**

## Variables

```elm
query HeroName($episode: Episode) {
  hero(episode: $episode) {
    name
  }
}
```

---

# **Minimize Constructs**

### Aliases & Fragments

```elm
{
  leftComparison: hero(episode: EMPIRE) {
    ...comparisonFields
  }
  rightComparison: hero(episode: JEDI) {
    ...comparisonFields
  }
}

fragment comparisonFields on Character {
  name
  appearsIn
  friends {
    name
  }
}
```

---

# **Graphqelm**

* Generate Elm code based on your GraphQL schema

* If it compiles, it's valid
* Types are known at compile-time

![](6.jpg)

^ As long as you never make backwards-incompatible API changes in your GraphQL server (this is considered the best practice by many companies including Facebook), your Graphqelm queries will be valid even if it gets out of date. But you could always put a script in your CI pipeline to regenerate the code and check if it still compiles, fail if it doesn’t… this will guarantee that you never have any backwards incompatible changes that get to production.
The types of the returned data you get back are known at runtime, including whether something might be null or not.

---

# **Takeaways**

* Work backwards from constraints
* Guarantees are better than discipline
* Fewer features means more safety

---

(1) **Traceability**

* Uncertainty as data
* Managed effects

(2) **Domain Modeling**

* [Make Impossible States Impossible](https://www.youtube.com/watch?v=IcgmSRJHu_8)
* Contract-Driven Design

(3) **Consumer-Driven APIs**

* Guide towards correct use
* Minimal interface
* Opinionated, minimal

![left ](12.jpg)

---

# **Thank You!**

## Questions?

![](climbing.jpg)
