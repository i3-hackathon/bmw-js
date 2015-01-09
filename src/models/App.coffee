MojioModel = require('./MojioModel')

module.exports = class App extends MojioModel
    # instance variables
    _schema:             {
                "Type": "String",
                "Name": "String",
                "Description": "String",
                "CreationDate": "String",
                "Downloads": "Integer",
                "RedirectUris": "String",
                "ApplicationType": "String",
                "_id": "String",
                "_deleted": "Boolean"
            }


    _resource: 'Apps'
    _model: 'App'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'Apps'
    @_model: 'App'

    @resource: () ->
        return App._resource

    @model: () ->
        return App._model

