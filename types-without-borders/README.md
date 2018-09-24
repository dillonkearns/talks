# Types Without Borders Resources

## Contact Info

Email: [info@incrementalelm.com](http://incrementalelm.com)

Elm Slack: [@dillonkearns](https://elmlang.slack.com/team/U3LGUAF54)

Twitter: [@dillontkearns](https://twitter.com/dillontkearns)

## Libraries Discussed

- Type-Safe Server-to-Elm - [`dillonkearns/elm-graphql`](https://github.com/dillonkearns/elm-graphql)
- Type-Safe JavaScript Interop - [`dillonkearns/elm-typescript-interop`](https://github.com/dillonkearns/elm-typescript-interop) (see the [`elm-typescript-starter`](https://github.com/dillonkearns/elm-typescript-starter) which uses `elm-typescript-interop`).
- Type-Safe Electron - [`dillonkearns/elm-electron`](https://github.com/dillonkearns/elm-electron)

## Representing Contracts in Elm

When you're representing an external system's contract within Elm's type system
(such as a GraphQL schema), you need some of the core techniques for representing
contracts within Elm. These are some great resources:

### Charlie Koster's Medium posts on Advanced Types

- [Opaque Types](https://medium.com/@ckoster22/advanced-types-in-elm-opaque-types-ec5ec3b84ed2)
- [Extensible Records](https://medium.com/@ckoster22/advanced-types-in-elm-extensible-records-67e9d804030d)
- [Phantom Types](https://medium.com/@ckoster22/advanced-types-in-elm-phantom-types-808044c5946d)

### Some Videos About Advanced Elm Types

- [Making Impossible States Impossible](https://www.youtube.com/watch?v=IcgmSRJHu_8) - Richard
- [Make Data Structures](https://www.youtube.com/watch?v=x1FU3e0sT1I&list=PL-cYi7I913S-VgTSUKWhrUkReM_vMNQxG&index=11) - Richard
- [Scaling Elm Apps](https://www.youtube.com/watch?v=DoA4Txr4GUs) - Richard

Another important technique for building (or code-generating) libraries is having a minimal interface.
elm-style-elements (now elm-ui) is a great example of this:

- [Understanding Style](https://www.youtube.com/watch?v=NYb2GDWMIm0) - Matt Griffith

## Future Ideas

This talk explores the idea of doing
[Evergreen Elm](https://www.youtube.com/watch?v=4T6nZffnfzg)
