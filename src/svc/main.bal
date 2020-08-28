import ballerina/docker;
import ballerina/http;
import ballerina/io;
import ballerina/config;

@docker:Expose {}
listener http:Listener ipgeoEP = new (9090);

@docker:Config {
    name: "$env{IMAGE}",
    registry: "$env{REGISTRY}",
    tag: "$env{VERSION}"
}

@http:ServiceConfig {
    basePath: "/"
}
service ipgeo on ipgeoEP {

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/"
    }
    resource function get(http:Caller caller,
        http:Request req) returns @tainted error? {
        string ip = req.getHeader("x-forwarded-for");
        string country = getCountry(ip, "US");
        io:println("country: " + country);
        string destination = getURL(country);
        io:println("destination: " + destination);
        http:Response outResponse = new;
        check caller->redirect(outResponse, 301, [destination]);
    }
}

function getCountry(string ip, string defaultCountry) returns @tainted string {
    string|error country = geoIP(<@untainted>ip);
    if (country is error) {
        return defaultCountry;
    } else {
        return country;
    }
}

function getURL(string country) returns string {
    string extension = "com";
    match country {
        "US" => {
            extension = "com";
        }
        "GB" => {
            extension = "co.uk";
        }
        "DE" => {
            extension = "de";
        }
        "FR" => {
            extension = "fr";
        }
        "ES" => {
            extension = "es";
        }
        "IT" => {
            extension = "it";
        }
        "JP" => {
            extension = "co.jp";
        }
        "CA" => {
            extension = "ca";
        }
    }
    string product_id = config:getAsString("PRODUCT_ID");
    return "https://www.amazon." + extension + "/dp/" + product_id;
}
