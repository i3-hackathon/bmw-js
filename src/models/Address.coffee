MojioModel = require('./MojioModel')

module.exports = class Address extends MojioModel
    # instance variables
    _schema:             {
                "Address1": "String",
                "Address2": "String",
                "City": "String",
                "State": "String",
                "Zip": "String",
                "Country": "String"
            }


    _resource: 'Addresss'
    _model: 'Address'

    constructor: (json) ->
        super(json)

    # class variables and functions
    @_resource: 'Addresss'
    @_model: 'Address'

    @resource: () ->
        return Address._resource

    @model: () ->
        return Address._model

