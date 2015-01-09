MojioModel = require('./MojioModel')

module.exports = class User extends MojioModel
    # instance variables
    _schema:             {
                "Type": "String",
                "Name": "String",
                "UserName": "String",
                "FirstName": "String",
                "LastName": "String",
                "Email": "String",
                "UserCount": "Integer",
                "Credits": "Integer",
                "CreationDate": "String",
                "LastActivityDate": "String",
                "LastLoginDate": "String",
                "_id": "String",
                "_deleted": "Boolean"
            }


    _resource: 'Users'
    _model: 'User'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'Users'
    @_model: 'User'

    @resource: () ->
        return User._resource

    @model: () ->
        return User._model

