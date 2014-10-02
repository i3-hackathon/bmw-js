Http = require './HttpBrowserWrapper'
SignalR = require './SignalRBrowserWrapper'

module.exports = class MojioClient

    defaults = { hostname: 'sandbox.api.moj.io', port: '80', version: 'v1' }

    constructor: (@options) ->
        @options ?= { hostname: defaults.hostname, port: @defaults.port, version: @defaults.version }
        @options.hostname ?= defaults.hostname
        @options.port ?= defaults.port
        @options.version ?= defaults.version
        @options.application = @options.application
        @options.secret = @options.secret  # TODO:: header and https only
        @options.observerTransport = 'SingalR'
        @conn = null
        @hub = null
        @connStatus = null
        @token = null

        @signalr = new SignalR("http://"+@options.hostname+":"+@options.port+"/v1/signalr",['ObserverHub'], $)

    ###
        Helpers
    ###
    getResults: (type, results) ->
        objects = []
        if (results instanceof Array)
            arrlength = results.length;
            objects.push(new type(result)) for result in results
        else if (results.Data instanceof Array)
            arrlength = results.Data.length;
            objects.push(new type(result)) for result in results.Data
        else if ((result.Data != null))
            objects.push(new type(result.Data))
        else
            objects.push(new type(result))

        return objects


    @_makeParameters: (params) ->
        '' if params.length==0
        query = '?'
        for property, value of params
            query += "#{property}=#{value}&"
        return query.slice(0,-1)

    getPath: (resource, id, action, key) ->
        if (key && id && action && id != '' && action != '')
            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id) + "/" + encodeURIComponent(action) + "/" + encodeURIComponent(key);
        else if (id && action && id != '' && action != '')
            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id) + "/" + encodeURIComponent(action);
        else if (id && id != '')
            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id);
        else if (action && action != '')
            return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(action);

        return "/" + encodeURIComponent(resource);

    dataByMethod: (data, method) ->
        switch (method.toUpperCase())
            when 'POST' or 'PUT' then return @stringify(data)
            else return data

    stringify: (data) ->
        return JSON.stringify(data)

    request: (request, callback) ->
        parts = {
            hostname: @options.hostname
            host: @options.hostname
            port: @options.port
            path: '/'+@options.version
            method: request.method,
            withCredentials: false
        }
        parts.path = '/'+@options.version + @getPath(request.resource, request.id, request.action, request.key)

        if (request.parameters? and Object.keys(request.parameters).length > 0)
            parts.path += MojioClient._makeParameters(request.parameters)

        parts.headers = {}
        parts.headers["MojioAPIToken"] = @getTokenId() if @getTokenId()?
        parts.headers += request.headers if (request.headers?)
        #parts.headers["Access-Control-Allow-Credentials"] = 'true'
        parts.headers["Content-Type"] = 'application/json'

        parts.body = request.body if request.body?

        http = new Http($)
        http.request(parts, callback)


    ###
        Login
    ###
    login_resource: 'Login'

    _login: (username, password, callback) -> # Use if you want the raw result of the call.
        @request(
            {
                method: 'POST', resource: @login_resource, id: @options.application,
                parameters:
                    {
                        userOrEmail: username
                        password: password
                        secretKey: @options.secret
                    }
            }, callback
        )

    # Login
    login: (username, password, callback) ->
        @_login(username, password, (error, result) =>
            if (result?)
                @token = result
            callback(error, result)
        )

    _logout: (callback) ->
        @request(
            {
                method: 'DELETE', resource: @login_resource,
                id: if mojio_token? then mojio_token else @getTokenId()
            }, callback
        )

    # Logout
    logout: (callback) ->
        @_logout((error, result) =>
            @token = null
            callback(error, result)
        )

    mojio_models = {}  # this is so model can use a string to constuct the model.


    App = require('../models/App');
    mojio_models['App'] = App

    Mojio = require('../models/Mojio');
    mojio_models['Mojio'] = Mojio

    Trip = require('../models/Trip');
    mojio_models['Trip'] = Trip

    User = require('../models/User');
    mojio_models['User'] = User

    Vehicle = require('../models/Vehicle');
    mojio_models['Vehicle'] = Vehicle

    Product = require('../models/Product');
    mojio_models['Product'] = Product

    Subscription = require('../models/Subscription');
    mojio_models['Subscription'] = Subscription

    Event = require('../models/Event');
    mojio_models['Event'] = Event


    Observer = require('../models/Observer');
    mojio_models['Observer'] = Observer

    # Make an app from a result
    model: (type, json=null) ->
        if (json == null)
            return mojio_models[type]
        else if (json.Data instanceof Array)
            object = new Array()
            object.push(new mojio_models[type](data)) for data in json.Data
        else if (json.Data?)
            object = new mojio_models[type](json.Data)
        else
            object = new mojio_models[type](json)
        object._client = @
        return object

    # Model CRUD
    # query(model, { criteria={ name="blah", field="blah" }, limit=10, offset=0, sortby="name", desc=false }, callback) # take parameters as parameters.
    # query(model, { criteria="name=blah; field=blah", limit=10, offset=0, sortby="name", desc=false }, callback)
    # query(model, { name: "blah", field: blah"}, callback)
    query: (model, parameters, callback) ->
        if (parameters instanceof Object)
            # convert criteria to a semicolon separated list of property values.
            if (!parameters.criteria?) # if the list doesn't contain "Criteria" convert it to a string based criteria list.
                # version: query(model, { name: "blah", field: blah"}, callback)
                query_criteria = ""
                for property, value of parameters
                    query_criteria += "#{property}=#{value};"
                parameters = { criteria:  query_criteria }
            # otherwise, take the parameters as they are:
            # query(model, { criteria={ name="blah", field="blah" }, limit=10, offset=0, sortby="name", desc=false }, callback) # take parameters as parameters.
            # query(model, { criteria="name=blah; field=blah", limit=10, offset=0, sortby="name", desc=false }, callback)

            @request({ method: 'GET',  resource: model.resource(), parameters: parameters}, (error, result) =>
                callback(error, @model(model.model(), result))
            )
        else if (typeof parameters == "string") # instanceof only works for coffeescript classes.

            @request({ method: 'GET',  resource: model.resource(), parameters: {id: parameters} }, (error, result) =>
                callback(error, @model(model.model(), result))
            )
        else
            callback("criteria given is not in understood format, string or object.",null)

    get: (model, criteria, callback) ->
        @query(model, criteria, callback)

    save: (model, callback) ->
        @request({ method: 'PUT', resource: model.resource(), body: model.stringify(), parameters: {id: model._id} }, callback)

    put: (model, callback) ->
        @save(model, callback)

    create: (model, callback) ->
        @request({ method: 'POST', resource: model.resource(), body: model.stringify() }, callback)

    post: (model, callback) ->
        @create(model, callback)

    delete: (model, callback) ->
        @request({ method: 'DELETE',  resource: model.resource(), parameters: {id: model._id} }, callback)

    ###
            Schema
    ###
    _schema: (callback) -> # Use if you want the raw result of the call.
        @request({ method: 'GET', resource: 'Schema'}, callback)

    schema: (callback) ->
        @_schema((error, result) => callback(error, result))

    ###
            Observer
    ###

    observe: (object, subject=null, observer_callback, callback) ->
        # subject is { model: type, _id: id }
        if (subject == null)
            observer = new Observer(
                {
                    ObserverType: "Generic", Status: "Approved", Name: "Test"+Math.random(),
                    Subject: object.model(), SubjectId: object.id(), "Transports": "SignalR"
                }
            )

        else
            observer = new Observer(
                {
                    ObserverType: "Generic", Subject: subject.model(), SubjectId: subject.id(),
                    Parent: object.model(), ParentId: object.id(), "Transports": "SignalR"
                }
            )

        @request({ method: 'PUT', resource: Observer.resource(), body: observer.stringify()}, (error, result) =>
            if error
                callback(error, null)
            else
                observer = new Observer(result)
                @signalr.subscribe('ObserverHub', 'Subscribe', observer.SubjectId, observer.id(), observer_callback, (error, result) ->
                    callback(null, observer)
                )
        )

    unobserve: (observer, subject, observer_callback=null, callback) ->
        if !observer || !subject?
            callback("Observer and subject required.")
        else
            @signalr.unsubscribe('ObserverHub', 'Unsubscribe', subject.id(), observer.id(), observer_callback, (error, result) ->
                callback(null, observer)
            )

    ###
        Storage
    ###

    store: (model, key, value, callback) ->
        if !model || !model._id
            callback("Storage requires an object with a valid id.")
        else
            @request({ method: 'PUT', resource: model.resource(), id: model.id(), action: 'store', key: key, body: JSON.stringify(value) }, (error, result) =>
                if error
                    callback(error, null)
                else
                    callback(null, result)
            )
    storage: (model, key, callback) ->
        if !model || !model._id
            callback("Get of storage requires an object with a valid id.")
        else
            @request({ method: 'GET', resource: model.resource(), id: model.id(), action: 'store', key: key}, (error, result) =>
                if error
                    callback(error, null)
                else
                    callback(null, result)
            )

    unstore: (model, key, callback) ->
        if !model || !model._id
            callback("Storage requires an object with a valid id.")
        else
            @request({ method: 'DELETE', resource: model.resource(), id: model.id(), action: 'store', key: key}, (error, result) =>
                if error
                    callback(error, null)
                else
                    callback(null, result)
            )

    ###
        Signal R
    ###

    getTokenId:  () ->
        return if @token? then @token._id else null

    getUserId:  () ->
        return if @token? then @token.UserId else null

    isLoggedIn: () ->
        return getUserId() != null

    getCurrentUser: (func) ->
        if (@user?)
            func(@user)
        else if (isLoggedIn())
            get('users', getUserId())
            .done( (user) ->
                    return unless (user?)
                    @user = user if (getUserId() == @user._id)
                    func(@user)
                )
        else
            return false
        return true