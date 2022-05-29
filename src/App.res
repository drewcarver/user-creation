
@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()
  
	switch (url.path) {
    | list{ "userform" } => <UserForm />
		| _ => "Route not found" -> React.string
	}
}
