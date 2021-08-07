package org.example

import org.http4k.core.Request
import org.http4k.core.Response
import org.http4k.core.Status
import org.http4k.routing.bind
import org.http4k.routing.routes
import org.http4k.server.Netty
import org.http4k.server.asServer

fun main() {
    App()
}

object App {
    operator fun invoke() {
        val app = routes(
            "/hello" bind ::hello,
            "/health" bind ::health,
            "" bind ::notFound
        )

        val server = app.asServer(Netty(9000)).start()

        Runtime.getRuntime().addShutdownHook(object : Thread() {
            override fun run() {
                print("Shutdown invoked - stopping server")
                server.stop()
            }
        })
    }

    private fun hello(request: Request) = Response(Status.OK).body("Hello, ${request.query("name")}!")
    private fun health(request: Request) = Response(Status.OK).body("OK")
    private fun notFound(request: Request) = Response(Status.NOT_FOUND).body("404 - Not found")
}

