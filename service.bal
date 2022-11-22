import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/http;

configurable int PORT = ?;
configurable string DB = ?;
configurable string PASSWORD = ?;
configurable string USER = ?;
configurable string HOST = ?;

type request record {
    string nic;
    string address;
    string image;
    string status;
    string phone;
    string email;
};

type status record {
    string status;
};

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    resource function post addRequest(@http:Payload request payload) returns sql:ExecutionResult|error {

        mysql:Client mysqlEp1 = check new (host = HOST, user = USER, password = PASSWORD, database = DB, port = PORT);

        sql:ExecutionResult executeResponse = check mysqlEp1->execute(sqlQuery = `INSERT INTO request(nic,address,image,status,phone,email) VALUES(${payload.nic}, ${payload.address}, ${payload.image}, ${payload.status}, ${payload.phone}, ${payload.email})`);
        error? e = mysqlEp1.close();
        if (e is error) {
            return e;
        }
        return executeResponse;

    }

    resource function get addressCheck(string nic) returns status|error? {
        mysql:Client mysqlEp4 = check new (host = HOST, user = USER, password = PASSWORD, database = DB, port = PORT);

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
