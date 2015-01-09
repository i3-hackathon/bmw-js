MojioModel = require('./MojioModel')

module.exports = class Subscription extends MojioModel
    # instance variables
    _schema:             {
                "Type": "Integer",
                "ChannelType": "Integer",
                "ChannelTarget": "String",
                "AppId": "String",
                "OwnerId": "String",
                "Event": "Integer",
                "EntityType": "Integer",
                "EntityId": "String",
                "Interval": "Integer",
                "LastMessage": "String",
                "_id": "String",
                "_deleted": "Boolean"
            }


    _resource: 'Subscriptions'
    _model: 'Subscription'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'Subscriptions'
    @_model: 'Subscription'

    @resource: () ->
        return Subscription._resource

    @model: () ->
        return Subscription._model

