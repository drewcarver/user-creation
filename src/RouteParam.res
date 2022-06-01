
@react.component
let make = (~param) => {
    <h1>{ param -> Belt.Int.fromString -> Belt.Option.mapWithDefault("Not a number" -> React.string, React.int) }</h1>
}