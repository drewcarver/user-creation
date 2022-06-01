
@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()
  
	switch url.path {
    | list{ "userform" } => <UserForm />
	| list{ "routeArgumentDemonstration", param } => <RouteParam param />
	| _ => "Route not found" -> React.string
	}
}
