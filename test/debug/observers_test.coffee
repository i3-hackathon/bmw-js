MojioClient = require '../../src/nodejs/MojioClient'
Observer = require '../../src/models/Observer'
App = require '../../src/models/App'
config = require '../config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('../data/mojio-test-data')
should = require('should')
count = [0,0]
app1=null
app2=null
observer = null
describe 'Observer', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test Observer

    it 'can Observe Object', (done) ->
        app = new App().mock()

        mojio_client.post(app, (error, result) ->
            (error==null).should.be.true
            app = new App(result)
            console.log("created app")

            mojio_client.observe(app, null,
                (entity) ->
                    entity.should.be.an.instanceOf(Object)
                    console.log("Observed change seen.")
                    mojio_client.unobserve(observer, app, null, (error, result) ->
                        result.should.be.an.instanceOf(Observer)
                        done()
                    )
                ,
                (error, result) ->
                    app.Description = "Changed"
                    console.log("changing app...")
                    result.should.be.an.instanceOf(Observer)
                    observer = result

                    mojio_client.put(app, (error, result) ->
                        (error==null).should.be.true
                        console.log("App changed.")
                    )
            )
        )

    it 'can Observe 2 Objects Separately.', (done) ->
        app = new App().mock()

        doubleDone = (which) ->
            count[which]++
            if (count[0] == 1 && count[1]==1)
                done()
            else if (count[0] > 1 || count[1] > 1)
                true.should.be.false

        mojio_client.post(app, (error, result) ->
            (error==null).should.be.true
            app1 = new App(result)
            console.log("created app1")

            mojio_client.post(app, (error, result) ->
                (error==null).should.be.true
                app2 = new App(result)
                console.log("created app2")

                mojio_client.observe(app1, null,
                    # Callback for app1.
                    (entity) ->
                        entity.should.be.an.instanceOf(Object)
                        console.log("observed change app1")
                        entity._id.should.be.equal(app1._id)
                        doubleDone(0)
                    ,
                    (error, result) ->
                        mojio_client.observe(app2, null,
                            # Callback for app2.
                            (entity) ->
                                entity.should.be.an.instanceOf(Object)
                                console.log("observed change app2")
                                entity._id.should.be.equal(app2._id)
                                doubleDone(1)
                            ,
                            (error, result) ->
                                app1.Description = "Changed1"
                                mojio_client.put(app1, (error, result) ->
                                    (error==null).should.be.true
                                    console.log("updated app1")
                                )
                                app2.Description = "Changed2"
                                mojio_client.put(app2, (error, result) ->
                                    (error==null).should.be.true
                                    console.log("updated app2")
                                )
                        )
                )

            )
        )