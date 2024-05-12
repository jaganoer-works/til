module.exports.handler = async (event) => {
  return {
    // statusCode: 200,
    headers: {
      "Access-Control-Allow-Origin": "https://www.example.com",
      "Access-Control-Allow-Credentials": true,
    },
    body: JSON.stringify(
      {
        message: "Go Serverless v3.0! Your function executed successfully!",
        input: event,
      },
      null,
      2
    ),
  };
};
