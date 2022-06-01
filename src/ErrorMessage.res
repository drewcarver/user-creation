%%raw("import './ErrorMessage.css'")

@react.component
let make = (~input: User.inputError, ~showError: bool) => {
    switch (input.error, showError) {
        | ("", _) | (_, false) => <></>
        | (error, _) => <span className="error-message">{ error -> React.string }</span>
    }
}