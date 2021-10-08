import { Handler } from "aws-lambda";
import fetch from "node-fetch";
import axios from "axios";

export const handler: Handler = async (event) => {
  const message = `Hello SSI! ${JSON.stringify(event)}`;

  try {
    throw Error("This should be caught?");
  } catch (e) {
    console.log("Caught an error");
    console.error(e);
  }

  // node-fetch
  try {
    const response = await fetch(
      "https://jsonplaceholder.typicode.com/todos/1"
    );
    const body = await response.json();
    console.log(body);
  } catch (e) {
    console.error(e);
  }

  // axios
  try {
    const response = await axios.get(
      "https://jsonplaceholder.typicode.com/todos/1"
    );
    console.log(response.data);
  } catch (e) {
    console.error(e);
  }

  return {
    statusCode: 200,
    body: message,
  };
};
