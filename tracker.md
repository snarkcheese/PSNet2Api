
# Tracker

## AccessLevels

- [x] /accesslevels
    - [x] GET
    - [x] POST
    - [x] DELETE
- [x] /accesslevels/{id}
    - [x] GET
    - [x] PUT
- [x] GET /accesslevels/{id}/detail
- [x] GET /accesslevels/areas

## AreaGroups

- [x] GET /areagroups
- [x] GET /areagroups/{id}

## Authorization

- [x] POST /authorization/tokens
- [x] DELETE /authorization/tokens

## Commands

- [x] POST /commands/door/open
- [x] POST /commands/door/holdopen
- [x] POST /commands/door/close
- [ ] POST /commands/door/control
- [x] POST /commmands/antipassback/reset

## Database

- [x] GET /customquery/querydb

## Doors

- [x] GET /doors
- [x] GET /doors/{id}
- [x] GET /doorgroups/{doorGroupId}/doors
- [x] GET /doorgroups/root/doors
- [x] GET /doorgroups
- [x] GET /doorgroups/{id}

## Events

- [x] GET /events/lastunknowntokens
- [x] GET /events
- [ ] /events/acknowledge
    - [ ] GET
    - [x] POST

## IoBoards

- [x] GET /ioboards
- [x] GET /ioboards/{id}
- [x] GET /ioboards/{id}/inputs
- [x] GET /ioboards/{id}/outputs
- [x] GET /ioboards/{id}/detail
- [ ] POST /ioboards/{id}/relays

## Operators

- [x] GET /operators

## RollCallreports

- [x] GET /rollcalreports/{id}
- [ ] /rollcallreports
    - [x] GET
    - [ ] POST
- [x] GET /rollcallreports/{id}/reportitems
- [x] GET /rollcallreports/{id}/repottitems/{userId}
- [ ] POST /rollcalreports/{id}/reportitems/{userId}/safeupdates
- [ ] DELETE /rollcalreports/{id}/reportitems/{userId}/safeupdates/{safeById}

## ServerSettings

- [x] GET /serversettings/features
- [x] GET /serversettings/properties

## Timezones

- [ ] /timezones
    - [x] GET
    - [ ] POST
- [ ] /timezones/{id}
    - [ ] DELETE
    - [x] GET
    - [ ] PUT
- [x] GET /timezones/{id}/detail
- [x] GET /timezones/days
- [x] GET /timezones/days/{id}

## Users

- [ ] /users
    - [x] DELETE
    - [x] GET
    - [ ] POST
- [x] GET /departments/{departmentId}/users
- [x] GET /departments/root/users
- [ ] /users/{id}
    - [ ] DELETE
    - [x] GET
    - [ ] PUT
- [ ] /users/{userId}/departments
    - [ ] DELETE
    - [x] GET
    - [x] PUT
- [x] /departments
    - [x] GET
    - [x] POST
- [x] /departments/{id}
    - [x] DELETE
    - [x] GET
    - [x] PUT
- [ ] /users/{userId}/doorpermissionset
    - [x] GET
    - [ ] PUT
- [ ] /users/{userId}/image
    - [ ] DELETE
    - [x] GET
    - [ ] PUT
- [x] /users/{userId}/tokens
    - [x] GET
    - [x] POST
- [x] /users/{userId}/tokens/{tokenId}
    - [x] DELETE
    - [x] GET
    - [x] PUT
- [x] GET /users/token/types
- [x] GET /users/customfieldnames/{id}
- [x] GET /users/customfieldnames

## Versions

- [x] GET /versions