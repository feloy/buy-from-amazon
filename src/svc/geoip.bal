import ballerina/http;
import ballerina/io;
import ballerina/config;

type Response record {
    string country_code;
};

public function geoIP(string ip) returns @tainted string|error {    
    io:println("ip: " + ip);
    http:Client clientEP = new ("http://api.ipstack.com");
    string key = config:getAsString("IPSTACK_ACCESS_KEY");
    http:Response resp = check clientEP->get("/" + ip + "?access_key=" + key + "&fields=country_code");
    json payload = check resp.getJsonPayload();
    io:print("payload: ", payload, "\n");
    Response response = check Response.constructFrom(payload);
    return response.country_code;
}
