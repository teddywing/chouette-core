
# Authorization Logic in Policies

## Base Rules

### ApplicationPolicy

Policies inheriting from the `ApplicationPolicy` authorize _Undestructive_ _Permissions_ whiche are `index?` and
`show?`. And forbid _Destructive_ _Permissions_ which are `create?`, `destroy?` & `update`.

These _CRUD_ permissions are tied to to _Action_ permissions, `delete?`→ `destroy?`, `edit?` → `update? and `new?`→ `create?`.

These three _Action_ permissions are not supposed to be overriden in `ApplicationPolicy` subclasses.


### Common Policy Types

There are two common policy types.

#### Read Only Type Policy

This corresponds to inheriting from  `ApplicationPolicy` without overriding one of the five aforementioned _CRUD_ permissions.

The following Policies are of this type.

  - `Company`
  - `GroupOfLine`
  - `Line` + custom
  - `Network`
  - `StopArea`

#### Standard Type Policy

The standard type policy inherits from `ApplicationPolicy` does not override any _Undesructive_ _Pemission_ but overrides the _Destructive_ ones.

Normally, but not always they are overriden as follows

```ruby
      def <destructive>?
        !archived? && organisation_match? && user.has_permission('<resource in plural form>.<action>')
      end
```

There are some variations (**TO BE CLARIFIED**) concerning `organisation_match?`.

The following Policies are of this type.

  - `AccessLink`
  - `AccessPoint`
  - `Calendar` (*)
  - `ConnectionLink`
  - `JourneyPattern`
  - `Referential` + custom
  - `Route`
  - `RoutingConstraintZone`
  - `TimeTable` + custom

`Calendar` is a strange exception where no user permission is checked for the _destructive_ _permissions_.




