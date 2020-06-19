const express = require("express");
const bodyParser = require("body-parser");
const fetch = require("node-fetch");

const app = express();

const PORT = process.env.PORT || 3000;

app.use(bodyParser.json());

const HASURA_GRAPHQL_ENDPOINT = process.env.GRAPHQL_ENDPOINT || 'http://localhost:8080/v1/graphql';
const HASURA_GRAPHQL_ADMIN_SECRET=process.env.ADMIN_SECRET || "adminsecret";

const execute = async (query, variables, reqHeaders) => {
    const fetchResponse = await fetch(
	      HASURA_GRAPHQL_ENDPOINT,
        {
            method: 'POST',
            headers: reqHeaders || {},
            body: JSON.stringify({
                query: query,
                variables
            })
        }
    );
    return await fetchResponse.json();
};

const createShipment = async () => {
    console.log("creating shipment");
    const query = `mutation { createShipment(object:{address:"something"}) { id  status }}`
    console.log(query);
    const fetchResponse = await fetch(
	      "https://logistics-api-2.herokuapp.com/v1/graphql",
        {
            method: 'POST',
            headers: {},
            body: JSON.stringify({
                query: query
            })
        }
    );
    return await fetchResponse.json();

}


const INSERT_ORDER = `
  mutation ($product_id: smallint, $quantity: smallint, $shipment_id: uuid) {
    insert_orders_one(object: {product_id: $product_id, quantity: $quantity, shipment_id: $shipment_id}) {
      order_id
      shipment_id
    }
  }
`

app.post('/placeOrder', async (req, res) => {
    console.log(req.body)
    const session_variables = req.body.session_variables;
    const { product_id, quantity } = req.body.input;

    const shipmentResponse = await createShipment();
    console.log(shipmentResponse);
    const shipment_id = shipmentResponse["data"]["createShipment"]["id"];
    console.log(shipment_id);
    const { data, errors } = await execute(INSERT_ORDER,
                                           { product_id: product_id, quantity: quantity, shipment_id: shipment_id },
                                           { "x-hasura-admin-secret": HASURA_GRAPHQL_ADMIN_SECRET
                                           , "x-hasura-role": session_variables["x-hasura-role"]
                                           , "x-hasura-user-id": session_variables["x-hasura-user-id"]
                                           , "x-hasura-use-backend-only-permissions": true
					   }
                                          );

    console.log(errors);
    var resp = data["insert_orders_one"];
    return res.json({
      order_id: resp.order_id
    });

});

app.listen(PORT, () => console.log(`Listening at http://localhost:${PORT}`))


