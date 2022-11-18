import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/http;

type request record {
    string nic;
    string address;
    string image;
    string status;
    string gnd;
};

type status record {
    string status;
};

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    resource function post addRequest(@http:Payload request payload) returns sql:ExecutionResult|error {

        mysql:Client mysqlEp1 = check new (host = "workzone.c6yaihe9lzwl.us-west-2.rds.amazonaws.com", user = "admin", password = "Malithi1234", database = "gramaAddressCheck", port = 3306);

        sql:ExecutionResult executeResponse = check mysqlEp1->execute(sqlQuery = `INSERT INTO request VALUES (${payload.nic}, ${payload.address}, ${payload.image}, ${payload.status}, ${payload.gnd})`);
        error? e = mysqlEp1.close();
        if (e is error) {
            return e;
        }
        return executeResponse;

    }

    resource function get addressCheck(string nic) returns status|error? {
        mysql:Client mysqlEp4 = check new (host = "workzone.c6yaihe9lzwl.us-west-2.rds.amazonaws.com", user = "admin", password = "Malithi1234", database = "gramaAddressCheck", port = 3306);

        status|error queryRowResponse = mysqlEp4->queryRow(sqlQuery = `SELECT status FROM request WHERE nic = ${nic} `);
        error? e = mysqlEp4.close();
        if (e is error) {
            return e;
        }
        else {
            return queryRowResponse;
        }

    }


}
