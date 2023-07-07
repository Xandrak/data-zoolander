module Types.Person exposing ()

-- Invalid/Editable Person

{- This module would expose EditablePerson, update, EditableField, and incompleteFieldErrorMessage -}

module EditablePerson exposing (EditablePerson, Msg, EditableField, update, incompleteFieldErrorMessage)

type alias EditablePerson = 
    { firstName : EditableField
    , firstNameError : Maybe String
    , lastName : EditableField
    , lastNameError : Maybe String
    , socialSecurityNumber : EditableField
    , socialSecurityNumberError : Maybe String
    , maritalStatus : EditableField
    , maritalStatusError : Maybe String
    , usPhoneNumber : EditableField 
    , usPhoneNumberError : Maybe String
    }

type Msg
    = SetFirstName String
    | SetLastName String
    | SetSocialSecurityNumber String
    ...

{- Example usage in update-}
update : Msg -> Model -> (Model, Cmd Msg)
update msg model ->
    case msg of
        SetFirstName newFirst ->
            let newName = if (newFirst == "") then
                            Incomplete
                          else 
                            Complete newFirst
            in
            { model | firstName = newName, firstNameError = Just incompleteFieldErrorMessage }
        ...

type EditableField 
    = Incomplete
    | Complete String

incompleteFieldErrorMessage : String
incompleteFieldErrorMessage =
    "Please check the field again, and ensure it's completed."


-- Validated Person

{- Expose as little as possible of ValidatedPerson. Expose only smart constructors and validation for working with the type if necessary. 
    For instance: stringToFirstName and validatePerson. We could also utilize Opaque types to enforce invariants and hide the internals of ValidatedPerson, but
    I am not so sure the feeling of clunkiness would be warranted.
-}

module ValidatedPerson exposing (stringToFirstName, validatePerson)

type alias ValidatedPerson =
        { firstName : FirstName
        , lastName : LastName
        , socialSecurityNumber : SocialSecurityNumber
        , maritalStatus : MaritalStatus
        , usPhoneNumber : USPhoneNumber
        }

type FirstName = FirstName String

stringToFirstName : String -> Result String FirstName
stringToFirstName nameStr =
    case nameStr of
        "" ->
            Err "Cannot have empty string as FirstName"
        _ ->
            Ok (FirstName nameStr)


type LastName = LastName String

stringToLastName : String -> Result String LastName
stringToLastName nameStr =
  ...

type SocialSecurityNumber = SocialSecurityNumber String

type MaritalStatus = MaritalStatus String

type USPhoneNumber = USPhoneNumber String


{- We'll need to parse the data into a valid person. -}
validatePerson : EditablePerson -> Result String ValidatedPerson
validatePerson person =
 ...

{- In my experience, the validatePerson function will be composed of some of the following validation rules: 
    - Tongue-in-cheek humor but still something to think about https://www.kalzumeus.com/2010/06/17/falsehoods-programmers-believe-about-names/
    
    1. Depending on backend and/or third-party API constraints, limiting the amount of characters for fields.
    2. Even though Elm escapes user input via elm/Html, some things like CSV injection attacks can still occur. Therefore, validation on ensuring 
        alphanumeric fields stay alphanumeric, numeric fields contain only numbers, etc. should be enforced.
    3. Even though Elm helps cover most of our tracks, I would still consult OWASP Top 10 and be mindful.
    4. Standard US Phone numbers are 10 digits long.
    5. SSNs are 9 digits long.
    6. Depending on who you ask, marital status can be more than a few things. Is there a standard to base a rule off of? If so, that should be the rule.
    7. Could maybe consider using a NonEmpty community package in Elm or at least have types on the backend use it.
    8. Ensure nothing is empty/empty string that can't be.
    9. 
-}
