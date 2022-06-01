open User
%%raw("import  './UserForm.css';")
%%raw("import  'toastify-js/src/toastify.css';")

type userAction =
  | SetFirstName(string)
  | SetLastName(string)
  | SetUserName(string)

type toast = {
	text: string,
	duration: int,
	gravity: [ #top | #bottom ],
	position: [ #left | #center | #right ],
	stopOnFocus: bool,
}
type toastify = { showToast: (. unit) => unit }

@module("./api/userApi.js") external saveUser: user => Js.Promise.t<user> = "default"
@module("toastify-js") external toastify: (toast) => toastify = "default"

let getValue = (result: validatableInput) =>
  switch result {
  | Ok(a) => a
  | Error(a) => a.value
  }

let reducer = (state: user, action: userAction) => {
  switch action {
  | SetFirstName(name) =>
    switch state {
    | ValidUser(u) => createUser(name, u.lastName, u.userName)
    | InvalidUser(u) =>
      createUser(name, u.lastName |> getValue, u.userName |> getValue)
    }
  | SetLastName(name) =>
    switch state {
    | ValidUser(u) => createUser(u.firstName, name, u.userName)
    | InvalidUser(u) =>
      createUser(u.firstName |> getValue, name, u.userName |> getValue)
    }
  | SetUserName(name) =>
    switch state {
    | ValidUser(u) => createUser(u.firstName, u.lastName, name)
    | InvalidUser(u) =>
      createUser(
        u.firstName |> getValue,
        u.lastName |> getValue,
        name,
      )
    }
  }
}

let defaultUser: user = InvalidUser({
  firstName: Error({ value: "", error: ""}),
  lastName: Error({ value: "", error: ""}),
  userName: Error({ value: "", error: ""}),
})

@react.component
let make = () => {
  open ReactEvent
  let (user, dispatch) = React.useReducer(reducer, defaultUser)
  let (hasFirstNameBeenBlurred, setHasFirstNameBeenBlurred) = React.useState(_ => false)
  let (hasLastNameBeenBlurred, setHasLastNameBeenBlurred) = React.useState(_ => false)
  let (hasUserNameBeenBlurred, setHasUserNameBeenBlurred) = React.useState(_ => false)
  let (saving, setSaving) = React.useState(_ => false)

  let disabled = switch user {
  | ValidUser(_) => false
  | InvalidUser(_) => true
  }

  let onClick = (event: ReactEvent.Mouse.t) => {
	setSaving(_ => true)
    saveUser(user) 
	|> Js.Promise.then_(_ => {
		setSaving(_ => false)

		Js.Console.log(toastify)
		toastify({ 
			text: "Save Successful",
			duration: 1000,
			gravity: #top,
			position: #right,
			stopOnFocus: false
		}).showToast(.)

		Js.Promise.resolve()
	})
	|> ignore

    ReactEvent.Mouse.stopPropagation(event)
  }

  <div className="user-page">
    <form
      className="user-form"
      onSubmit={e => {
        ReactEvent.Form.stopPropagation(e)
        ReactEvent.Form.preventDefault(e)
      }}>
      <h1 className="user-form__title"> 
	  {
		"Create New Account" -> React.string
	  } 
	  </h1>
      <label htmlFor="firstName"> { "First Name:" -> React.string } </label>
      <input
        id="firstName"
		className="user-form__input"
		autoComplete={"off"}
        onChange={e => dispatch(SetFirstName(Form.target(e)["value"]))}
		onBlur={_ => setHasFirstNameBeenBlurred(_ => true)}
        value={switch user {
        | ValidUser(u) => u.firstName
        | InvalidUser(u) => u.firstName |> getValue
        }}
      />
	  {
		switch user {
		  | ValidUser(_) | InvalidUser({ firstName: Ok(_) }) | InvalidUser(({ firstName: Error({ error: "" }) })) => <></>
		  | InvalidUser({ firstName: Error(input) }) => <ErrorMessage input showError={hasFirstNameBeenBlurred} />
		}
	  }
      <label htmlFor="lastName">{ "Last Name:" -> React.string }</label>
      <input
        id="lastName"
		className="user-form__input"
		autoComplete={"off"}
        onChange={e => dispatch(SetLastName(Form.target(e)["value"]))}
		onBlur={_ => setHasLastNameBeenBlurred(_ => true)}
        value={switch user {
        | ValidUser(u) => u.lastName
        | InvalidUser(u) => u.lastName |> getValue
        }}
      />
	  {
		switch user {
		  | ValidUser(_) | InvalidUser({ lastName: Ok(_) }) | InvalidUser(({ lastName: Error({ error: "" }) })) => <></>
		  | InvalidUser({ lastName: Error(input) }) => <ErrorMessage input showError={hasLastNameBeenBlurred} />
		}
	  }
      <label htmlFor="userName"> {"User Name:"->React.string} </label>
      <input
        id="userName"
		className="user-form__input"
		autoComplete={"off"}
        onChange={e => dispatch(SetUserName(Form.target(e)["value"]))}
		onBlur={_ => setHasUserNameBeenBlurred(_ => true)}
        value={switch user {
        | ValidUser(u) => u.userName
        | InvalidUser(u) => u.userName |> getValue
        }}
      />
	  {
		switch user {
		  | ValidUser(_) | InvalidUser({ userName: Ok(_) }) | InvalidUser(({ userName: Error({ error: "" }) })) => <></>
		  | InvalidUser({ userName: Error(input) }) => <ErrorMessage input showError={hasUserNameBeenBlurred}/>
		}
	  }
	  {
		  saving
		  ? <span>{ "Saving" -> React.string }</span>
		  : <button 
				disabled 
				onClick
				className="user-form__create-button"
			> 
			{ "Create" -> React.string } 
			</button>
	  }
    </form>
  </div>
}
