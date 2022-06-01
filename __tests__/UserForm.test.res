open Jest
open Expect

test("Component renders", () =>
    <UserForm />
    ->expect
    ->toMatchSnapshot
);
