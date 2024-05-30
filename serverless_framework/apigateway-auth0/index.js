module.exports.helloHandler = async (event) => {
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Hello, world!",
    }),
  };
};

module.exports.goodbyeHandler = async (event) => {
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Goodbye, world!",
    }),
  };
};
