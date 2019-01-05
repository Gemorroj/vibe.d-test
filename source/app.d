import vibe.d;

void main()
{
	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	settings.errorPageHandler = toDelegate(&errorPage);

	/*settings.tlsContext = createTLSContext(TLSContextKind.server);
	settings.tlsContext.useCertificateChainFile("server-cert.pem");
	settings.tlsContext.usePrivateKeyFile("server-key.pem");*/

	auto router = new URLRouter;
	router.get("/hello", &hello);
	router.get("/", staticTemplate!"index.dt");
	router.get("*", serveStaticFiles("./public/"));

	listenHTTP(settings, router);

	logInfo("HTTP server started on http://127.0.0.1:8080");
	runApplication();
}

void hello(HTTPServerRequest req, HTTPServerResponse res)
{
	res.writeBody("Hello, World!");
}

void errorPage(HTTPServerRequest req, HTTPServerResponse res, HTTPServerErrorInfo error)
{
	res.writeBody(error.message ~ "\n" ~ error.debugMessage);
}
